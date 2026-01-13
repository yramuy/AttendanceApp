import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/helpers/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/restapi.dart';
import '../bottompages/bottomnavigationbarcontroller.dart';

class SaintsController extends GetxController {
  String districtId = "0";
  String typeId = "0";
  String? totalSaints;
  String brothers = "0";
  String sisters = "0";
  String yws = "0";
  String youngOnes = "0";
  String teenagers = "0";
  String children = "0";
  String generalSaints = "0";
  String workingSaints = "0";
  bool dist = true;
  bool type = false;
  bool isLoading = true;
  List saints = [];
  List districts = [
    {"id": "0", "name": "--All Areas--"},
    {"id": 1, "name": "AGP"},
    {"id": 2, "name": "GWK"},
    {"id": 3, "name": "AKP"},
    {"id": 4, "name": "Vizag City"}
  ];
  List saintTypes = [
    {"id": "0", "name": "--All Categories--"},
    {"id": 1, "name": "General Saint"},
    {"id": 2, "name": "Young working Saint"},
    {"id": 3, "name": "Collage Student"},
    {"id": 6, "name": "Teenager"},
    {"id": 4, "name": "Children"},
    {"id": 5, "name": "Dormant Saint"}
  ];

  List roles = [
    {"id": 2, "name": "Finance"},
    {"id": 3, "name": "Administration"},
    {"id": 4, "name": "User"}
  ];
  dynamic argumentData = Get.arguments;
  String saintID = "";
  String saintName = "";
  TextEditingController searchController = TextEditingController();
  List tempSaints = [];
  bool isLocation = false;

  @override
  onInit() {
    // TODO: implement onInit
    // updateArguments();
    // log("argumentData123 ${argumentData['district']}");
    // log("argumentDatasaintType ${argumentData['saintType']}");
    loadSaints();
    super.onInit();
  }

  // updateArguments() {
  //   districtId = argumentData['district'].toString();
  //   typeId = argumentData['saintType'].toString();
  //
  //   if (argumentData['saintType'].toString() != '0') {
  //     handleOnchange();
  //   }
  //
  //   log("calling updateArgument ${argumentData['saintType'].toString()}");
  //   update();
  // }

  loadSaints() async {
    final body = jsonEncode({
      "districtId": districtId.toString(),
      "typeId": typeId,
      "date": "",
      "meetingType": "",
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
          tempSaints = responseBody['saints'];
          totalSaints = responseBody['total'].toString();
          if (responseBody['total'].toString() != "0") {
            brothers = responseBody['counts']['brothers'];
            sisters = responseBody['counts']['sisters'].toString();
            yws = responseBody['counts']['young_working_saints'].toString();
            youngOnes = responseBody['counts']['young_ones'].toString();
            teenagers = responseBody['counts']['teenagers'].toString();
            children = responseBody['counts']['childrens'].toString();
            generalSaints = responseBody['counts']['generalSaints'].toString();
            workingSaints =
                responseBody['counts']['young_working_saints'].toString();
          }

          isLoading = false;
          // Get.rawSnackbar(
          //     snackPosition: SnackPosition.TOP,
          //     message: responseBody['message'].toString());
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

  handleOnchange() {
    loadSaints();
    if (districtId.toString() == '0' && typeId.toString() == '0') {
      dist = true;
      type = false;
      log("1. dist T type F");
      update();
    } else if (districtId.toString() != '0' && typeId.toString() == '0') {
      dist = true;
      type = false;
      log("2. dist T type F");
      update();
    } else if (districtId.toString() != '0' && typeId.toString() != '0') {
      dist = false;
      type = true;
      log("TypeID $typeId");
      log("3. dist F type T");
      update();
    } else if (districtId.toString() == '0' && typeId.toString() != '0') {
      dist = false;
      type = true;
      log("4. dist F type T");
      update();
    }
    // if (typeId.toString().isEmpty) {
    //   dist = true;
    //   type = false;
    //   update();
    // } else {
    //   dist = false;
    //   type = true;
    //   update();
    // }
    update();
  }

  showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to delete $saintName?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Perform action and close dialog
                // Add your action here
                callingDeleteApi();
                print("Confirmed!");
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  callingDeleteApi() async {
    var body = jsonEncode({'id': saintID.toString()});
    await ApiService.post("deleteSaint", body).then((success) {
      if (success.statusCode == 200) {
        loadSaints();
        var responseBody = jsonDecode(success.body);
        Get.snackbar('Alert', responseBody['message'].toString(),
            backgroundColor: Colors.black,
            barBlur: 20,
            colorText: Colors.white,
            animationDuration: const Duration(seconds: 3));
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

  handleSearch(String value) {
    saints = [];
    saints = tempSaints
        .where((hist) =>
            hist['name']
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            hist['district']
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
        .toList();
    update();
  }
}
