import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:maintenanceapp/controllers/saints/saintscontroller.dart';
import 'package:maintenanceapp/views/saint/saints.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/restapi.dart';

class AddSaintController extends GetxController {
  String gender = '1';
  late DateTime currentDate;
  String dob = Jiffy(DateTime.now()).format('yyyy-MM-dd');
  String todayDate = Jiffy(DateTime.now()).format('yyyy-MM-dd');
  final saintFormKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  String districtId = "0";
  String roleId = '4';
  String saintType = '1';
  String? createdBy;
  String? saintID = '0';
  String? userID = '0';
  String? saintStatus = '1';
  int? age;
  bool showPassword = true;
  List districts = [
    {"id": 1, "name": "AGP"},
    {"id": 2, "name": "GWK"},
    {"id": 3, "name": "AKP"},
    {"id": 4, "name": "Vizag City"}
  ];
  List saintTypes = [
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

  List status = [
    {"id": 1, "name": "Regular"},
    {"id": 2, "name": "Dormant"}
  ];

  dynamic argumentData = Get.arguments;
  SaintsController sController = Get.put(SaintsController());

  @override
  void onInit() {
    // TODO: implement onInit
    loadLoginData();
    super.onInit();
  }

  loadLoginData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    createdBy = pref.getString('userID');
    log("Argument Data $argumentData");
    if (argumentData['id'].toString() != '0') {
      saintID = argumentData['id'].toString();
      name.text = argumentData['name'].toString();
      email.text = argumentData['email'].toString();
      mobile.text = argumentData['mobile'].toString();
      name.text = argumentData['name'].toString();
      dob = argumentData['dob'].toString();
      gender = argumentData['gender'].toString() == 'Male' ? '1' : '2';
      districtId = argumentData['districtId'].toString();
      saintType = argumentData['saintTypeId'].toString();
      roleId = argumentData['user_role_id'].toString();
      username.text = argumentData['user_name'].toString();
      userID = argumentData['user_id'].toString();
      saintStatus = argumentData['saint_status'].toString();
      update();
    }


    update();
  }

  handleRadioButton(value) {
    gender = value;
    update();
  }

  datePicker(BuildContext context) async {
    currentDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    ))!;
    dob = Jiffy(currentDate).format('yyyy-MM-dd');
  //if the user has selected a date

    handleAge();

    log("current : $todayDate selected : $dob");

    update();
  }

  handleAge() {
    DateTime birthDate = DateTime.parse(dob);
    DateTime currentDate = DateTime.parse(todayDate);
    age = calculateAge(birthDate, currentDate);
    print("Age: $age years");
  }

  int calculateAge(DateTime birthDate, DateTime currentDate) {
    int calAge = currentDate.year - birthDate.year;

    // Check if the birthday has not occurred yet this year
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      calAge--;
    }

    return calAge;
  }

  handleSave() async {
    var body = jsonEncode({
      "id": saintID,
      "userId": userID,
      "name": name.text,
      "email": email.text,
      "mobile": mobile.text,
      "gender": gender,
      "dob": dob,
      "district": districtId,
      "saintType": saintType,
      "age": age,
      "username": username.text,
      "password": password.text,
      "saintStatus": saintStatus,
      "user_role_id": roleId,
      "created_by": createdBy
    });

    if (kDebugMode) {
      print("Body $body");
    }

    await ApiService.post("saveOrUpdateSaint", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: responseBody['message'].toString());
          sController.loadSaints();
          Get.off(() => const Saints());
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
