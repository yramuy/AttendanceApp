import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../../apiservice/restapi.dart';
import '../../helpers/utilities.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class WeeklyReportController extends GetxController {
  String meetingDate = Jiffy(DateTime.now()).format('yyyy-MM-dd');
  late DateTime currentDate;
  List districts = [];
  List weeklyAttendance = [];

  @override
  void onInit() {
    // TODO: implement onInit

    loadDistricts(Utilities.locationID);
    super.onInit();
  }

  Future<void> loadDistricts(String? value) async {
    try {
      final responses = await Future.wait([
        ApiService.get("districts?location_id=$value"),
      ]);

      final response = responses[0];

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        districts = data['districts'];
        log("districts: $districts");
      } else {
        _showErrorSnackbar();
      }
    } catch (e) {
      log("Error in loadDropdownData: $e");
      _showErrorSnackbar();
    }

    update();
  }

  void _showErrorSnackbar() {
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      message: 'Something went wrong, Please retry later',
    );
  }

  datePicker(BuildContext context) async {
    currentDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    ))!;
    meetingDate = Jiffy(currentDate).format('yyyy-MM-dd');
    update();
  }

  handleReport(districtID,districtName) async {
    var body = jsonEncode({
      "location_id": Utilities.locationID,
      "district_id": districtID,
      "date": meetingDate
    });
    await ApiService.post("weeklyMeetingAttendance", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          weeklyAttendance = responseBody['weeklyAttendance'];
          log("weeklyAttendance $weeklyAttendance");
          loadPDFReport(districtName);
        }
      } else {
        Get.snackbar('Alert', 'Something went wrong, Please retry later',
            backgroundColor: Colors.blueAccent,
            barBlur: 20,
            overlayBlur: 5,
            colorText: Colors.white,
            animationDuration: const Duration(seconds: 3));
      }
    });

    update();
  }

  Future<pw.Font> loadCustomFont() async {
    final fontData = await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
    return pw.Font.ttf(fontData);
  }

  Future<void> loadPDFReport(districtName) async {
    final pdf = pw.Document();
    final customFont = await loadCustomFont();

    String reportTitle = meetingDate;
    String monthName = Jiffy(meetingDate, 'yyyy-MM-dd').format('MMMM');

    // Safe cast
    final List<Map<String, dynamic>> attendanceList =
    weeklyAttendance.cast<Map<String, dynamic>>();

    // Extract meeting types dynamically (from first record)
    final List<String> meetingTypes =
    (attendanceList.first['attendance'] as List)
        .map<String>((e) => e['meeting_type'].toString())
        .toList();

    int sno = 1;

    // ---- Calculate summary counts ----
    final Map<String, Map<String, int>> meetingSummary = {};

    for (final meetingType in meetingTypes) {
      int present = 0;
      int absent = 0;

      for (final item in attendanceList) {
        final List attendance = item['attendance'];

        final meeting = attendance.firstWhere(
              (m) =>
          m['meeting_type'].toString().trim().toLowerCase() ==
              meetingType.trim().toLowerCase(),
          orElse: () => {'attendance': 0},
        );

        if (meeting['attendance'] == 1) {
          present++;
        } else {
          absent++;
        }
      }

      meetingSummary[meetingType] = {
        'present': present,
        'absent': absent,
      };
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: customFont,
          bold: customFont,
        ),
        build: (context) {
          return [
            pw.Text(
              "$reportTitle $districtName Report",
              style: pw.TextStyle(
                fontSize: 26,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 6),

            // pw.Text(
            //   "Weekly Attendance - $monthName",
            //   style: pw.TextStyle(
            //     fontSize: 18,
            //     fontWeight: pw.FontWeight.bold,
            //   ),
            // ),
            // pw.SizedBox(height: 12),

            // ================= TABLE =================
            pw.Table(
              border: pw.TableBorder.all(width: 0.8),
              defaultVerticalAlignment:
              pw.TableCellVerticalAlignment.middle,
              children: [

                // -------- SUMMARY ROW (TOP) --------
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _headerCell(''),
                    _headerCell(''),

                    ...meetingTypes.map((meeting) {
                      final summary = meetingSummary[meeting]!;

                      return pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              'Present : ${summary['present']}',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.green,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              'Absent : ${summary['absent']}',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
                // -------- HEADER ROW --------
                pw.TableRow(
                  decoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _headerCell("Sno"),
                    _headerCell("Name"),

                    // One column per meeting
                    ...meetingTypes.map(
                          (meeting) => _headerCell(meeting),
                    ),
                  ],
                ),

                // -------- DATA ROWS --------
                ...attendanceList.map((item) {
                  final List attendance = item['attendance'];

                  return pw.TableRow(
                    children: [
                      _cell((sno++).toString()),
                      _cell(item['name'].toString()),

                      // P / A per meeting (FIXED)
                      ...meetingTypes.map((meetingType) {
                        final meeting = attendance.firstWhere(
                              (m) =>
                          m['meeting_type']
                              .toString()
                              .trim()
                              .toLowerCase() ==
                              meetingType.trim().toLowerCase(),
                          orElse: () => {'attendance': 0},
                        );

                        final bool isPresent = meeting['attendance'] == 1;

                        return _statusCell(isPresent);
                      }),
                    ],
                  );
                }).toList(),
              ],
            ),
          ];
        },
      ),
    );

    final directory = await getExternalStorageDirectory();
    final filePath = "${directory!.path}/${reportTitle}_weekly_report.pdf";
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(filePath);
  }

  pw.Widget _headerCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 9,
        ),
      ),
    );
  }

  pw.Widget _cell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(fontSize: 11),
      ),
    );
  }

  pw.Widget _statusCell(bool isPresent) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Center(
        child: pw.Text(
          isPresent ? 'Present' : 'Absent',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: isPresent ? PdfColors.green : PdfColors.red,
          ),
        ),
      ),
    );
  }
}
