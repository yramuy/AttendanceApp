import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:maintenanceapp/controllers/finance/monthlymaintenancecontroller.dart';
import 'package:maintenanceapp/views/finance/monthlymaintanance.dart';

import '../../apiservice/restapi.dart';

class AddDailyMaintenanceController extends GetxController {
  List paymentTypes = [
    {'id': 1, 'name': "credit"},
    {'id': 2, 'name': "debit"}
  ];
  String paymentType = "";
  late DateTime currentDate;
  String transactionDate = Jiffy(DateTime.now()).format('yyyy-MM-dd');
  String todayDate = Jiffy(DateTime.now()).format('yyyy-MM-dd');
  TextEditingController amount = TextEditingController();
  TextEditingController description = TextEditingController();
  MonthlyMaintenanceController mmController =
      Get.put(MonthlyMaintenanceController());
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  handlePaymentType(String value) {
    paymentType = value.toString();
    update();
  }

  datePicker(BuildContext context) async {
    currentDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    ))!;
    transactionDate = Jiffy(currentDate).format('yyyy-MM-dd');

    update();
  }

  handleSave() async {

    var body = jsonEncode({
      "transactionType": paymentType,
      "amount": amount.text,
      "description": description.text,
      "transactionDate": transactionDate
    });

    await ApiService.post("saveMaintenance", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: responseBody['message'].toString());
          mmController.loadMaintenanceHistory();
          Get.offAll(() => const MonthlyMaintenance());
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
}
