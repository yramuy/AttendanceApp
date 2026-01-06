import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../../apiservice/restapi.dart';

class AttendanceListController extends GetxController {
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

  @override
  void onInit() {
    // TODO: implement onInit
    if (argumentData != null) {
      log("argumentData ${argumentData[0]}");
      districtId = argumentData[0];
      meetingDate = argumentData[1];
    }
    loadSaints();
    super.onInit();
  }

  handleMeetingType(String value) {
    meetingTypeId = value;
    loadSaints();
    update();
  }

  handleDistrict(String value) {
    districtId = value;
    loadSaints();
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

    loadSaints();
    update();
  }

  loadSaints() async {
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
          total = responseBody['total'];
          present = responseBody['counts']['present'];
          absent = responseBody['counts']['absent'];
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
}
