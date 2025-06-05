import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bottompages/bottomnavigationbarcontroller.dart';

class BottomNavigationTileScreen extends StatelessWidget {
  const BottomNavigationTileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavigationBarController>(
        init: BottomNavigationBarController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                title: Text(controller.appTitle),
                titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Inter-Medium",
                    fontSize: 20),
                backgroundColor: const Color(0xff004cf1),
              ),
              body: controller.bottomPages[controller.selectedIndex],
              bottomNavigationBar: CircleNavBar(
                activeIcons: controller.activeIcons,
                inactiveIcons: controller.inactiveIcons,

                color: Colors.white,
                height: 60,
                circleWidth: 50,
                activeIndex: controller.selectedIndex,

                // padding: const EdgeInsets.only(bottom: 10),
                onTap: (index) {
                  controller.updateIndex(index);
                },
                shadowColor: Colors.purple.shade100,
                elevation: 10,
                circleShadowColor: Colors.purple,
                levels: controller.bottomLabels,
                inactiveLevelsStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontFamily: "Inter-Medium",
                ),
                activeLevelsStyle: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ));
  }
}
