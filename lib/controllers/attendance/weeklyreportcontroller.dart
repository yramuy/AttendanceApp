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

  handleReport(districtID) async {
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
          loadPDFReport();
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



  Future<void> loadPDFReport() async {
    final pdf = pw.Document();
    final customFont = await loadCustomFont();

    String reportTitle = meetingDate;
    String monthName = Jiffy(meetingDate, 'yyyy-MM-dd').format('MMMM');

    const int chunkSize = 20;

    // ✅ FIX: Cast List<dynamic> → List<Map<String, dynamic>>
    final List<Map<String, dynamic>> attendanceList =
    weeklyAttendance.cast<Map<String, dynamic>>();

    // Split data into chunks
    List<List<Map<String, dynamic>>> chunks = [];
    for (int i = 0; i < attendanceList.length; i += chunkSize) {
      chunks.add(
        attendanceList.sublist(
          i,
          i + chunkSize > attendanceList.length
              ? attendanceList.length
              : i + chunkSize,
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: customFont,
          bold: customFont,
        ),
        build: (context) {
          return chunks.map((chunk) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "$reportTitle Report",
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 5),

                pw.Text(
                  "Month : $monthName",
                  style: const pw.TextStyle(fontSize: 14),
                ),

                pw.SizedBox(height: 15),

                pw.Text(
                  "Weekly Attendance",
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 10),

                pw.Table(
                  border: pw.TableBorder.all(width: 0.8),
                  children: [
                    pw.TableRow(
                      decoration:
                      const pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            "Name",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ...chunk.map((item) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              item['name']?.toString() ?? '',
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),

                pw.SizedBox(height: 20),
              ],
            );
          }).toList();
        },
      ),
    );

    final directory = await getExternalStorageDirectory();
    final filePath = "${directory!.path}/${reportTitle}_report.pdf";
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(filePath);
  }
}
