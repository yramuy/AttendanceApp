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
import 'package:maintenanceapp/views/loginscreen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

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

  List districts = [
    {"id": "", "name": "All Districts"},
    {"id": 1, "name": "AGP"},
    {"id": 2, "name": "GWK"},
    {"id": 3, "name": "AKP"},
    {"id": 4, "name": "City"}
  ];
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

  @override
  void onInit() {
    if (argumentData != null) {
      log("argumentData123 ${argumentData}");
      meetingDate = argumentData;
    }
    getLastSunday();
    loadMeetingAttendance();
    loadSaints();
    getMenus();
    loadCategoryWiseSaints();
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

  datePicker(BuildContext context) async {
    currentDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    ))!;
    meetingDate = Jiffy(currentDate).format('yyyy-MM-dd');
    loadMeetingAttendance();
    update();
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
      "meetingType": meetingTypeId.toString()
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
          // dormantSaints = responseBody['counts']['dormantSaints'];
          log("Total Saints ${responseBody['total'].toString()}");
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

  loadMeetingAttendance() async {
    final body = jsonEncode(
        {"district": districtId.toString(), "date": meetingDate.toString()});
    log("Encode Body $body");
    await ApiService.post("meetingAttendance", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          log("Attendance Meetings $responseBody");
          sundayMeeting = responseBody['sundayMeeting'];
          tuesdayMeeting = responseBody['tuesdayMeeting'];
          fridayMeeting = responseBody['fridayMeeting'];

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

  updateAttendeesSunTotalPercentage(key) {
    var sundayTotal = sundayMeeting.fold<int>(0,
        (sum, sunday) => sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

    log("sundayTotal $sundayTotal");

// Ensure `total` is a valid number
    double parsedTotal = double.tryParse(total) ?? 0;
    if (parsedTotal == 0) {
      log("Warning: Total is zero, avoiding division by zero.");
      return "${sundayTotal.toString()} (0%)";
    }

// Calculate percentage safely
    double percentage = (sundayTotal / parsedTotal) * 100;
    int finalPercentage = percentage.isFinite ? percentage.round() : 0;

    var totalPercentage = "${sundayTotal.toString()} (${finalPercentage}%)";
    return totalPercentage;
  }

  updateAttendeesTuesTotalPercentage(key) {
    var tuesTotal = tuesdayMeeting.fold<int>(0,
        (sum, sunday) => sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

    log("tuesTotal $tuesTotal");

// Ensure `total` is a valid number
    double parsedTotal = double.tryParse(total) ?? 0;
    if (parsedTotal == 0) {
      log("Warning: Total is zero, avoiding division by zero.");
      return "${tuesTotal.toString()} (0%)";
    }

// Calculate percentage safely
    double percentage = (tuesTotal / parsedTotal) * 100;
    log("percentage $percentage");

// Ensure percentage is finite before rounding
    int finalPercentage = percentage.isFinite ? percentage.round() : 0;
    var totalPercentage = "${tuesTotal.toString()} (${finalPercentage}%)";
    return totalPercentage;
  }

  updateAttendeesFriTotalPercentage(key) {
    var fridayTotal = fridayMeeting.fold<int>(0,
        (sum, sunday) => sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

    log("fridayTotal $fridayTotal");

// Ensure `total` is a valid number
    double parsedTotal = double.tryParse(total) ?? 0;
    if (parsedTotal == 0) {
      log("Warning: Total is zero, avoiding division by zero.");
      return "${fridayTotal.toString()} (0%)";
    }

// Calculate percentage safely
    double percentage = (fridayTotal / parsedTotal) * 100;
    int finalPercentage = percentage.isFinite ? percentage.round() : 0;

    var totalPercentage = "${fridayTotal.toString()} (${finalPercentage}%)";
    return totalPercentage;
  }

  generatePdfReport() async {
    final pdf = pw.Document();

    var agpGs = getCountByDistrict(generalSaints, "1");
    var gwkGs = getCountByDistrict(generalSaints, "2");
    var akpGs = getCountByDistrict(generalSaints, "3");
    var cityGs = getCountByDistrict(generalSaints, "4");

    var agpYws = getCountByDistrict(workingSaints, "1");
    var gwkYws = getCountByDistrict(workingSaints, "2");
    var akpYws = getCountByDistrict(workingSaints, "3");
    var cityYws = getCountByDistrict(workingSaints, "4");

    var agpCs = getCountByDistrict(youngOne, "1");
    var gwkCs = getCountByDistrict(youngOne, "2");
    var akpCs = getCountByDistrict(youngOne, "3");
    var cityCs = getCountByDistrict(youngOne, "4");

    var agpTng = getCountByDistrict(teenagers, "1");
    var gwkTng = getCountByDistrict(teenagers, "2");
    var akpTng = getCountByDistrict(teenagers, "3");
    var cityTng = getCountByDistrict(teenagers, "4");

    var agpChild = getCountByDistrict(children, "1");
    var gwkChild = getCountByDistrict(children, "2");
    var akpChild = getCountByDistrict(children, "3");
    var cityChild = getCountByDistrict(children, "4");

    var agpDs = getCountByDistrict(dormantSaints, "1");
    var gwkDs = getCountByDistrict(dormantSaints, "2");
    var akpDs = getCountByDistrict(dormantSaints, "3");
    var cityDs = getCountByDistrict(dormantSaints, "4");

    var gsTotal = getTotalCount(generalSaints);
    var ywsTotal = getTotalCount(workingSaints);
    var csTotal = getTotalCount(youngOne);
    var tngTotal = getTotalCount(teenagers);
    var childTotal = getTotalCount(children);
    var dsTotal = getTotalCount(dormantSaints);

    var agpLtm = getPresentByDistrict(sundayMeeting, "1");
    var cityLtm = getPresentByDistrict(sundayMeeting, "4");
    var akpLtm = getPresentByDistrict(sundayMeeting, "3");
    var gwkLtm = getPresentByDistrict(sundayMeeting, "2");
    var ltmTotal = updateAttendeesSunTotalPercentage('Present');

    var agpPm = getPresentByDistrict(tuesdayMeeting, "1");
    var cityPm = getPresentByDistrict(tuesdayMeeting, "4");
    var akpPm = getPresentByDistrict(tuesdayMeeting, "3");
    var gwkPm = getPresentByDistrict(tuesdayMeeting, "2");
    var pmTotal = updateAttendeesTuesTotalPercentage('Present');

    var agpGm = getPresentByDistrict(fridayMeeting, "1");
    var cityGm = getPresentByDistrict(fridayMeeting, "4");
    var akpGm = getPresentByDistrict(fridayMeeting, "3");
    var gwkGm = getPresentByDistrict(fridayMeeting, "2");
    var gmTotal = updateAttendeesFriTotalPercentage('Present');

    var agpAbLtm = getAbsentByDistrict(sundayMeeting, "1");
    var cityALtm = getAbsentByDistrict(sundayMeeting, "4");
    var akpLAtm = getAbsentByDistrict(sundayMeeting, "3");
    var gwkLAtm = getAbsentByDistrict(sundayMeeting, "2");
    var ltmATotal = updateAttendeesSunTotalPercentage('Absent');

    var agpAPm = getAbsentByDistrict(tuesdayMeeting, "1");
    var cityAPm = getAbsentByDistrict(tuesdayMeeting, "4");
    var akpAPm = getAbsentByDistrict(tuesdayMeeting, "3");
    var gwkAPm = getAbsentByDistrict(tuesdayMeeting, "2");
    var pmATotal = updateAttendeesTuesTotalPercentage('Absent');

    var agpAGm = getAbsentByDistrict(fridayMeeting, "1");
    var cityAGm = getAbsentByDistrict(fridayMeeting, "4");
    var akpAGm = getAbsentByDistrict(fridayMeeting, "3");
    var gwkAGm = getAbsentByDistrict(fridayMeeting, "2");
    var gmATotal = updateAttendeesFriTotalPercentage('Absent');

    var agpPChildLtm =
        getPresentAbsentByDistrict(sundayMeeting, "1", "childPresent");
    var cityPChildLtm =
        getPresentAbsentByDistrict(sundayMeeting, "4", "childPresent");
    var akpPChildLtm =
        getPresentAbsentByDistrict(sundayMeeting, "3", "childPresent");
    var gwkPChildLtm =
        getPresentAbsentByDistrict(sundayMeeting, "2", "childPresent");
    var ltmPChildTotal = updateChildTotal('childPresent');

    var agpAChildLtm =
        getPresentAbsentByDistrict(sundayMeeting, "1", "childAbsent");
    var cityAChildLtm =
        getPresentAbsentByDistrict(sundayMeeting, "4", "childAbsent");
    var akpAChildLtm =
        getPresentAbsentByDistrict(sundayMeeting, "3", "childAbsent");
    var gwkAChildLtm =
        getPresentAbsentByDistrict(sundayMeeting, "2", "childAbsent");
    var ltmAChildTotal = updateChildTotal('childAbsent');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("$meetingDate Weekly Report",
                    style: pw.TextStyle(
                        fontSize: 30, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text("Area wise saints",
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ["Total Saints", "Agp", "City", "AKP", "Gwk"],
                  data: [
                    [
                      "$total",
                      "$agpCount",
                      "$cityCount",
                      "$akpCount",
                      "$gwkCount"
                    ]
                  ],
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                ),
                pw.SizedBox(height: 20),
                pw.Text("Category wise saints",
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ["Category", "Agp", "City", "AKP", "Gwk", "Total"],
                  data: [
                    [
                      "General Saints",
                      "$agpGs",
                      "$cityGs",
                      "$akpGs",
                      "$gwkGs",
                      "$gsTotal"
                    ],
                    [
                      "Young Working Saints",
                      "$agpYws",
                      "$cityYws",
                      "$akpYws",
                      "$gwkYws",
                      "$ywsTotal"
                    ],
                    [
                      "College Students",
                      "$agpCs",
                      "$cityCs",
                      "$akpCs",
                      "$gwkCs",
                      "$csTotal"
                    ],
                    [
                      "Teenagers",
                      "$agpTng",
                      "$cityTng",
                      "$akpTng",
                      "$gwkTng",
                      "$tngTotal"
                    ],
                    [
                      "Children",
                      "$agpChild",
                      "$cityChild",
                      "$akpChild",
                      "$gwkChild",
                      "$childTotal"
                    ],
                    [
                      "Dormant Saints",
                      "$agpDs",
                      "$cityDs",
                      "$akpDs",
                      "$gwkDs",
                      "$dsTotal"
                    ],
                  ],
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                ),
                pw.SizedBox(height: 20),
                pw.Text("Attendees",
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: [
                    "Meetings",
                    "Agp",
                    "City",
                    "AKP",
                    "Gwk",
                    "Total(%)"
                  ],
                  data: [
                    [
                      "Lord's Table Meeting",
                      "$agpLtm",
                      "$cityLtm",
                      "$akpLtm",
                      "$gwkLtm",
                      "$ltmTotal"
                    ],
                    [
                      "Prayer Meeting",
                      "$agpPm",
                      "$cityPm",
                      "$akpPm",
                      "$gwkPm",
                      "$pmTotal"
                    ],
                    [
                      "Group Meeting",
                      "$agpGm",
                      "$cityGm",
                      "$akpGm",
                      "$gwkGm",
                      "$gmTotal"
                    ],
                  ],
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                ),
                pw.SizedBox(height: 20),
                pw.Text("Absentees",
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: [
                    "Meetings",
                    "Agp",
                    "City",
                    "AKP",
                    "Gwk",
                    "Total(%)"
                  ],
                  data: [
                    [
                      "Lord's Table Meeting",
                      "$agpAbLtm",
                      "$cityALtm",
                      "$akpLAtm",
                      "$gwkLAtm",
                      "$ltmATotal"
                    ],
                    [
                      "Prayer Meeting",
                      "$agpAPm",
                      "$cityAPm",
                      "$akpAPm",
                      "$gwkAPm",
                      "$pmATotal"
                    ],
                    [
                      "Group Meeting",
                      "$agpAGm",
                      "$cityAGm",
                      "$akpAGm",
                      "$gwkAGm",
                      "$gmATotal"
                    ],
                  ],
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                ),
                pw.SizedBox(height: 30),
                pw.Text("Children Lords table meeting attendance",
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ["Attendance", "Agp", "City", "AKP", "Gwk", "Total"],
                  data: [
                    [
                      "Present",
                      "$agpPChildLtm",
                      "$cityPChildLtm",
                      "$akpPChildLtm",
                      "$gwkPChildLtm",
                      "$ltmPChildTotal"
                    ],
                    [
                      "Absent",
                      "$agpAChildLtm",
                      "$cityAChildLtm",
                      "$akpAChildLtm",
                      "$gwkAChildLtm",
                      "$ltmAChildTotal"
                    ],
                  ],
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final directory = await getExternalStorageDirectory();
    final filePath = "${directory!.path}/attendance_report.pdf";
    final file = File(filePath);

    // Write the PDF file
    await file.writeAsBytes(await pdf.save());

    // Open the file
    OpenFile.open(filePath);
  }

  String getCountByDistrict(generalSaints, districtID) {
    return generalSaints
        .firstWhere(
          (sunday) => sunday['districtID'].toString() == districtID,
          orElse: () => {"count": "0"},
        )['count']
        .toString();
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

  getTotalCount(List generalSaints) {
    return generalSaints
        .fold<int>(0, (sum, gen) => sum + int.parse(gen['count'].toString()))
        .toString();
  }

  getPresentByDistrict(List sundayMeeting, String districtID) {
    return sundayMeeting
        .firstWhere(
          (sunday) => sunday['districtID'].toString() == districtID,
          orElse: () => {"Present": "0"},
        )['Present']
        .toString();
  }

  getPresentAbsentByDistrict(
      List sundayMeeting, String districtID, String type) {
    return sundayMeeting
        .firstWhere(
          (sunday) => sunday['districtID'].toString() == districtID,
          orElse: () => {"$type": "0"},
        )['$type']
        .toString();
  }

  getAbsentByDistrict(List sundayMeeting, String districtID) {
    return sundayMeeting
        .firstWhere(
          (sunday) => sunday['districtID'].toString() == districtID,
          orElse: () => {"Absent": "0"},
        )['Absent']
        .toString();
  }

  updateChildTotal(key) {
    var sundayTotal = sundayMeeting.fold<int>(0,
        (sum, sunday) => sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

    log("sundayChildTotal $sundayTotal");

    return sundayTotal;
  }
}
