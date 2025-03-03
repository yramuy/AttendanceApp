import 'dart:developer';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/views/administrative/administrativehome.dart';
import 'package:maintenanceapp/views/bottompages/mannas.dart';
import 'package:maintenanceapp/views/bottompages/meetings.dart';
import 'package:maintenanceapp/views/finance/financehome.dart';
import 'package:maintenanceapp/views/general/generalhome.dart';
import 'package:maintenanceapp/views/loginscreen.dart';
import 'package:maintenanceapp/views/myprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/utilities.dart';
import '../../views/bottompages/prayerrequests.dart';
import '../../views/homescreen.dart';

class BottomNavigationBarController extends GetxController {
  String appTitle = "Welcome to Church in Visakhapatnam";
  int selectedIndex = 0;
  List bottomPages = [];
  String userRole = "";
  List<String> bottomLabels = [];
  List<Widget> inactiveIcons = [];
  List<Widget> activeIcons = [];

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController controller =
      NotchBottomBarController(index: 0);

  @override
  void onInit() {
    // TODO: implement onInit
    setData();
    super.onInit();
  }

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("Role ID");
    log(prefs.getString('roleID').toString());
    userRole = prefs.getString('roleID').toString();

    if (userRole.toString() == "1") {
      bottomPages = [
        const Home(),
        const GeneralHome(),
        const FinanceHome(),
        const AdministrativeHome(),
        const MyProfile(),
      ];
      bottomLabels = ["Home", "Attendance", "Finance", "Administrative", "Account"];
      activeIcons = [
        const Icon(Icons.home_outlined, color: Colors.deepPurple),
        const Icon(Icons.access_time_outlined, color: Colors.deepPurple),
        const Icon(Icons.currency_rupee, color: Colors.deepPurple),
        const Icon(Icons.person_3_outlined, color: Colors.deepPurple),
        const Icon(Icons.person_outlined, color: Colors.deepPurple),
      ];
      inactiveIcons = [
        const Icon(Icons.home_outlined, color: Colors.grey),
        const Icon(Icons.access_time_outlined, color: Colors.grey),
        const Icon(Icons.currency_rupee, color: Colors.grey),
        const Icon(Icons.person_3_outlined, color: Colors.grey),
        const Icon(Icons.person_outlined, color: Colors.grey),
      ];

      update();
    } else if (userRole.toString() == "2") {
      bottomPages = [
        const Home(),
        const GeneralHome(),
        const FinanceHome(),
        const MyProfile(),
      ];
      bottomLabels = ["Home", "Attendance", "Finance", "Account"];
      activeIcons = [
        const Icon(Icons.home_outlined, color: Colors.deepPurple),
        const Icon(Icons.access_time_outlined, color: Colors.deepPurple),
        const Icon(Icons.currency_rupee, color: Colors.deepPurple),
        const Icon(Icons.person_outlined, color: Colors.deepPurple),
      ];
      inactiveIcons = [
        const Icon(Icons.home_outlined, color: Colors.grey),
        const Icon(Icons.access_time_outlined, color: Colors.grey),
        const Icon(Icons.currency_rupee, color: Colors.grey),
        const Icon(Icons.person_outlined, color: Colors.grey),
      ];

      update();
    } else if (userRole.toString() == "3") {
      bottomPages = [
        const Home(),
        const GeneralHome(),
        const AdministrativeHome(),
        const MyProfile(),
      ];
      bottomLabels = ["Home", "Attendance", "Administrative", "Account"];
      activeIcons = [
        const Icon(Icons.home_outlined, color: Colors.deepPurple),
        const Icon(Icons.access_time_outlined, color: Colors.deepPurple),
        const Icon(Icons.person_3_outlined, color: Colors.deepPurple),
        const Icon(Icons.person_outlined, color: Colors.deepPurple),
      ];
      inactiveIcons = [
        const Icon(Icons.home_outlined, color: Colors.grey),
        const Icon(Icons.access_time_outlined, color: Colors.grey),
        const Icon(Icons.person_3_outlined, color: Colors.grey),
        const Icon(Icons.person_outlined, color: Colors.grey),
      ];

      update();
    } else if (userRole.toString() == "4") {
      bottomPages = [
        const Home(),
        const GeneralHome(),
        const MyProfile(),
      ];
      bottomLabels = ["Home", "Attendance", "Account"];
      activeIcons = [
        const Icon(Icons.home_outlined, color: Colors.deepPurple),
        const Icon(Icons.access_time_outlined, color: Colors.deepPurple),
        const Icon(Icons.person_outlined, color: Colors.deepPurple),
      ];
      inactiveIcons = [
        const Icon(Icons.home_outlined, color: Colors.grey),
        const Icon(Icons.access_time_outlined, color: Colors.grey),
        const Icon(Icons.person_outlined, color: Colors.grey),
      ];

      update();
    }

    update();
  }

  updateIndex(index) {
    log('current selected index $index');
    selectedIndex = index;
    if (index == 0) {
      appTitle = "Welcome to Church in Visakhapatnam";
    } else if (index == 1) {
      Utilities.navId = "1";
      appTitle = "Attendance";
    } else if (index == 2) {
      if (userRole == "4") {
        appTitle = "Account";
      } else if (userRole == "3") {
        Utilities.navId = "3";
        appTitle = "Administration";
      } else if (userRole == "2") {
        Utilities.navId = "2";
        appTitle = "Finance";
      } else if (userRole == "1") {
        Utilities.navId = "2";
        appTitle = "Finance";
      }
    } else if (index == 3) {
      if (userRole == "1") {
        appTitle = "Administration";
        Utilities.navId = "3";
      } else if (userRole == "2") {
        appTitle = "Account";
      } else if (userRole == "3") {
        appTitle = "Account";
      }
    } else if (index == 4) {
      if (userRole == "1") {
        appTitle = "Account";
      }
    }
    update();
  }

  clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    await prefs.clear();
    log('data cleared');
    Get.offAll(() => const LoginScreen());
    update();
  }
}
