import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:maintenanceapp/controllers/lifestudy/lifestudyquestionlistcontroller.dart';
import 'package:maintenanceapp/views/lifestudy/lifestudyquestionlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/restapi.dart';

class AssignLifeStudyQuestionsController extends GetxController {
  List saints = [];
  String districtId = "0";
  String meetingDate = Jiffy(DateTime.now()).format('yyyy-MM-dd');
  late DateTime currentDate;
  List districts = [
    {"id": "", "name": "-- All --"},
    {"id": 1, "name": "AGP"},
    {"id": 2, "name": "GWK"},
    {"id": 3, "name": "AKP"},
    {"id": 4, "name": "Vizag City"}
  ];
  TextEditingController message = TextEditingController();
  TextEditingController questionNo = TextEditingController();
  TextEditingController lifeStudyTitle = TextEditingController();
  TextEditingController message1 = TextEditingController();
  TextEditingController message2 = TextEditingController();
  List lifeStudyQus = [];
  String userID = "0";
  final LifeStudyQuestionListController lSql =
      Get.put(LifeStudyQuestionListController());
  @override
  void onInit() {
    // TODO: implement onInit
    loadSaints();
    super.onInit();
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ))!;
    meetingDate = Jiffy(currentDate).format('yyyy-MM-dd');
    //if the user has selected a date

    update();
  }

  loadSaints() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userID = pref.getString('userID').toString();
    final body = jsonEncode({
      "districtId": districtId,
      "typeId": "",
      "date": "",
      "meetingType": ""
    });
    log("Encode Body $body");
    await ApiService.post("saints", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          log("Saints $responseBody");
          saints = responseBody['saints'];
          log("Total Saints ${responseBody['total'].toString()}");
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

  handleMessage(String saintId, String messageNo) {
    try {
      // Convert saintId to string for consistent comparison
      String saintIdStr = saintId.toString();

      // Find if saintId already exists in lifeStudyQus
      int existingIndex = lifeStudyQus.indexWhere((item) {
        var decodedItem = jsonDecode(item);
        return decodedItem["saintId"] == saintIdStr;
      });

      if (existingIndex != -1) {
        // Update only messageNo while keeping existing questionNo
        var existingItem = jsonDecode(lifeStudyQus[existingIndex]);
        existingItem["messageNo"] = messageNo; // Update messageNo

        lifeStudyQus[existingIndex] = jsonEncode(existingItem);
      } else {
        // Add new entry if saintId doesn't exist
        var newItem = jsonEncode(
            {"saintId": saintIdStr, "messageNo": messageNo, "questionNo": ""});
        lifeStudyQus.add(newItem);
      }

      log("Updated lifeStudyQus: $lifeStudyQus");
    } catch (e) {
      log("Error in handleMessage: $e");
    }
  }

  handleQuestionNo(String saintId, String questionNo) {
    try {
      // Convert saintId to string for consistent comparison
      String saintIdStr = saintId.toString();

      // Find if saintId already exists in lifeStudyQus
      int existingIndex = lifeStudyQus.indexWhere((item) {
        var decodedItem = jsonDecode(item);
        return decodedItem["saintId"] == saintIdStr;
      });

      if (existingIndex != -1) {
        // Update only questionNo while keeping existing messageNo
        var existingItem = jsonDecode(lifeStudyQus[existingIndex]);
        existingItem["questionNo"] = questionNo; // Update questionNo

        lifeStudyQus[existingIndex] = jsonEncode(existingItem);
      } else {
        // Add new entry if saintId doesn't exist
        var newItem = jsonEncode(
            {"saintId": saintIdStr, "messageNo": "", "questionNo": questionNo});
        lifeStudyQus.add(newItem);
      }

      log("Updated lifeStudyQus: $lifeStudyQus");
    } catch (e) {
      log("Error in handleQuestionNo: $e");
    }
  }

  handleSave() async {
    var questions = jsonDecode(lifeStudyQus.toString());
    var body = jsonEncode({
      "lifeStudyTitle": lifeStudyTitle.text.toString(),
      "message_1": message1.text.toString(),
      "message_2": message2.text.toString(),
      "districtId": districtId.toString(),
      "date": meetingDate.toString(),
      "userID": userID.toString(),
      "lifeStudyQuestions": questions
    });

    log("Saved Data: ${jsonDecode(body)}");

    await ApiService.post("saveLifeStudyQuestions", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        log("responseBody $responseBody");
        if (responseBody['status'].toString() == '200') {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: responseBody['message'].toString());
          lSql.loadLifeStudyQns();
          Get.off(() => const LifeStudyQuestionList());
          // sController.loadSaints();
          // Get.off(() => const Saints());
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
  }
}
