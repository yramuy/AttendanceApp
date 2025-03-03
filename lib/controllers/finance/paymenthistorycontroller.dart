import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class PaymentHistoryController extends GetxController {

  String? selectedMonth;
  String? selectedDate;
  late DateTime currentDate;
  String selectedFromDate = Jiffy(DateTime.now()).format('MM/dd/yyyy');

  final List months = [
    {"month_text": "January", "month_number": 1},
    {"month_text": "February", "month_number": 2},
    {"month_text": "March", "month_number": 3},
    {"month_text": "April", "month_number": 4},
    {"month_text": "May", "month_number": 5},
    {"month_text": "June", "month_number": 6},
    {"month_text": "July", "month_number": 7},
    {"month_text": "August", "month_number": 8},
    {"month_text": "September", "month_number": 9},
    {"month_text": "October", "month_number": 10},
    {"month_text": "November", "month_number": 11},
    {"month_text": "December", "month_number": 12}
  ];

  DateTime now = DateTime.now();
  List dates = [];



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    int currentMonth = now.month;
    log("Current month");
    log(currentMonth.toString());
    dates = List.generate(currentMonth, (index) => (index + 1).toString());
  }

  updateMonth(monthVal) {
    selectedMonth = monthVal.toString();
    updateDatesByMonth(monthVal);
    update();
  }

  updateDateValue(dateVal) {
    selectedDate = dateVal.toString();
    update();
  }

  void updateDatesByMonth(monthVal) {
    log(monthVal);
    int month = monthVal;
    dates = List.generate(month, (index) => (index + 1).toString());
    update();
  }

  datePicker(BuildContext context) async {
    currentDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ))!;
    if (currentDate != null) {
      selectedFromDate = Jiffy(currentDate).format('MM/dd/yyyy');
    } //if the user has selected a date

    update();
  }
}