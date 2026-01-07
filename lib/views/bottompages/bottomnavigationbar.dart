import 'dart:io';

import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bottompages/bottomnavigationbarcontroller.dart';
import '../../helpers/utilities.dart';

class BottomNavigationTileScreen extends StatelessWidget {
  const BottomNavigationTileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavigationBarController>(
        init: BottomNavigationBarController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    Text(controller.appTitle),
                    controller.selectedIndex == 0
                        ? IconButton(
                            onPressed: () {
                              _showCustomPopup(context, controller);
                            },
                            icon: Icon(
                              Icons.arrow_drop_down_outlined,
                              size: 40,
                              color: Colors.white,
                            ))
                        : Container()
                  ],
                ),
                titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Inter-Medium",
                    fontSize: 20),
                backgroundColor: const Color(0xff004cf1),
              ),
              body: controller.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.purpleAccent,
                      ),
                    )
                  : controller.bottomPages[controller.selectedIndex],
              bottomNavigationBar: Wrap(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: Platform.isAndroid
                            ? MediaQuery.of(context).padding.bottom
                            : 0),
                    child: CircleNavBar(
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
                  ),
                ],
              ),
            ));
  }

  /// 🔥 Custom Popup UI
  void _showCustomPopup(context, controller) {
    Get.dialog(
      Container(
        margin: EdgeInsets.only(bottom: 150),
        child: Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(10),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 30,
                      childAspectRatio: 1),
                  itemCount: controller.locations.length,
                  itemBuilder: (context, index) {
                    var location = controller.locations[index];
                    return GestureDetector(
                      onTap: () {
                        Get.back();
                        controller.updateLocation(
                          location['id'],
                          location['name'],
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Utilities.locationID.toString() ==
                                    location['id'].toString()
                                ? Colors.purple
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home,
                                size: 30,
                                color: Utilities.locationID.toString() ==
                                        location['id'].toString()
                                    ? Colors.white
                                    : Colors.blueAccent,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                location['short_name'],
                                style: TextStyle(
                                    color: Utilities.locationID.toString() ==
                                            location['id'].toString()
                                        ? Colors.white
                                        : Colors.blueAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
