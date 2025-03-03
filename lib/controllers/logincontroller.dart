import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/views/bottompages/bottomnavigationbar.dart';
import 'package:maintenanceapp/views/homescreen.dart';
import 'package:maintenanceapp/views/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apiservice/restapi.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showLoginPassword = true;
  final formKey = GlobalKey<FormState>();

  showPassword() {
    showLoginPassword = !showLoginPassword;
    update();
  }

  login(userName, password) async {
    var body = jsonEncode({"username": userName, "password": password});
    log("body");
    log(body);
    ApiService.post("login", body).then((success) {
      print(success);
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: responseBody['message'].toString());
          loginUserData(responseBody);
          Get.offAll(() => const BottomNavigationTileScreen());
        } else {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: responseBody['message'].toString());
        }
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: "Something went wrong, Please retry later");
      }
      update();
    });
  }

  Future<void> loginUserData(response) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("userID", response["data"]['id'].toString());
    pref.setString("name", response["data"]['name'].toString());
    pref.setString("userName", response["data"]['username'].toString());
    pref.setString("roleName", response["data"]['role_name'].toString());
    pref.setString("roleID", response["data"]['role_id'].toString());
    pref.setString("userMob", response["data"]['mobile_number'].toString());
    pref.setString("email", response["data"]['email'].toString());
    pref.setString("imagePath", response["data"]['image_path'].toString());
    pref.setBool("isLogin", true);
  }
}
