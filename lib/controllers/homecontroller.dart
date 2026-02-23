import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:maintenanceapp/apiservice/restapi.dart';
import 'package:maintenanceapp/helpers/utilities.dart';
import 'package:maintenanceapp/views/loginscreen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../views/saint/saints.dart';

class HomeController extends GetxController {
  String title = "HOME";
  var RoleId;
  List menus = [];
  bool isLoading = true;
  int selectedIndex = 0;
  // final LocalAuthentication auth = LocalAuthentication();
  // late bool isAvailable = false;
  // bool checkBiometrics = false;
  // String authorized = 'Not Authorized';
  // bool authenticated = false;
  final List<String> slideImages = [
    "assets/images/7681058.jpg",
    "assets/images/8910521.jpg",
    "assets/images/30123778_7652250.jpg",
    "assets/images/30586690_7681056.jpg",
    "assets/images/job153-wit-70.jpg",
  ];
  final PageController pageController = PageController();
  late Timer pageTimer;

  // List districts = [
  //   {"id": "", "name": "All Districts"},
  //   {"id": 1, "name": "AGP"},
  //   {"id": 2, "name": "GWK"},
  //   {"id": 3, "name": "AKP"},
  //   {"id": 4, "name": "City"}
  // ];
  String districtId = "0";
  String meetingTypeId = "0";
  String meetingDate = Jiffy(DateTime.now()).format('yyyy-MM-dd');
  late DateTime currentDate;
  List saints = [];
  String total = '0';
  int agpCount = 0;
  int gwkCount = 0;
  int akpCount = 0;
  int cityCount = 0;
  String agpChildCount = "0";
  String gwkChildCount = "0";
  String akpChildCount = "0";
  String cityChildCount = "0";
  String totalChildren = "0";
  String dormantSaint = "0";
  List sundayMeeting = [];
  List tuesdayMeeting = [];
  List fridayMeeting = [];
  List homeMeeting = [];
  List gospelMeeting = [];
  List generalSaints = [];
  List workingSaints = [];
  List youngOne = [];
  List children = [];
  List dormantSaints = [];
  List teenagers = [];
  dynamic argumentData = Get.arguments;
  String attendanceType = 'week';
  List sundayMeetingMonth = [];
  List tuesdayMeetingMonth = [];
  List fridayMeetingMonth = [];
  List homeMeetingMonth = [];
  List gospelMeetingMonth = [];

  int tuesday = 0;
  int friday = 0;
  int sunday = 0;

  List absentees = [];
  List lordsDayAbsentees = [];
  List areaWiseSaints = [];
  List categoryWiseSaints = [];
  List<String> cwDistricts = [];
  List<String> categories = [];
  List meetingAttendance = [];
  List<String> meetingTypeDistricts = [];
  List<String> meetingTypes = [];
  List monthlyAttendance = [];

  @override
  void onInit() {
    updateLocationData();

    if (argumentData != null) {
      log("argumentData123 ${argumentData}");
      meetingDate = argumentData;
    }

    getLastSunday();
    loadSaints();
    getMenus();
    loadCategoryWiseSaints();
    loadPresentAbsentAttendance('weekly');

    pageTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (pageController.hasClients) {
        int nextPage = (pageController.page ?? 0).toInt() + 1;
        if (nextPage == slideImages.length) {
          nextPage = 0; // Loop back to the first page
        }
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
    super.onInit();
    //checkBiometric();
  }

  @override
  void dispose() {
    pageTimer.cancel();
    pageController.dispose();
    super.dispose();
  }

  updateLocationData() async {
    log("Location ID 98 : ${Utilities.locationID}");
    log("Location Name 99 : ${Utilities.locationName}");
  }

  Future<pw.Font> loadCustomFont() async {
    final fontData = await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
    return pw.Font.ttf(fontData);
  }

  datePicker(BuildContext context) async {
    currentDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    ))!;
    meetingDate = Jiffy(currentDate).format('yyyy-MM-dd');
    loadWeekdayCounts();
    loadSaints();
    loadPresentAbsentAttendance('weekly');
    update();
  }

  buildColumns() {
    return areaWiseSaints.map((item) {
      return DataColumn(
        label: Text(
          item['area'].toString(),
          style: const TextStyle(
            color: Colors.black,
            fontFamily: "Inter-Medium",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList();
  }

  buildRows() {
    return [
      DataRow(
        cells: areaWiseSaints.map((item) {
          return DataCell(
            GestureDetector(
              onTap: () {
                Get.to(
                  () => const Saints(),
                  arguments: {
                    "district": item['area'].toString(), // or map id here
                    "saintType": "0",
                  },
                );
              },
              child: Text(
                item['count'].toString(),
                style: const TextStyle(
                  color: Colors.blue,
                  fontFamily: "Inter-Medium",
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ];
  }

  loadWeekdayCounts() {
    DateTime dateTime = DateTime.parse(meetingDate);
    int year = dateTime.year;
    int month = dateTime.month;
    int totalDays =
        DateTime(year, month + 1, 0).day; // Get last day of the month

    int tuesdayCount = 0;
    int fridayCount = 0;
    int sundayCount = 0;

    for (int day = 1; day <= totalDays; day++) {
      DateTime currentDay = DateTime(year, month, day);

      if (currentDay.weekday == DateTime.tuesday) {
        tuesdayCount++;
      } else if (currentDay.weekday == DateTime.friday) {
        fridayCount++;
      } else if (currentDay.weekday == DateTime.sunday) {
        sundayCount++;
      }
    }

    // tuesday = tuesdayCount;
    // friday = fridayCount;
    // sunday = sundayCount;
    // update();

    return {
      'Tuesday': tuesdayCount,
      'Friday': fridayCount,
      'Sunday': sundayCount,
    };

    // tuesdayCount = tuesdayCount;
    // fridayCount = fridayCount;
    // sundayCount = sundayCount;
    // update();
    //
    // log("meetingDate $dateTime");
  }

  handleDistrict(String value) {
    districtId = value;
    update();
  }

  getMenus() async {
    SharedPreferences userPref = await SharedPreferences.getInstance();
    RoleId = userPref.getString('roleID');
    log("biometric");

    var body = jsonEncode({"parent_id": 0, "role_id": RoleId, "type": 'child'});

    await ApiService.post("menus", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          menus = responseBody['menus'];
        } else {
          Get.snackbar('Alert', responseBody['message'].toString(),
              backgroundColor: Colors.blueAccent,
              barBlur: 20,
              colorText: Colors.white,
              animationDuration: const Duration(seconds: 3));
        }
      } else {
        Get.snackbar('Alert', 'Something went wrong, Please retry later',
            backgroundColor: Colors.blueAccent,
            barBlur: 20,
            overlayBlur: 5,
            colorText: Colors.white,
            animationDuration: const Duration(seconds: 3));
      }
      isLoading = false;
      update();
    });
  }

  handleBottomMenu(int index) {
    selectedIndex = index;
    update();

    print(selectedIndex);
  }

  List<PieChartSectionData> getSections() {
    // Example data: area-wise counts
    final Map<String, int> areaCounts = {
      'AGP': agpCount,
      'GWK': gwkCount,
      'AKP': akpCount,
      'CITY': cityCount,
    };

    return areaCounts.entries.map((entry) {
      final String area = entry.key;
      final int count = entry.value;

      return PieChartSectionData(
        color: _getColorForArea(area),
        value: count.toDouble(),
        title: '$area\n$count',
        radius: 80,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getColorForArea(String area) {
    // Assign colors based on area
    switch (area) {
      case 'AGP':
        return Colors.blue;
      case 'GWK':
        return Colors.green;
      case 'AKP':
        return Colors.orange;
      case 'CITY':
        return Colors.purpleAccent;
      default:
        return Colors.grey;
    }
  }

  getLastSunday() {
    DateTime today = DateTime.now();
    DateTime previousDate = today.subtract(Duration(days: 1));
    String formattedDate =
        "${previousDate.year}-${previousDate.month.toString().padLeft(2, '0')}-${previousDate.day.toString().padLeft(2, '0')}";
    meetingDate = formattedDate;
    log("formattedDate $formattedDate");
    update(); // Example output: 2025-02-23
  }

  loadSaints() async {
    isLoading = true;
    final body = jsonEncode({
      "districtId": districtId.toString(),
      "typeId": "",
      "date": meetingDate.toString(),
      "meetingType": meetingTypeId.toString(),
      "classificationID": "",
      "locationId": Utilities.locationID
    });
    log("Encode Body $body");
    await ApiService.post("saints", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          log("Saints $responseBody");
          saints = responseBody['saints'];
          total = responseBody['total'].toString();
          agpCount = int.parse(responseBody['counts']['agpCount']);
          gwkCount = int.parse(responseBody['counts']['gwkCount']);
          akpCount = int.parse(responseBody['counts']['akpCount']);
          cityCount = int.parse(responseBody['counts']['cityCount']);
          agpChildCount = responseBody['counts']['agpChildCnt'];
          gwkChildCount = responseBody['counts']['gwkChildCnt'];
          akpChildCount = responseBody['counts']['akpChildCnt'];
          cityChildCount = responseBody['counts']['cityChildCnt'];
          totalChildren = responseBody['counts']['childrens'];
          areaWiseSaints = responseBody['areaWiseSaints'];
          categoryWiseSaints = responseBody['categoryWiseSaints'];
          log("areaWiseSaints ${areaWiseSaints}");
          log("Total Saints ${responseBody['total'].toString()}");
          isLoading = false;
          updateCategoryWiseSaints();
          update();
        } else {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: responseBody['message'].toString());
        }
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: 'Something went wrong, Please retry later');
      }
      update();
    });
    update();
  }

  loadPresentAbsentAttendance(type) async {
    final body = jsonEncode({
      "locationId": Utilities.locationID,
      "district": districtId.toString(),
      "date": meetingDate.toString(),
      'attendanceType': type.toString()
    });
    log("Encode Body $body");
    await ApiService.post("loadMeetingPresentAbsent", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          log("meetingAttendance Meetings $responseBody");
          if (type.toString() == "weekly") {
            meetingAttendance = responseBody['attendance'];
            extractDistrictsMeetingTypes();
          } else {
            monthlyAttendance = responseBody['attendance'];
            generateMonthReport(type);

          }

          update();
        } else {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: responseBody['message'].toString());
        }
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: 'Something went wrong, Please retry later');
      }
      update();
    });
    update();
  }

  extractDistrictsMeetingTypes() {
    // -------------------------------
    // Extract districts
    // -------------------------------
    meetingTypeDistricts =
        meetingAttendance.map<String>((e) => e['district'].toString()).toList();

    // -------------------------------
    // Extract unique categories
    // -------------------------------
    Set<String> meetingTypeSet = {};
    for (var d in meetingAttendance) {
      for (var c in d['meetingTypes']) {
        meetingTypeSet.add(c['meetingType']);
      }
    }
    meetingTypes = meetingTypeSet.toList();

    update();
  }

  // -------------------------------
  // Helper: get count
  // -------------------------------
  int getMeetingAttendanceCount(String district, String meetingType) {
    final dist = meetingAttendance.firstWhere(
      (e) => e['district'] == district,
      orElse: () => null,
    );

    if (dist == null) return 0;

    final mt = dist['meetingTypes'].firstWhere(
      (c) => c['meetingType'] == meetingType,
      orElse: () => null,
    );

    return mt == null ? 0 : int.parse(mt['present'].toString());
  }

  // Helper: get count
  // -------------------------------
  int getMeetingAbsentCount(String district, String meetingType) {
    final dist = meetingAttendance.firstWhere(
      (e) => e['district'] == district,
      orElse: () => null,
    );

    if (dist == null) return 0;

    final mt = dist['meetingTypes'].firstWhere(
      (c) => c['meetingType'] == meetingType,
      orElse: () => null,
    );

    return mt == null ? 0 : int.parse(mt['absent'].toString());
  }

  loadCategoryWiseSaints() async {
    await ApiService.get("categoryWiseSaints").then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          log("Attendance Meetings $responseBody");
          generalSaints = responseBody['generalSaints'];
          workingSaints = responseBody['workingSaints'];
          youngOne = responseBody['youngOne'];
          children = responseBody['children'];
          dormantSaints = responseBody['dormantSaints'];
          teenagers = responseBody['teenager'];
          isLoading = false;
          update();
        } else {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: responseBody['message'].toString());
        }
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: 'Something went wrong, Please retry later');
      }
      update();
    });
    update();
  }

  updateCategoryWiseSaints() {
    // -------------------------------
    // Extract districts
    // -------------------------------
    cwDistricts = categoryWiseSaints
        .map<String>((e) => e['district'].toString())
        .toList();

    // -------------------------------
    // Extract unique categories
    // -------------------------------

    Set<String> categorySet = {};
    for (var d in categoryWiseSaints) {
      for (var c in d['categories']) {
        categorySet.add(c['category']);
      }
    }
    categories = categorySet.toList();

    update();
  }

  // -------------------------------
  // Helper: get count
  // -------------------------------
  int getCategoryCount(String district, String category) {
    final dist = categoryWiseSaints.firstWhere(
      (e) => e['district'] == district,
      orElse: () => null,
    );

    if (dist == null) return 0;

    final cat = dist['categories'].firstWhere(
      (c) => c['category'] == category,
      orElse: () => null,
    );

    return cat == null ? 0 : int.parse(cat['count'].toString());
  }

  generateReport(reportType) async {

    final pdf = pw.Document();
    final customFont = await loadCustomFont();

    String monthName = Jiffy(meetingDate, 'yyyy-MM-dd').format('MMMM');

    String reportTitle = reportType.toString() == 'week'
        ? "$meetingDate Week"
        : "$monthName Month";



    int getCount(district, category) {
      final districtData = categoryWiseSaints.firstWhere(
            (e) => e['district'] == district,
        orElse: () => null,
      );

      if (districtData == null) return 0;

      final catData = districtData['categories'].firstWhere(
            (c) => c['category'] == category,
        orElse: () => null,
      );

      return catData == null ? 0 : catData['count'];
    }

    final List<String> districts =
    categoryWiseSaints.map((e) => e['district'].toString()).toList();

    final List<String> headers = ["Category", ...districts, "Total"];

    final List<List<String>> tableData = categories.map((category) {
      int rowTotal = 0;

      final List<String> row = [category];

      for (var district in districts) {
        final count = getCount(district, category);
        rowTotal += count;
        row.add(count.toString());
      }

      row.add(rowTotal.toString());
      return row;
    }).toList();

// ---------- Build Headers ----------
    List<String> buildHeaders() {
      return [
        'Meetings',
        ...meetingAttendance.map((d) => d['district'].toString()).toList(),
        'Total',
        'Percentage (%)',
      ];
    }

    // ---------- Build Rows ----------
    List<List<String>> buildRows({required bool isPresent}) {
      final List meetingTypes = meetingAttendance.first['meetingTypes'];


      return meetingTypes.map<List<String>>((meeting) {
        int total = 0;
        int oppositeTotal = 0;

        List<String> row = [
          meeting['meetingType'].toString(),
        ];

        for (var district in meetingAttendance) {
          final mt = district['meetingTypes'].firstWhere(
                (m) => m['meetingType'] == meeting['meetingType'],
          );

          final int value = isPresent ? mt['present'] : mt['absent'];
          final int opposite =
          isPresent ? mt['absent'] : mt['present'];

          total += value;
          oppositeTotal += opposite;

          row.add(value.toString());
        }

        var totalSaints = areaWiseSaints[0]['count'];

        log("totalSaints $totalSaints");
        final double percentage =
        totalSaints == 0 ? 0 : (total / totalSaints) * 100;

        row.add(total.toString());
        row.add('${percentage.toStringAsFixed(2)}%');

        return row;
      }).toList();
    }

    // Add 10 pages to the PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "$reportTitle Report",
                  style: pw.TextStyle(
                    fontSize: 30,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),

                pw.Text(
                  "Area wise saints",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),

                pw.Table.fromTextArray(
                  headers: ["Area", "Count"],
                  data: areaWiseSaints.map<List<String>>((item) {
                    return [
                      item['area'].toString(),
                      item['count'].toString(),
                    ];
                  }).toList(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                ),

                pw.SizedBox(height: 20),
                pw.Text("Category wise saints",
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: headers,
                  data: tableData,
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                ),
                pw.SizedBox(height: 50),
                // =================== ATTENDEES ===================
                pw.Text("Attendees",
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: buildHeaders(),
                  data: buildRows(isPresent: true),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                ),
                pw.SizedBox(height: 20),
                // =================== ABSENTEES ===================
                pw.Text("Absentees",
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: buildHeaders(),
                  data: buildRows(isPresent: false),
                  headerStyle: pw.TextStyle(
                      font: customFont, fontWeight: pw.FontWeight.bold),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // You can also use a package like `share_plus` to share the file

    final directory = await getExternalStorageDirectory();
    final filePath = "${directory!.path}/${reportTitle}_report.pdf";
    final file = File(filePath);

    // Write the PDF file
    await file.writeAsBytes(await pdf.save());

    // Open the file
    OpenFile.open(filePath);
  }

  handleReport(type) {
    loadPresentAbsentAttendance('monthly');
  }

  Future<void> generateMonthReport(reportType) async {
    // ================= WEEKDAY COUNTS =================
    var counts = loadWeekdayCounts();
    int tuesday = counts['Tuesday'] ?? 0;
    int friday  = counts['Friday'] ?? 0;
    int sunday  = counts['Sunday'] ?? 0;

    log("Tuesday $tuesday");
    log("Friday $friday");
    log("Sunday $sunday");

    final pdf = pw.Document();
    final customFont = await loadCustomFont();

    String monthName = Jiffy(meetingDate, 'yyyy-MM-dd').format('MMMM');
    String reportTitle = "$monthName Month";

    // ================= CATEGORY COUNT =================
    int getCount(district, category) {
      final districtData = categoryWiseSaints.firstWhere(
            (e) => e['district'] == district,
        orElse: () => null,
      );

      if (districtData == null) return 0;

      final catData = districtData['categories'].firstWhere(
            (c) => c['category'] == category,
        orElse: () => null,
      );

      return catData == null ? 0 : catData['count'];
    }

    final List<String> districts =
    categoryWiseSaints.map((e) => e['district'].toString()).toList();

    final List<String> headers = ["Category", ...districts, "Total"];

    final List<List<String>> tableData = categories.map((category) {
      int rowTotal = 0;
      final List<String> row = [category];

      for (var district in districts) {
        final count = getCount(district, category);
        rowTotal += count;
        row.add(count.toString());
      }

      row.add(rowTotal.toString());
      return row;
    }).toList();

    // ================= MEETING DIVISOR =================
    int getMeetingDivisor(String meetingType) {
      final type = meetingType.toLowerCase();

      if (type.contains('Lords')) {
        return sunday == 0 ? 1 : sunday;
      } else if (type.contains('Prayer')) {
        return tuesday == 0 ? 1 : tuesday;
      } else if (type.contains('Group')) {
        return friday == 0 ? 1 : friday;
      }
      return 1; // no division
    }

    // ================= TABLE HEADERS =================
    List<String> buildHeaders() {
      return [
        'Meetings',
        ...monthlyAttendance
            .map((d) => d['district'].toString())
            .toList(),
        'Total',
        'Percentage (%)',
      ];
    }

    // ================= TABLE ROWS =================
    List<List<String>> buildRows({required bool isPresent}) {
      final List meetingTypes = monthlyAttendance.first['meetingTypes'];

      return meetingTypes.map<List<String>>((meeting) {
        int total = 0;

        List<String> row = [
          meeting['meetingType'].toString(),
        ];

        final int divisor =
        getMeetingDivisor(meeting['meetingType'].toString());

        for (var district in monthlyAttendance) {
          final mt = district['meetingTypes'].firstWhere(
                (m) => m['meetingType'] == meeting['meetingType'],
          );

          int value = isPresent ? mt['present'] : mt['absent'];

          // ===== APPLY WEEKDAY DIVISION =====
          if (divisor > 1) {
            value = (value / divisor).round();
          }

          total += value;
          row.add(value.toString());
        }

        int totalSaints = areaWiseSaints[0]['count'];

        final double percentage =
        totalSaints == 0 ? 0 : (total / totalSaints) * 100;

        row.add(total.toString());
        row.add('${percentage.toStringAsFixed(2)}%');

        return row;
      }).toList();
    }

    // ================= PDF PAGE =================
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "$reportTitle Report",
                style: pw.TextStyle(
                  fontSize: 30,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),

              // ===== AREA WISE =====
              pw.Text("Area wise saints",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              pw.Table.fromTextArray(
                headers: ["Area", "Count"],
                data: areaWiseSaints.map<List<String>>((item) {
                  return [
                    item['area'].toString(),
                    item['count'].toString(),
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerAlignment: pw.Alignment.center,
                cellAlignment: pw.Alignment.center,
              ),

              pw.SizedBox(height: 20),

              // ===== CATEGORY WISE =====
              pw.Text("Category wise saints",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              pw.Table.fromTextArray(
                headers: headers,
                data: tableData,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerAlignment: pw.Alignment.center,
                cellAlignment: pw.Alignment.center,
              ),

              pw.SizedBox(height: 40),

              // ===== ATTENDEES =====
              pw.Text("Attendees",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              pw.Table.fromTextArray(
                headers: buildHeaders(),
                data: buildRows(isPresent: true),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerAlignment: pw.Alignment.center,
                cellAlignment: pw.Alignment.center,
              ),

              pw.SizedBox(height: 20),

              // ===== ABSENTEES =====
              pw.Text("Absentees",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              pw.Table.fromTextArray(
                headers: buildHeaders(),
                data: buildRows(isPresent: false),
                headerStyle: pw.TextStyle(
                    font: customFont, fontWeight: pw.FontWeight.bold),
                headerAlignment: pw.Alignment.center,
                cellAlignment: pw.Alignment.center,
              ),
            ],
          ),
        ],
      ),
    );

    // ================= SAVE & OPEN =================
    final directory = await getExternalStorageDirectory();
    final filePath = "${directory!.path}/${reportTitle}_report.pdf";
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());
    OpenFile.open(filePath);
  }


  logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("userID", "");
    pref.setString("name", "");
    pref.setString("userName", "");
    pref.setString("roleName", "");
    pref.setString("roleID", "");
    pref.setString("userMob", "");
    pref.setString("email", "");
    pref.setBool("isLogin", false);

    Get.offAll(() => const LoginScreen());
  }


  updateChildTotal(key) {
    var sundayTotal = sundayMeeting.fold<int>(0,
        (sum, sunday) => sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

    log("sundayChildTotal $sundayTotal");

    return sundayTotal;
  }
}
