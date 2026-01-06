import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/settingscontroller.dart';
import 'package:maintenanceapp/helpers/utilities.dart';
import 'package:maintenanceapp/views/bottompages/bottomnavigationbar.dart';
import 'package:maintenanceapp/views/homescreen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
        init: SettingsController(),
        builder: (controller) => Scaffold(
              body: controller.isLoading == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.purpleAccent,
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.3),
                          image: const DecorationImage(
                              image: AssetImage('assets/images/bgimg.png'),
                              alignment: Alignment.center,
                              opacity: 0.05)),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 30,
                                    childAspectRatio: 1),
                            itemCount: controller.locations.length,
                            itemBuilder: (context, index) {
                              var location = controller.locations[index];
                              return GestureDetector(
                                onTap: () {
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
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.home,
                                          size: 30,
                                          color:
                                              Utilities.locationID.toString() ==
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
                                              color: Utilities.locationID
                                                          .toString() ==
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
            ));
  }
}
