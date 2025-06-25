import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import '../../apiservice/restapi.dart';
import 'package:intl/intl.dart';

class AttendanceRecordController extends GetxController {
  final List<String> headers = [
    'Sno',
    'Saint Name',
    'Classification',
    'Category',
    'Service',
    'Shephred',
    'Going Out for Fruit Bearing',
    'Going Out for Shepherding (Shepherd)',
    'Joined Home Meeting (Sheep)',
    'Small Group Meeting',
    'Life Study M1',
    'Life Study M2',
    'Prayer Meeting',
    'Lords Table Meeting',
    'Brothers Meeting',
  ];

  List saints = [];
  String districtId = "0";
  String districtName = "AGP";
  String typeId = "0";

  int checkboxStartIndex = 4;

  // Each row has 3 booleans (Sunday, Tuesday, Friday)
  bool isChecked = false;
  Map<int, bool> isFruitBearing = {};
  Map<int, bool> isShepherding = {};
  Map<int, bool> isHomeMeeting = {};
  Map<int, bool> isGroupMeetig = {};
  Map<int, bool> isM1 = {};
  Map<int, bool> isM2 = {};
  Map<int, bool> isPrayerMeeting = {};
  Map<int, bool> isTableMeeting = {};
  int selectedIndex = 0;
  bool isLoading = false;
  List weekDates = [];
  String meetingDate = Jiffy(DateTime.now()).format('yyyy-MM-dd');
  late DateTime currentDate;
  TextEditingController searchController = TextEditingController();
  List tempSaints = [];
  Map<String, dynamic> weeklyAttendanceCounts = {}; // Fix the type

  @override
  void onInit() {
    super.onInit();
    updateAttendanceSheet(selectedIndex);
    getCurrentWeekDates('0');
    // print(currentWeek[0]); // prints yyyy-MM-dd
    // for (var date in currentWeek) {
    //   print(date.toString().split(' ')[0]); // prints yyyy-MM-dd
    // }
    loadSaints();
  }

  datePicker(BuildContext context) async {
    currentDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    ))!;
    meetingDate = Jiffy(currentDate).format('yyyy-MM-dd');
    getCurrentWeekDates('1');
    loadSaints();
    update();
  }

  getCurrentWeekDates(value) {
    if (value.toString() == '0') {
      DateTime now = DateTime.now();
      int currentWeekday = now.weekday; // 1 = Monday, 7 = Sunday
      DateTime monday = now.subtract(Duration(days: currentWeekday - 1));

      weekDates = List.generate(7, (index) {
        DateTime day = monday.add(Duration(days: index));
        return DateFormat("yyyy-MM-dd").format(day);
      });
    } else {
      DateTime now = DateTime.parse(meetingDate);
      int currentWeekday = now.weekday; // 1 = Monday, 7 = Sunday
      DateTime monday = now.subtract(Duration(days: currentWeekday - 1));

      weekDates = List.generate(7, (index) {
        DateTime day = monday.add(Duration(days: index));
        return DateFormat("yyyy-MM-dd").format(day);
      });
    }

    update();

    print("weekDates $weekDates");
    // return weekDates;
  }

  updateAttendanceSheet(index) {
    selectedIndex = index;
    update();
    if (index == 0) {
      districtId = "1";
      districtName = "AGP";
      update();
    } else if (index == 1) {
      districtId = "2";
      districtName = "GWK";
      update();
    } else if (index == 2) {
      districtId = "4";
      districtName = "CITY";
      update();
    } else {
      districtId = "3";
      districtName = "AKP";
      update();
    }
    loadSaints();
    update();
  }

  loadWeeklyAttendanceData() async {
    final body = jsonEncode(
        {"districtID": districtId.toString(), "weekDates": weekDates});
    log("Encode Body $body");
    await ApiService.post("weeklyAttendanceTotal", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          // log("responseBody $responseBody");
          weeklyAttendanceCounts = responseBody['weeklyAttendanceCounts'];

          log("weeklyAttendanceCounts ${weeklyAttendanceCounts['GoingOutforFruitBearing'].toString()}"); // isLoading = false;

          update();
        } else {
          if (selectedIndex == 0) {
            isLoading = false;
          }
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

  handleSaintAttendance(
      saintID, headerTypeValue, headerType, headerTypeText, saintTypeId) async {
    var body = jsonEncode({
      "district_id": districtId,
      "saint_id": saintID,
      "header_type": headerType,
      "header_type_text": headerTypeText,
      "header_type_value": headerTypeValue ? '1' : '0',
      "meeting_date": getMeetingDate(headerType, weekDates),
      "category_id": saintTypeId
    });
    update();

    await ApiService.post("saveAttendanceSheet", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          log("responseBody $responseBody");
          loadSaints();
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

    log("Body $body");
  }

  getMeetingDate(headerType, weekDates) {
    var meetingDate;
    switch (headerType) {
      case 4:
        meetingDate = weekDates[4];
        break;
      case 7:
        meetingDate = weekDates[1];
        break;
      case 8:
        meetingDate = weekDates[6];
        break;
      case 9:
        meetingDate = weekDates[0];
        break;
      default:
        meetingDate = "${weekDates[0]} to ${weekDates[6]}";
    }

    return meetingDate;
  }

  loadSaints() async {
    log("District $districtId");
    if (selectedIndex == 0) {
      isLoading = true;
    }
    final body = jsonEncode({
      "districtId": districtId.toString(),
      "typeId": typeId,
      "date": meetingDate,
      "meetingType": ""
    });
    log("Encode Body $body");
    await ApiService.post("saints", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          // log("responseBody $responseBody");
          saints = responseBody['saints'];
          tempSaints = responseBody['saints'];
          if (selectedIndex == 0) {
            isLoading = false;
          }

          loadWeeklyAttendanceData();

          log("Saints $saints"); // isLoading = false;
          // Get.rawSnackbar(
          //     snackPosition: SnackPosition.TOP,
          //     message: responseBody['message'].toString());
          update();
        } else {
          if (selectedIndex == 0) {
            isLoading = false;
          }
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

  handleSearch(String value) {
    saints = [];
    saints = tempSaints
        .where((hist) =>
            hist['name']
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            hist['classificationName']
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            hist['saintType']
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
        .toList();
    update();
  }
}
