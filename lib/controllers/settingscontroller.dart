import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:maintenanceapp/apiservice/restapi.dart';
import 'package:maintenanceapp/controllers/bottompages/bottomnavigationbarcontroller.dart';
import 'package:maintenanceapp/helpers/utilities.dart';

class SettingsController extends GetxController {
  List locations = [];
  bool isLoading = false;
  bool isLocation = false;
  final BottomNavigationBarController bnc =
      Get.put(BottomNavigationBarController());

  @override
  void onInit() {
    // TODO: implement onInit
    loadLocations();
    // loadLoginData();
    super.onInit();
  }

  updateLocation(id, name) {
    isLoading = true;
    Utilities.locationID = id;
    Utilities.locationName = name;
    log("Location ID28 : $id");

    bnc.updateIndex(0);
    isLoading = false;
    update();
  }

  loadLocations() async {
    isLoading = true;
    await ApiService.get('locations').then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          locations = responseBody['locations'];
          update();
        } else {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: responseBody['message'].toString());
          update();
        }
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: 'Something went wrong, Please retry later');
        update();
      }
    });

    isLoading = false;
    update();

    log("Locations $locations");
  }
}
