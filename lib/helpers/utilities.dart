import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/views/administrative/administrativehome.dart';
import 'package:maintenanceapp/views/finance/financehome.dart';
import 'package:maintenanceapp/views/general/generalhome.dart';

class Utilities {
  static dynamic dynMenudata;
  static String? navId;

  static mainNavigateUrl(navId, context) {
    if (navId == '1') {
      Get.to(() => const GeneralHome());
    } else if (navId == '2') {
      Get.to(() => const FinanceHome());
    } else if (navId == '3') {
      Get.to(() => const AdministrativeHome());
    }
  }
}
