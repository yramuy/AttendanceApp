import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiservice/restapi.dart';

class SubMenuController extends GetxController {
  dynamic argumentData = Get.arguments;
  String menuId = "";
  String menuName = "";
  String roleId = "";
  List menus = [];

  @override
  void onInit() {
    super.onInit();

  }




}
