import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiservice/restapi.dart';
import '../helpers/utilities.dart';

class MenuDataController extends GetxController {
  String roleId = "";
  List menuData = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getMenuData();
  }

  Future<void> getMenuData() async {
    SharedPreferences userPref = await SharedPreferences.getInstance();
    roleId = userPref.getString('roleID').toString();
    var id = Utilities.navId.toString();

    var body =
        jsonEncode({"parent_id": id, "role_id": roleId, "type": 'child'});
    await ApiService.post("menus", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          menuData = responseBody['menus'];
          // log("message --------------");
          // log(menuData.toString());
        }
      } else {
        Get.snackbar('Alert', 'Something went wrong, Please retry later',
            backgroundColor: Colors.blueAccent,
            barBlur: 20,
            overlayBlur: 5,
            colorText: Colors.white,
            animationDuration: const Duration(seconds: 3));
      }
    });

    update();
  }
}
