import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class CreditWithdrawalPaymentController extends GetxController {
  List paymentTypes = [];
  List locations = [];
  List offeringTypes = [];
  String selectedItem = "-- Select --";
  bool flag = true;
  late DateTime currentDate;
  String selectedFromDate = Jiffy(DateTime.now()).format('MM/dd/yyyy');
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getPaymentType();
    getLocations();
    getOfferingTypes();
  }

  void getPaymentType() {
    paymentTypes = [
      {'id': 1, 'name': "Received"},
      {'id': 2, 'name': "Expenses"}
    ];
    update();
  }

  void getLocations() {
    locations = [
      {'id': 1, 'name': "Aganampudi"},
      {'id': 2, 'name': "Gajuwaka"},
      {'id': 3, 'name': "Vizag City"}
    ];
    update();
  }

  void getOfferingTypes() {
    offeringTypes = [
      {'id': 1, 'name': "General Offerings"},
      {'id': 2, 'name': "Tithes(10%)"},
      {'id': 3, 'name': "Translation"},
      {'id': 4, 'name': "Love feast"},
      {'id': 5, 'name': "Land"},
    ];
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

  handlePaymentType(value) {
    if (value == "Received") {
      flag = true;
    } else {
      flag = false;
    }
    update();
  }
}
