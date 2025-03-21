import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../apiservice/restapi.dart';

class MonthlyMaintenanceController extends GetxController {
  List months = [];
  var monthList;
  List maintenanceHistory = [];
  String openingBalance = "0";
  String receivedAmount = "0";
  String expenseAmount = "0";
  String closingBalance = "0";
  int selectedMonth = DateTime.now().month;

  // List of month names
  List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadMonths();
    loadMaintenanceHistory();
  }

  loadMonths() {
    // Create a map with month numbers as keys and names as values
    Map<String, String> monthsMap = {};
    for (int i = 1; i <= 12; i++) {
      String key = i.toString(); // Pads with 0 if single digit
      monthsMap[key] = monthNames[i - 1];
    }

    // Convert the map to JSON format
    String jsonString = jsonEncode(monthsMap);

    monthList = jsonDecode(jsonString);
    // Print the result
    print(monthList);
  }

  loadMaintenanceHistory() async {
    var body = jsonEncode({"month": selectedMonth});

    await ApiService.post("maintenanceHistory", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          maintenanceHistory = responseBody['history'];
          openingBalance =
              responseBody['historyDetails']['opening_balance'] != null
                  ? responseBody['historyDetails']['opening_balance']
                  : '0';
          receivedAmount = responseBody['historyDetails']['received'] != null
              ? responseBody['historyDetails']['received']
              : '0';
          expenseAmount = responseBody['historyDetails']['expense'] != null
              ? responseBody['historyDetails']['expense']
              : '0';
          closingBalance =
              responseBody['historyDetails']['closing_balance'] != null
                  ? responseBody['historyDetails']['closing_balance']
                  : '0';
          log("History $maintenanceHistory");
        } else {
          Get.snackbar('Alert', responseBody['message'].toString(),
              backgroundColor: Colors.blueAccent,
              barBlur: 20,
              colorText: Colors.white,
              animationDuration: const Duration(seconds: 3));
        }
      } else {
        Get.snackbar('Alert', 'Something went wrong, Please retry later',
            backgroundColor: Colors.blueAccent,
            barBlur: 20,
            overlayBlur: 5,
            colorText: Colors.white,
            animationDuration: const Duration(seconds: 3));
      }
      update();
    });
  }

  handleMonth(String? value) {
    selectedMonth = int.parse(value.toString());
    loadMaintenanceHistory();
    update();
  }
}
