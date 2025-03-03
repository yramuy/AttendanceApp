import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/administrative/administrativehomecontroller.dart';
import 'package:maintenanceapp/views/administrative/booksorder.dart';
import 'package:maintenanceapp/views/administrative/collectbooksamount.dart';

import '../../widgets/constants.dart';
import '../lifestudy/assignlifestudyquestions.dart';
import '../lifestudy/lifestudyquestionlist.dart';
import '../meetingschedule/meetingschedule.dart';
import '../meetingschedule/meetingschedulelist.dart';

class AdministrativeHome extends StatefulWidget {
  const AdministrativeHome({super.key});

  @override
  State<AdministrativeHome> createState() => _AdministrativeHomeState();
}

class _AdministrativeHomeState extends State<AdministrativeHome> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdministrativeHomeController>(
        init: AdministrativeHomeController(),
        builder: (controller) => Scaffold(
              // appBar: AppBar(
              //   title: const Text(
              //     'Administrative',
              //     style: TextStyle(
              //         color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   backgroundColor: const Color(0xff005F01),
              //   centerTitle: true,
              //   iconTheme: const IconThemeData(color: Colors.white),
              // ),
              body: Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/bgimg.png'),
                        alignment: Alignment.center,
                        opacity: 0.05)),
                child: controller.isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.purpleAccent,
                        ),
                      )
                    : controller.submenus.isNotEmpty
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                      child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 2,
                                            mainAxisSpacing: 2,
                                            childAspectRatio: 1),
                                    itemCount: controller.submenus.length,
                                    itemBuilder: (BuildContext context, index) {
                                      // var menuData = jsonDecode(controller.menus.toString());
                                      return GestureDetector(
                                        onTap: () {
                                          if (controller.submenus[index]['id'].toString() == "8" ||
                                              controller.submenus[index]['id'].toString() ==
                                                  "50") {
                                            Get.to(const BooksOrder());
                                          } else if (controller.submenus[index]['id'].toString() == '10' ||
                                              controller.submenus[index]['id'].toString() ==
                                                  '51') {
                                            Get.to(const CollectBooksAmount());
                                          } else if (controller.submenus[index]['id'].toString() == "14" ||
                                              controller.submenus[index]['id'].toString() ==
                                                  "24" ||
                                              controller.submenus[index]['id'].toString() ==
                                                  "30" ||
                                              controller.submenus[index]['id'].toString() ==
                                                  "42") {
                                            Get.to(
                                                () => const MeetingSchedule());
                                          } else if (controller.submenus[index]['id'].toString() == "15" ||
                                              controller.submenus[index]['id'].toString() ==
                                                  "25" ||
                                              controller.submenus[index]['id'].toString() ==
                                                  "31" ||
                                              controller.submenus[index]['id'].toString() ==
                                                  "43") {
                                            Get.to(() =>
                                                const MeetingScheduleList());
                                          } else if (controller.submenus[index]['id'].toString() == "18" ||
                                              controller.submenus[index]['id'].toString() ==
                                                  "28" ||
                                              controller.submenus[index]['id']
                                                      .toString() ==
                                                  "34" ||
                                              controller.submenus[index]['id']
                                                      .toString() ==
                                                  "46") {
                                            Get.to(() =>
                                                AssignLifeStudyQuestions());
                                          } else if (controller.submenus[index]['id'].toString() == "19" ||
                                              controller.submenus[index]['id'].toString() == "29" ||
                                              controller.submenus[index]['id'].toString() == "35" ||
                                              controller.submenus[index]['id'].toString() == "47") {
                                            Get.to(
                                                () => LifeStudyQuestionList());
                                          }
                                        },
                                        child: Card(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              CircleAvatar(
                                                radius: 30,
                                                foregroundImage: NetworkImage(
                                                    controller.submenus[index]
                                                            ['img_path']
                                                        .toString(),
                                                    scale: 40),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  controller.submenus[index]
                                                          ['name']
                                                      .toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                                )
                              ],
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Text(
                              'No Menus Found',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Constants.darkBlue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
              ),
            ));
  }
}
