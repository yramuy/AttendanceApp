import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:share_plus/share_plus.dart';

import '../../apiservice/restapi.dart';

class LifeStudyQuestionListController extends GetxController {
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
  List lifeStudies = [];
  List lifeStudyQns = [];

  @override
  void onInit() {
    // TODO: implement onInit
    loadLifeStudyQns();
    super.onInit();
  }

  loadLifeStudyQns() async {
    lifeStudies = [];
    lifeStudyQns = [];
    var body =
        jsonEncode({"districtId": districtId, "meetingDate": meetingDate});

    await ApiService.post("lifeStudyQnsList", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          log("Saints $responseBody");
          lifeStudies = responseBody['lifeStudy'];
          if (lifeStudies.isNotEmpty) {
            lifeStudyQns = responseBody['lifeStudy'][0]['lifeStudyQns'];
          }

          log("lifeStudies ${lifeStudies}");
          log("lifeStudiesQns ${lifeStudyQns}");
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

  handleDistrict(String value) {
    districtId = value;
    loadLifeStudyQns();
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
    loadLifeStudyQns();
    //if the user has selected a date
    update();
  }

  handleLifeStudyQnsShare(lifeStudy) async {
    log("Life Study $lifeStudy");

    String multiMsg =
        "Praise the Lord Saints \n\n${lifeStudy['meetingDate'].toString()} on Lord's Table Meeting ${lifeStudy['life_study_title'].toString()} Questions & Answers\n\n";

    Set<String> addedMessages = {}; // Track added message headings

    for (int i = 0; i < lifeStudy['lifeStudyQns'].length; i++) {
      String currentMessage =
          lifeStudy['lifeStudyQns'][i]['message'].toString();

      if (lifeStudy['message_1'].toString() == currentMessage ||
          lifeStudy['message_2'].toString() == currentMessage) {
        // Add message heading only if it's not already added
        if (!addedMessages.contains(currentMessage)) {
          multiMsg += "$currentMessage th Message\n";
          addedMessages.add(currentMessage);
        }

        multiMsg +=
            "  ${lifeStudy['lifeStudyQns'][i]['question']} . ${lifeStudy['lifeStudyQns'][i]['saintName']}\n";
      }
    }

    await Share.share(multiMsg);
  }
}
