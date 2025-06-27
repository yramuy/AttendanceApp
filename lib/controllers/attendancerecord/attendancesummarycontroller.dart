import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../apiservice/restapi.dart';

class AttendanceSummaryController extends GetxController {
  final List<String> headers = [
    'Meeting Hall',
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
  List districts = [];
  int Gofb = 0;
  String monthName = "";
  int currentMonthWeeks = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadDropdownData();
    getCurrentMonthName();
    getWeeksInCurrentMonth();
  }

  getWeeksInCurrentMonth() {
    final now = DateTime.now();

    // First day of the current month
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    // Last day of the current month
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    // Weekday (1 = Monday, 7 = Sunday)
    final firstWeekday = firstDayOfMonth.weekday;
    final lastDate = lastDayOfMonth.day;

    // Days in first week
    final daysInFirstWeek = 8 - firstWeekday;

    // Remaining days after first week
    final remainingDays = lastDate - daysInFirstWeek;

    // Total full weeks after the first week
    final fullWeeks = (remainingDays / 7).ceil();

    // Total weeks = 1 (first partial week) + full weeks
    currentMonthWeeks = fullWeeks;

    update();
  }

  getCurrentMonthName() {
    final now = DateTime.now();
    monthName = DateFormat('MMMM').format(now); // e.g., "June"
    print('Current month: $monthName');
    update();
  }

  loadDropdownData() async {
    try {
      final responses = await Future.wait([
        ApiService.get("masterData?dropdownID=2&featureID=1&isActive=1"),
      ]);

      final firstResponse = responses[0];

      if (firstResponse.statusCode == 200) {
        final data = jsonDecode(firstResponse.body);
        districts = data['masterData'];
        log("districts: $districts");
      } else {
        _showErrorSnackbar();
      }
    } catch (e) {
      log("Error in loadDropdownData: $e");
      _showErrorSnackbar();
    }

    update(); // Call once after all updates
  }

  void _showErrorSnackbar() {
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      message: 'Something went wrong, Please retry later',
    );
  }

  getMeetingDataByDistrict(districtID, headerTypeID) async {
    log('Distict : ${districtID.toString()} headerType : ${headerTypeID.toString()}');

    try {
      final responses = await Future.wait([
        ApiService.get(
            "monthlyAttendanceTotal?districtID=${districtID}&headerTypeID=${headerTypeID}"),
      ]);

      final firstResponse = responses[0];

      final data = jsonDecode(firstResponse.body);

      final attendanceCnt = data['monthlyAttendanceCounts'];

      if (attendanceCnt.toString() == '0') {
        return 0;
      } else {
        double avg = attendanceCnt / currentMonthWeeks;
        int rounded = avg.round();

        log("avg $avg");

        log("rounded $rounded");

        return rounded;
      }
    } catch (e) {
      log("Error in loadDropdownData: $e");
      _showErrorSnackbar();
    }
  }

  getMonthlyTotal(headerTypeID) async {
    try {
      final responses = await Future.wait([
        ApiService.get("monthlyTotal?headerTypeID=${headerTypeID}"),
      ]);

      final firstResponse = responses[0];

      final data = jsonDecode(firstResponse.body);

      final attendanceCnt = data['total'];

      if (attendanceCnt.toString() == '0') {
        return 0;
      } else {
        double avg = int.parse(attendanceCnt) / currentMonthWeeks;
        int rounded = avg.round();

        log("avg $avg");

        log("rounded $rounded");

        return rounded;
      }
    } catch (e) {
      log("Error in loadDropdownData: $e");
      _showErrorSnackbar();
    }
  }

  // getMonthlyTotal(headerTypeID) async {
  //   try {
  //     final responses = await Future.wait([
  //       ApiService.get("monthlyTotal?headerTypeID=${headerTypeID}"),
  //     ]);

  //     final response = responses[0];

  //     final result = jsonDecode(response.body);

  //     final totalCnt = result['total'];

  //     if (totalCnt == null || totalCnt.toString() == '0') {
  //       log("totalCnt is null or 0");
  //       return 0;
  //     }

  //     if (currentMonthWeeks == null || currentMonthWeeks == 0) {
  //       log("currentMonthWeeks is null or 0");
  //       return 0;
  //     }

  //     double totalAvg = totalCnt / currentMonthWeeks;
  //     int totalRounded = totalAvg.round();

  //     log("TotalAvg $totalAvg");
  //     log("Total Rounded $totalRounded");

  //     return totalRounded;
  //   } catch (e) {
  //     log("Error in loadDropdownData: $e");
  //     _showErrorSnackbar();
  //   }
  //   // update();
  // }
}
