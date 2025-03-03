import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splashscreencontroller.dart';
import '../widgets/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
      init: SplashScreenController(),
      builder: (controller) {
        return Scaffold(
            body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  image: const DecorationImage(
                      image: AssetImage('assets/images/bgimg.png'),
                      alignment: Alignment.center,
                      opacity: 0.05)),
            ),
            Center(
                widthFactor: 20.0,
                heightFactor: 20.0,
                child: ClipOval(
                  child: Image.asset(
                    Constants.logoImage,
                    scale: 1.2,
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
                  ),
                ))
          ],
        ));
      },
    );
  }
}
