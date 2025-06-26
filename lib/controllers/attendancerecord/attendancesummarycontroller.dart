import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

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
  String Gofb = '0';

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadDropdownData();
  }

  Future<void> loadDropdownData() async {
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

      if (headerTypeID.toString() == '1') {
        Gofb = data['monthlyAttendanceCounts'];
        update();
      }

      // updateTotalByType(headerTypeID, data['monthlyAttendanceCounts']);

      log('monthlyAttendanceTotal ${data['monthlyAttendanceCounts']}');

      return data['monthlyAttendanceCounts'];
    } catch (e) {
      log("Error in loadDropdownData: $e");
      _showErrorSnackbar();
    }
    // update();
  }

  updateTotalByType(typeID, count) {
    if (typeID.toString() == '1') {
      Gofb = count;
    }
    update();
  }
}
