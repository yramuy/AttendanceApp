import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:maintenanceapp/views/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileController extends GetxController {
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userRole;
  String? imagePath = "";
  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  getUserData() async {
    SharedPreferences userPref = await SharedPreferences.getInstance();
    userName = userPref.getString("name");
    userEmail = userPref.getString("email");
    userPhone = userPref.getString("userMob");
    userRole = userPref.getString("roleName");
    imagePath = userPref.getString("imagePath").toString();
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
