import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../../apiservice/restapi.dart';

class AttendanceReportController extends GetxController {
  dynamic argumentData = Get.arguments;
  List saints = [];
  List districts = [
    {"id": "", "name": "-- All --"},
    {"id": 1, "name": "AGP"},
    {"id": 2, "name": "GWK"},
    {"id": 3, "name": "AKP"},
    {"id": 4, "name": "Vizag City"}
  ];
  List meetingTypes = [
    {"id": "", "name": "-- Select --"},
    {"id": 1, "name": "Lords Table Meeting"},
    {"id": 2, "name": "Prayer Meeting"},
    {"id": 3, "name": "Group Meeting"},
    {"id": 4, "name": "Home Meeting"},
    {"id": 5, "name": "Gospel Meeting"},
  ];
  String districtId = "0";
  String meetingTypeId = "0";
  String meetingDate = Jiffy(DateTime.now()).format('yyyy-MM-dd');
  late DateTime currentDate;
  var total;
  var present;
  var absent;
  bool isLoading = true;
  String attendance = "";
  String appBarTitle = "";

  @override
  void onInit() {
    // TODO: implement onInit
    if (argumentData != null) {
      updateArgumentData();
      log("argumentData ${argumentData[0]}");
      log("argumentData ${argumentData[1]}");
      log("argumentData ${argumentData[2]}");
    }

    super.onInit();
  }

  updateArgumentData() {
    districtId = argumentData[0];
    meetingDate = argumentData[1];
    attendance = argumentData[2];
    appBarTitle = argumentData[3];
    loadSaintAttendance();
    update();
  }

  handleMeetingType(String value) {
    meetingTypeId = value;
    loadSaintAttendance();
    update();
  }

  handleDistrict(String value) {
    districtId = value;
    loadSaintAttendance();
    update();
  }

  datePicker(BuildContext context) async {
    currentDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    ))!;
    meetingDate = Jiffy(currentDate).format('yyyy-MM-dd');

    loadSaintAttendance();
    update();
  }

  loadSaintAttendance() async {
    saints = [];
    final body = jsonEncode({
      "district": districtId.toString(),
      "meetingDate": meetingDate.toString(),
      "attendance": attendance.toString()
    });
    log("Encode Body $body");
    await ApiService.post("attendanceReport", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          log("Saints $responseBody");
          saints = responseBody['attendance'];
          // total = responseBody['total'];
          // present = responseBody['counts']['present'];
          // absent = responseBody['counts']['absent'];
          // log("Total Saints ${responseBody['total'].toString()}");
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
}
