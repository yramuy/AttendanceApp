import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/restapi.dart';
import '../../helpers/utilities.dart';
import '../menudatacontroller.dart';

class GeneralHomeController extends GetxController {
  List submenus = [];
  bool isLoading = true;
  String roleId = "";

  @override
  void onInit() {
    // TODO: implement onInit
    loadSubMenus();
    super.onInit();
  }

  loadSubMenus() async {
    SharedPreferences userPref = await SharedPreferences.getInstance();
    roleId = userPref.getString('roleID').toString();
    var id = Utilities.navId.toString();
    log("message");
    log("$roleId $id");

    var body =
        jsonEncode({"parent_id": id, "role_id": roleId, "type": 'child'});
    await ApiService.post("menus", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          log(submenus.toString());
          isLoading = false;
          submenus = responseBody['menus'];
          log("submenus  11111111111");
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
