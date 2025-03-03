import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/bottompages/bottomnavigationbar.dart';
import '../views/loginscreen.dart';

class SplashScreenController extends GetxController {
  double opacityLevel = 1.0;
  bool loginValue = false;

  final LocalAuthentication auth = LocalAuthentication();
  late bool isAvailable = false;
  bool _canCheckBiometrics = false;
  String authorized = 'Not Authorized';
  bool authenticated = false;

  void _changeOpacity() {
    opacityLevel = opacityLevel == 0 ? 1.0 : 0.0;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    checkBiometric();

    Timer(const Duration(seconds: 3), () {
      _changeOpacity();
    });
    super.onInit();
  }

  checkBiometric() async {
    bool checkBiometrics;
    try {
      checkBiometrics = await auth.canCheckBiometrics;
      update();
    } on PlatformException catch (e) {
      checkBiometrics = false;
      update();
      log(e.toString());
    }

    log("checkBiometrics $checkBiometrics");

    _canCheckBiometrics = checkBiometrics;
    condition();
    update();
  }

  condition() {
    log("_canCheckBiometrics $_canCheckBiometrics");
    if (_canCheckBiometrics) {
      authenticate();
    } else {
      checkBiometric();
    }

    update();
  }

  authenticate() async {
    log("authenticate");
    try {
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
      );

      log("authenticated");

      authorized = 'Authenticating';

      log("authorized $authorized");
      update();
    } on PlatformException catch (e) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';

    authorized = message;

    log("authorized $authorized");
    update();
    if (message.toString() == 'Authorized') {
      biometricData(authorized);
    } else {
      authenticate();
    }
  }

  biometricData(biometric) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('biometric', biometric);
    loadNavigationScreen();
    update();


  }

  getLoginStatus() async {
    SharedPreferences userPref = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(milliseconds: 1500));
    log("isLogin ${userPref.getBool('isLogin')}");
    if (userPref.getBool('isLogin') == null) {
      return false;
    } else {
      return true;
    }
  }

  loadNavigationScreen() async {
    log("loadNavigationScreen");
    getLoginStatus().then((status) {
      log("stats $status");
      if (status) {
        navigateToHome();
      } else {
        navigateToLogin();
      }
      update();
    });
    update();
  }

  navigateToHome() {
    Timer(const Duration(seconds: 3),
        () => Get.offAll(() => const BottomNavigationTileScreen()));
  }

  navigateToLogin() {
    Timer(const Duration(seconds: 3),
        () => Get.offAll(() => const LoginScreen()));
  }
}
