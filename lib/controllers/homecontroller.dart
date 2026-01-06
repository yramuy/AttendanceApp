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

  @override
  void onInit() {
    if (argumentData != null) {
      log("argumentData123 ${argumentData}");
      meetingDate = argumentData;
    }

    log("Location ID 98 : ${Utilities.locationID}");
    log("Location Name 99 : ${Utilities.locationName}");
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
    loadMeetingAttendance();
    loadSaints();
    update();
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
      "classificationID": ""
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
          getAllMeetingsAbsentees();
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

  getAllMeetingsAbsentees() {
    absentees = [];
    lordsDayAbsentees = [];
    var sno1 = 1;
    var sno2 = 1;
    for (int i = 0; i < saints.length; i++) {
      var meetingAttendance = saints[i]['meetingAttendance'];
      if (meetingAttendance['sundayMeeting'].toString() == '0' &&
          meetingAttendance['tuesdayMeeting'].toString() == '0' &&
          meetingAttendance['fridayMeeting'].toString() == '0') {
        var absentsEncode = jsonEncode({
          "sno": sno1++,
          "name": saints[i]['name'].toString(),
          "district": saints[i]['district'].toString()
        });

        var absentsDecode = jsonDecode(absentsEncode);

        absentees.add(absentsDecode);
      }
      if (meetingAttendance['sundayMeeting'].toString() == '0') {
        var absentsEncode = jsonEncode({
          "sno": sno2++,
          "name": saints[i]['name'].toString(),
          "district": saints[i]['district'].toString()
        });

        var absentsDecode = jsonDecode(absentsEncode);

        lordsDayAbsentees.add(absentsDecode);
      }

      // log("MeetingAttendance $meetingAttendance");
      // var absents = jsonEncode({});
    }

    log("Absentees $absentees");
    log("lordsDayAbsentees $lordsDayAbsentees");
    // log("Absentees Saints $saints");
  }

  loadMeetingAttendance() async {
    final body = jsonEncode({
      "district": districtId.toString(),
      "date": meetingDate.toString(),
      'attendanceType': attendanceType.toString()
    });
    log("Encode Body $body");
    await ApiService.post("meetingAttendance", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          log("Attendance Meetings $responseBody");
          sundayMeeting = responseBody['sundayMeeting'];
          tuesdayMeeting = responseBody['tuesdayMeeting'];
          fridayMeeting = responseBody['fridayMeeting'];
          homeMeeting = responseBody['homeMeeting'];
          gospelMeeting = responseBody['gospelMeeting'];
          var counts = loadWeekdayCounts();
          tuesday = counts['Tuesday'];
          friday = counts['Friday'];
          sunday = counts['Sunday'];
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

  updateAttendeesSunTotalPercentage(key, reportType) {
    if (reportType.toString() == 'week') {
      var sundayTotal = sundayMeeting.fold<int>(
          0,
          (sum, sunday) =>
              sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

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
    } else {
      var sundayTotal = sundayMeetingMonth.fold<int>(
          0,
          (sum, sunday) =>
              sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

      log("sundayTotal $sundayTotal");

      return sundayTotal;
    }
  }

  updateAttendeesTuesTotalPercentage(key, reportType) {
    if (reportType.toString() == 'week') {
      var tuesTotal = tuesdayMeeting.fold<int>(
          0,
          (sum, sunday) =>
              sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

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
    } else {
      var tuesTotal = tuesdayMeetingMonth.fold<int>(
          0,
          (sum, sunday) =>
              sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

      log("Tuesday month total $tuesTotal");

      return tuesTotal;
    }
  }

  updateAttendeesFriTotalPercentage(key, reportType) {
    if (reportType.toString() == 'week') {
      var fridayTotal = fridayMeeting.fold<int>(
          0,
          (sum, sunday) =>
              sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

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
    } else {
      var fridayTotal = fridayMeetingMonth.fold<int>(
          0,
          (sum, sunday) =>
              sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

      log("fridayTotal $fridayTotal");

      return fridayTotal;
    }
  }

  updateAttendeesHomeTotalPercentage(key, reportType) {
    if (reportType.toString() == 'week') {
      var fridayTotal = homeMeeting.fold<int>(
          0,
          (sum, sunday) =>
              sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

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
    } else {
      var fridayTotal = fridayMeetingMonth.fold<int>(
          0,
          (sum, sunday) =>
              sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

      log("fridayTotal $fridayTotal");

      return fridayTotal;
    }
  }

  updateAttendeesGospelTotalPercentage(key, reportType) {
    if (reportType.toString() == 'week') {
      var fridayTotal = gospelMeeting.fold<int>(
          0,
          (sum, sunday) =>
              sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

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
    } else {
      var fridayTotal = fridayMeetingMonth.fold<int>(
          0,
          (sum, sunday) =>
              sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

      log("fridayTotal $fridayTotal");

      return fridayTotal;
    }
  }

  generateReport(reportType) async {
    log("Tuesdays $tuesday");
    log("Fridays $friday");
    log("Sundays $sunday");

    final pdf = pw.Document();
    final customFont = await loadCustomFont();

    var ltmTotal;
    var ltmATotal;
    var ltmAvg;
    var ltmPercentage;
    var saintTotal = int.parse(total.toString()) * 4;
    var ltmMAAvg;
    var ltmMAPercentage;

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

    var agpLtm = getPresentByDistrict(sundayMeeting, "1", reportType);
    var cityLtm = getPresentByDistrict(sundayMeeting, "4", reportType);
    var akpLtm = getPresentByDistrict(sundayMeeting, "3", reportType);
    var gwkLtm = getPresentByDistrict(sundayMeeting, "2", reportType);

    if (reportType.toString() == 'week') {
      ltmTotal = updateAttendeesSunTotalPercentage('Present', reportType);
    } else {
      ltmTotal =
          updateAttendeesSunTotalPercentage('monthlyPresent', reportType);
      double ltmAvgTotal = ltmTotal / sunday;
      ltmAvg = ltmAvgTotal.round();
      double ltmPer = (ltmTotal / saintTotal) * 100;
      ltmPercentage = ltmPer.round();
    }

    var agpPm = getPresentByDistrict(tuesdayMeeting, "1", reportType);
    var cityPm = getPresentByDistrict(tuesdayMeeting, "4", reportType);
    var akpPm = getPresentByDistrict(tuesdayMeeting, "3", reportType);
    var gwkPm = getPresentByDistrict(tuesdayMeeting, "2", reportType);
    var pmTotal;
    var pmAvg;
    var pmPercentage;
    if (reportType.toString() == 'week') {
      pmTotal = updateAttendeesTuesTotalPercentage('Present', reportType);
    } else {
      pmTotal =
          updateAttendeesTuesTotalPercentage('monthlyPresent', reportType);
      double pmAvgTotal = pmTotal / tuesday;
      pmAvg = pmAvgTotal.round();
      double pmPer = (pmTotal / saintTotal) * 100;
      pmPercentage = pmPer;
    }

    var agpGm = getPresentByDistrict(fridayMeeting, "1", reportType);
    var cityGm = getPresentByDistrict(fridayMeeting, "4", reportType);
    var akpGm = getPresentByDistrict(fridayMeeting, "3", reportType);
    var gwkGm = getPresentByDistrict(fridayMeeting, "2", reportType);

    var gmTotal;
    var gmAvg;
    var gmPercentage;
    if (reportType.toString() == 'week') {
      gmTotal = updateAttendeesFriTotalPercentage('Present', reportType);
    } else {
      gmTotal = updateAttendeesFriTotalPercentage('monthlyPresent', reportType);
      double gmAvgTotal = gmTotal / friday;
      gmAvg = gmAvgTotal.round();
      double gmPer = (gmTotal / saintTotal) * 100;
      gmPercentage = gmPer;
    }

    var agpHm = getPresentByDistrict(homeMeeting, "1", reportType);
    var cityHm = getPresentByDistrict(homeMeeting, "4", reportType);
    var akpHm = getPresentByDistrict(homeMeeting, "3", reportType);
    var gwkHm = getPresentByDistrict(homeMeeting, "2", reportType);

    var hmTotal;
    if (reportType.toString() == 'week') {
      hmTotal = updateAttendeesHomeTotalPercentage('Present', reportType);
    } else {
      gmTotal = updateAttendeesFriTotalPercentage('monthlyPresent', reportType);
      double gmAvgTotal = gmTotal / friday;
      gmAvg = gmAvgTotal.round();
      double gmPer = (gmTotal / saintTotal) * 100;
      gmPercentage = gmPer;
    }

    var agpGsm = getPresentByDistrict(gospelMeeting, "1", reportType);
    var cityGsm = getPresentByDistrict(gospelMeeting, "4", reportType);
    var akpGsm = getPresentByDistrict(gospelMeeting, "3", reportType);
    var gwkGsm = getPresentByDistrict(gospelMeeting, "2", reportType);

    var gsmTotal;
    if (reportType.toString() == 'week') {
      gsmTotal = updateAttendeesGospelTotalPercentage('Present', reportType);
    } else {
      gmTotal = updateAttendeesFriTotalPercentage('monthlyPresent', reportType);
      double gmAvgTotal = gmTotal / friday;
      gmAvg = gmAvgTotal.round();
      double gmPer = (gmTotal / saintTotal) * 100;
      gmPercentage = gmPer;
    }

    var agpAbLtm = getAbsentByDistrict(sundayMeeting, "1", reportType);
    var cityALtm = getAbsentByDistrict(sundayMeeting, "4", reportType);
    var akpLAtm = getAbsentByDistrict(sundayMeeting, "3", reportType);
    var gwkLAtm = getAbsentByDistrict(sundayMeeting, "2", reportType);

    if (reportType.toString() == 'week') {
      ltmATotal = updateAttendeesSunTotalPercentage('Absent', reportType);
    } else {
      ltmATotal =
          updateAttendeesSunTotalPercentage('monthlyAbsent', reportType);
      double ltmMAAvgTotal = ltmATotal / sunday;
      ltmMAAvg = ltmMAAvgTotal.round();
      double ltmMAPer = (ltmMAAvgTotal / saintTotal) * 100;
      ltmMAPercentage = ltmMAPer;
    }

    var agpAPm = getAbsentByDistrict(tuesdayMeeting, "1", reportType);
    var cityAPm = getAbsentByDistrict(tuesdayMeeting, "4", reportType);
    var akpAPm = getAbsentByDistrict(tuesdayMeeting, "3", reportType);
    var gwkAPm = getAbsentByDistrict(tuesdayMeeting, "2", reportType);
    var pmATotal = updateAttendeesTuesTotalPercentage('Absent', reportType);

    var agpAGm = getAbsentByDistrict(fridayMeeting, "1", reportType);
    var cityAGm = getAbsentByDistrict(fridayMeeting, "4", reportType);
    var akpAGm = getAbsentByDistrict(fridayMeeting, "3", reportType);
    var gwkAGm = getAbsentByDistrict(fridayMeeting, "2", reportType);
    var gmATotal = updateAttendeesFriTotalPercentage('Absent', reportType);

    var agpAHm = getAbsentByDistrict(homeMeeting, "1", reportType);
    var cityAHm = getAbsentByDistrict(homeMeeting, "4", reportType);
    var akpAHm = getAbsentByDistrict(homeMeeting, "3", reportType);
    var gwkAHm = getAbsentByDistrict(homeMeeting, "2", reportType);
    var hmATotal = updateAttendeesHomeTotalPercentage('Absent', reportType);

    var agpAGsm = getAbsentByDistrict(gospelMeeting, "1", reportType);
    var cityAGsm = getAbsentByDistrict(gospelMeeting, "4", reportType);
    var akpAGsm = getAbsentByDistrict(gospelMeeting, "3", reportType);
    var gwkAGsm = getAbsentByDistrict(gospelMeeting, "2", reportType);
    var gsmATotal = updateAttendeesGospelTotalPercentage('Absent', reportType);

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

    String monthName = Jiffy(meetingDate, 'yyyy-MM-dd').format('MMMM');

    String reportTitle = reportType.toString() == 'week'
        ? "$meetingDate Week"
        : "$monthName Month";

    // Create a PDF document

    // Add 10 pages to the PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("$reportTitle Report",
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
                pw.SizedBox(height: 20),
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
                    [
                    "Home Meeting",
                    "$agpHm",
                    "$cityHm",
                    "$akpHm",
                    "$gwkHm",
                    "$hmTotal"
                    ],
                    [
                      "Gospel Meeting",
                      "$agpGsm",
                      "$cityGsm",
                      "$akpGsm",
                      "$gwkGsm",
                      "$gsmTotal"
                    ]
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
                    [
                      "Home Meeting",
                      "$agpAHm",
                      "$cityAHm",
                      "$akpAHm",
                      "$gwkAHm",
                      "$hmATotal"
                    ],
                    [
                      "Gospel Meeting",
                      "$agpAGsm",
                      "$cityAGsm",
                      "$akpAGsm",
                      "$gwkAGsm",
                      "$gsmATotal"
                    ],
                  ],
                  headerStyle: pw.TextStyle(
                      font: customFont, fontWeight: pw.FontWeight.bold),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                ),
                // pw.SizedBox(height: 30),
                // pw.Text("Children Lords table meeting attendance",
                //     style: pw.TextStyle(
                //         font: customFont,
                //         fontSize: 24,
                //         fontWeight: pw.FontWeight.bold)),
                // pw.SizedBox(height: 10),
                // pw.Table.fromTextArray(
                //   headers: ["Attendance", "Agp", "City", "AKP", "Gwk", "Total"],
                //   data: [
                //     [
                //       "Present",
                //       "$agpPChildLtm",
                //       "$cityPChildLtm",
                //       "$akpPChildLtm",
                //       "$gwkPChildLtm",
                //       "$ltmPChildTotal"
                //     ],
                //     [
                //       "Absent",
                //       "$agpAChildLtm",
                //       "$cityAChildLtm",
                //       "$akpAChildLtm",
                //       "$gwkAChildLtm",
                //       "$ltmAChildTotal"
                //     ],
                //   ],
                //   headerStyle: pw.TextStyle(
                //       font: customFont, fontWeight: pw.FontWeight.bold),
                //   headerAlignment: pw.Alignment.center,
                //   cellAlignment: pw.Alignment.center,
                // ),
              ],
            ),
          ),
        ],
      ),
    );

    // Loop through chunks and add individual pages
    for (var i = 0; i < lordsDayAbsentees.length; i += 25) {
      var chunk = lordsDayAbsentees.sublist(
        i,
        i + 25 > lordsDayAbsentees.length ? lordsDayAbsentees.length : i + 25,
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Lords Table Meeting Absentees",
                    style: pw.TextStyle(
                        fontSize: 30, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ["Sno", "Saint Name", "District"],
                  data: chunk
                      .map((e) => [e["sno"], e["name"], e["district"]])
                      .toList(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Loop through chunks and add individual pages
    for (var i = 0; i < absentees.length; i += 25) {
      var absenteesChunk = absentees.sublist(
        i,
        i + 25 > absentees.length ? absentees.length : i + 25,
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Lords Day, Prayer Meeting and Group Meeting Absentees",
                    style: pw.TextStyle(
                        fontSize: 30, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ["Sno", "Saint Name", "District"],
                  data: absenteesChunk
                      .map((e) => [e["sno"], e["name"], e["district"]])
                      .toList(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // You can also use a package like `share_plus` to share the file

    final directory = await getExternalStorageDirectory();
    final filePath = "${directory!.path}/${reportTitle}_report.pdf";
    final file = File(filePath);

    // Write the PDF file
    await file.writeAsBytes(await pdf.save());

    // Open the file
    OpenFile.open(filePath);
  }

  generateMonthReport(reportType) async {
    final pdf = pw.Document();

    var ltmTotal;
    var ltmATotal;
    var ltmAvg;
    var ltmPercentage;
    var saintTotal = int.parse(total.toString()) * 4;
    var ltmMAAvg;
    var ltmMAPercentage;

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

    var agpLtm = getPresentByDistrict(sundayMeetingMonth, "1", reportType);
    var cityLtm = getPresentByDistrict(sundayMeetingMonth, "4", reportType);
    var akpLtm = getPresentByDistrict(sundayMeetingMonth, "3", reportType);
    var gwkLtm = getPresentByDistrict(sundayMeetingMonth, "2", reportType);

    double monthAgpLtm = int.parse(agpLtm) / sunday;
    double monthCityLtm = int.parse(cityLtm) / sunday;
    double monthAkpLtm = int.parse(akpLtm) / sunday;
    double monthGwkLtm = int.parse(gwkLtm) / sunday;

    log("monthAgpLtm $monthAgpLtm");

    ltmTotal = updateAttendeesSunTotalPercentage('monthlyPresent', reportType);
    double ltmAvgTotal = ltmTotal / sunday;
    ltmAvg = ltmAvgTotal.round();
    double ltmPer = (ltmTotal / saintTotal) * 100;
    ltmPercentage = ltmPer.round();

    var agpPm = getPresentByDistrict(tuesdayMeetingMonth, "1", reportType);
    var cityPm = getPresentByDistrict(tuesdayMeetingMonth, "4", reportType);
    var akpPm = getPresentByDistrict(tuesdayMeetingMonth, "3", reportType);
    var gwkPm = getPresentByDistrict(tuesdayMeetingMonth, "2", reportType);
    var pmTotal;
    var pmAvg;
    var pmPercentage;

    double monthAgpPm = int.parse(agpPm) / tuesday;
    double monthCityPm = int.parse(cityPm) / tuesday;
    double monthAkpPm = int.parse(akpPm) / tuesday;
    double monthGwkPm = int.parse(gwkPm) / tuesday;

    pmTotal = updateAttendeesTuesTotalPercentage('monthlyPresent', reportType);
    double pmAvgTotal = pmTotal / tuesday;
    pmAvg = pmAvgTotal.round();
    double pmPer = (pmTotal / saintTotal) * 100;
    pmPercentage = pmPer.round();

    var agpGm = getPresentByDistrict(fridayMeetingMonth, "1", reportType);
    var cityGm = getPresentByDistrict(fridayMeetingMonth, "4", reportType);
    var akpGm = getPresentByDistrict(fridayMeetingMonth, "3", reportType);
    var gwkGm = getPresentByDistrict(fridayMeetingMonth, "2", reportType);

    var gmTotal;
    var gmAvg;
    var gmPercentage;

    double monthAgpGm = int.parse(agpGm) / friday;
    double monthCityGm = int.parse(cityGm) / friday;
    double monthAkpGm = int.parse(akpGm) / friday;
    double monthGwkGm = int.parse(gwkGm) / friday;

    gmTotal = updateAttendeesFriTotalPercentage('monthlyPresent', reportType);
    double gmAvgTotal = gmTotal / friday;
    gmAvg = gmAvgTotal.round();
    double gmPer = (gmTotal / saintTotal) * 100;
    gmPercentage = gmPer.round();

    var agpAbLtm = getAbsentByDistrict(sundayMeetingMonth, "1", reportType);
    var cityALtm = getAbsentByDistrict(sundayMeetingMonth, "4", reportType);
    var akpLAtm = getAbsentByDistrict(sundayMeetingMonth, "3", reportType);
    var gwkLAtm = getAbsentByDistrict(sundayMeetingMonth, "2", reportType);

    double monthAgpALtm = int.parse(agpAbLtm) / sunday;
    double monthCityALtm = int.parse(cityALtm) / sunday;
    double monthAkpALtm = int.parse(akpLAtm) / sunday;
    double monthGwkALtm = int.parse(gwkLAtm) / sunday;

    ltmATotal = updateAttendeesSunTotalPercentage('monthlyAbsent', reportType);
    double ltmMAAvgTotal = ltmATotal / sunday;
    ltmMAAvg = ltmMAAvgTotal.round();
    double ltmMAPer = (ltmMAAvgTotal / saintTotal) * 100;
    ltmMAPercentage = ltmMAPer.round();

    var agpAPm = getAbsentByDistrict(tuesdayMeetingMonth, "1", reportType);
    var cityAPm = getAbsentByDistrict(tuesdayMeetingMonth, "4", reportType);
    var akpAPm = getAbsentByDistrict(tuesdayMeetingMonth, "3", reportType);
    var gwkAPm = getAbsentByDistrict(tuesdayMeetingMonth, "2", reportType);

    double monthAgpAPm = int.parse(agpAPm) / tuesday;
    double monthCityAPm = int.parse(cityAPm) / tuesday;
    double monthAkpAPm = int.parse(akpAPm) / tuesday;
    double monthGwkAPm = int.parse(gwkAPm) / tuesday;

    var pmATotal =
        updateAttendeesTuesTotalPercentage('monthlyAbsent', reportType);

    double apmAvgTotal = pmATotal / tuesday;
    var pmMAAvg = apmAvgTotal.round();
    double pmMAPer = (apmAvgTotal / saintTotal) * 100;
    var pmMAPercentage = pmMAPer.round();

    var agpAGm = getAbsentByDistrict(fridayMeetingMonth, "1", reportType);
    var cityAGm = getAbsentByDistrict(fridayMeetingMonth, "4", reportType);
    var akpAGm = getAbsentByDistrict(fridayMeetingMonth, "3", reportType);
    var gwkAGm = getAbsentByDistrict(fridayMeetingMonth, "2", reportType);

    double monthAgpAGm = int.parse(agpAGm) / friday;
    double monthCityAGm = int.parse(cityAGm) / friday;
    double monthAkpAGm = int.parse(akpAGm) / friday;
    double monthGwkAGm = int.parse(gwkAGm) / friday;

    var gmATotal =
        updateAttendeesFriTotalPercentage('monthlyAbsent', reportType);

    double agmAvgTotal = pmATotal / tuesday;
    var gmMAAvg = agmAvgTotal.round();
    double gmMAPer = (agmAvgTotal / saintTotal) * 100;
    var gmMAPercentage = gmMAPer.round();

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

    String monthName = Jiffy(meetingDate, 'yyyy-MM-dd').format('MMMM');

    String reportTitle = reportType.toString() == 'week'
        ? "$meetingDate Week"
        : "$monthName Month";

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("$reportTitle Report",
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
                  headers: ["Meetings", "Agp", "City", "AKP", "Gwk", "Avg (%)"],
                  data: [
                    [
                      "Lord's Table Meeting",
                      "${monthAgpLtm.round()}",
                      "${monthCityLtm.round()}",
                      "${monthAkpLtm.round()}",
                      "${monthGwkLtm.round()}",
                      "$ltmAvg ($ltmPercentage%)"
                    ],
                    [
                      "Prayer Meeting",
                      "${monthAgpPm.round()}",
                      "${monthCityPm.round()}",
                      "${monthAkpPm.round()}",
                      "${monthGwkPm.round()}",
                      "$pmAvg ($pmPercentage%)"
                    ],
                    [
                      "Group Meeting",
                      "${monthAgpGm.round()}",
                      "${monthCityGm.round()}",
                      "${monthAkpGm.round()}",
                      "${monthGwkGm.round()}",
                      "$gmAvg ($gmPercentage%)"
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
                  headers: ["Meetings", "Agp", "City", "AKP", "Gwk", "Avg (%)"],
                  data: [
                    [
                      "Lord's Table Meeting",
                      "${monthAgpALtm.round()}",
                      "${monthCityALtm.round()}",
                      "${monthAkpALtm.round()}",
                      "${monthGwkALtm.round()}",
                      "$ltmMAAvg ($ltmMAPercentage%)"
                    ],
                    [
                      "Prayer Meeting",
                      "${monthAgpAPm.round()}",
                      "${monthCityAPm.round()}",
                      "${monthAkpAPm.round()}",
                      "${monthGwkAPm.round()}",
                      "$pmMAAvg ($pmMAPercentage%)",
                    ],
                    [
                      "Group Meeting",
                      "${monthAgpAGm.round()}",
                      "${monthCityAGm.round()}",
                      "${monthAkpAGm.round()}",
                      "${monthGwkAGm.round()}",
                      "$gmMAAvg ($gmMAPercentage%)"
                    ],
                  ],
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                ),
                pw.SizedBox(height: 30),
                // pw.Text("Children Lords table meeting attendance",
                //     style: pw.TextStyle(
                //         fontSize: 24, fontWeight: pw.FontWeight.bold)),
                // pw.SizedBox(height: 10),
                // pw.Table.fromTextArray(
                //   headers: ["Attendance", "Agp", "City", "AKP", "Gwk", "Total"],
                //   data: [
                //     [
                //       "Present",
                //       "$agpPChildLtm",
                //       "$cityPChildLtm",
                //       "$akpPChildLtm",
                //       "$gwkPChildLtm",
                //       "$ltmPChildTotal"
                //     ],
                //     [
                //       "Absent",
                //       "$agpAChildLtm",
                //       "$cityAChildLtm",
                //       "$akpAChildLtm",
                //       "$gwkAChildLtm",
                //       "$ltmAChildTotal"
                //     ],
                //   ],
                //   headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                //   headerAlignment: pw.Alignment.center,
                //   cellAlignment: pw.Alignment.center,
                // ),
              ],
            ),
          ),
        ],
      ),
    );

    final directory = await getExternalStorageDirectory();
    final filePath = "${directory!.path}/${reportTitle}_report.pdf";
    final file = File(filePath);

    // Write the PDF file
    await file.writeAsBytes(await pdf.save());

    // Open the file
    OpenFile.open(filePath);
  }

  handleReport(type) {
    loadMonthlyReportAttendance(type);
  }

  loadMonthlyReportAttendance(type) async {
    final body = jsonEncode({
      "district": districtId.toString(),
      "date": meetingDate.toString(),
      'attendanceType': type.toString()
    });
    log("Encode Body $body");
    await ApiService.post("monthlyAttendance", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          log("Attendance Meetings $responseBody");
          sundayMeetingMonth = responseBody['sundayMeeting'];
          tuesdayMeetingMonth = responseBody['tuesdayMeeting'];
          fridayMeetingMonth = responseBody['fridayMeeting'];
          homeMeetingMonth = responseBody['homeMeeting'];
          gospelMeetingMonth = responseBody['gospelMeeting'];
          generateMonthReport(type);
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

  // callingAttendance() {
  //   loadMeetingAttendance();
  //   handleMonthlyAttendance();
  //   update();
  // }
  //
  // handleMonthlyAttendance() async {
  //   await generateReport(attendanceType);
  //   update();
  // }

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

  getPresentByDistrict(List sundayMeeting, String districtID, reportType) {
    if (reportType.toString() == 'week') {
      return sundayMeeting
          .firstWhere(
            (sunday) => sunday['districtID'].toString() == districtID,
            orElse: () => {"Present": "0"},
          )['Present']
          .toString();
    } else {
      return sundayMeeting
          .firstWhere(
            (sunday) => sunday['districtID'].toString() == districtID,
            orElse: () => {"monthlyPresent": "0"},
          )['monthlyPresent']
          .toString();
    }
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

  getAbsentByDistrict(List sundayMeeting, String districtID, reportType) {
    if (reportType.toString() == 'week') {
      return sundayMeeting
          .firstWhere(
            (sunday) => sunday['districtID'].toString() == districtID,
            orElse: () => {"Absent": "0"},
          )['Absent']
          .toString();
    } else {
      return sundayMeeting
          .firstWhere(
            (sunday) => sunday['districtID'].toString() == districtID,
            orElse: () => {"monthlyAbsent": "0"},
          )['monthlyAbsent']
          .toString();
    }
  }

  updateChildTotal(key) {
    var sundayTotal = sundayMeeting.fold<int>(0,
        (sum, sunday) => sum + (int.tryParse(sunday['$key'].toString()) ?? 0));

    log("sundayChildTotal $sundayTotal");

    return sundayTotal;
  }
}
