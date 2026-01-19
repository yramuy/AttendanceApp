import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../../apiservice/restapi.dart';
import '../../helpers/utilities.dart';

class AttendanceListController extends GetxController {
  dynamic argumentData = Get.arguments;
  List saints = [];
  List districts = [];
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
          total = responseBody['total'];
          present = responseBody['counts']['present'].toString();
          absent = responseBody['counts']['absent'].toString();
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
