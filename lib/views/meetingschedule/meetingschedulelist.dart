import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/meetingschedule/meetingschedulelistcontroller.dart';
import 'package:maintenanceapp/views/general/generalhome.dart';
import 'package:maintenanceapp/views/meetingschedule/meetingschedule.dart';
import 'package:maintenanceapp/widgets/constants.dart';

import '../bottompages/bottomnavigationbar.dart';

class MeetingScheduleList extends StatefulWidget {
  const MeetingScheduleList({super.key});

  @override
  State<MeetingScheduleList> createState() => _MeetingScheduleListState();
}

class _MeetingScheduleListState extends State<MeetingScheduleList> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeetingScheduleListController>(
        init: MeetingScheduleListController(),
        builder: (mslc) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Meetings",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xFF2c2cff),
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
                leading: GestureDetector(
                  onTap: () {
                    Get.offAll(() => const BottomNavigationTileScreen());
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                  ),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        mslc.handleMultipleShare();
                      },
                      icon: Icon(
                        Icons.share_rounded,
                        size: 35,
                      )),
                  IconButton(
                      onPressed: () {
                        Get.to(() => const MeetingSchedule());
                      },
                      icon: Icon(
                        Icons.add_circle_outline_rounded,
                        size: 35,
                      )),
                  IconButton(
                      onPressed: (){
                        Get.offAll(() => const BottomNavigationTileScreen());
                      },
                      icon: Icon(Icons.home_outlined, size: 35, color: Colors.white,)
                  )
                ],
              ),
              body: Container(
                // height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/bgimg.png'),
                        alignment: Alignment.center,
                        opacity: 0.05)),
                child: mslc.meetingSchedules.isEmpty
                    ? Container(
                        // padding: EdgeInsets.all(8),
                        // margin: EdgeInsets.all(6),
                        //
                        // // width: 100,
                        // height: MediaQuery.of(context).size.height * 0.5,
                        child: Card(
                            color: Colors.white,
                            shadowColor: Colors.purpleAccent,
                            elevation: 5,
                            child: Center(
                                child: Image.asset(
                                    "assets/images/no_data.jpg"))),
                      )
                    : ListView.builder(
                        physics: const ScrollPhysics(),
                        itemCount: mslc.meetingSchedules.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(10),
                                margin:
                                    const EdgeInsets.only(left: 15, top: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blueGrey),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "PRAISE THE LORD SAINTS",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      mslc.meetingSchedules[index]
                                              ['meeting_type']
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Date : ${mslc.meetingSchedules[index]['meeting_date'].toString()}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    Text(
                                      "Time : ${mslc.meetingSchedules[index]['from_time'].toString()} to ${mslc.meetingSchedules[index]['to_time'].toString()} \n Address : ${mslc.meetingSchedules[index]['meeting_mode'].toString() == "1" ? mslc.meetingSchedules[index]['meeting_location'].toString() : "Online"}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: IconButton(
                                        onPressed: () {
                                          mslc.handleShare(
                                              mslc.meetingSchedules[index]);
                                        },
                                        icon: const Icon(
                                          Icons.share_rounded,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: IconButton(
                                        onPressed: () {
                                          Get.off(const MeetingSchedule(),
                                              arguments: mslc
                                                  .meetingSchedules[index]);
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: IconButton(
                                        onPressed: () {
                                          mslc.scheduleId =
                                              mslc.meetingSchedules[index]
                                                  ['scheduleId'];
                                          mslc.showConfirmDialog(context);
                                          mslc.update();
                                        },
                                        icon: const Icon(
                                          Icons.delete_rounded,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                  ),
                                ],
                              )
                            ],
                          );
                        }),
              ),
              // floatingActionButton: Align(
              //   alignment: Alignment.bottomCenter,
              //   child: FloatingActionButton(
              //     onPressed: () {
              //       // Add your action here
              //       Get.off(() => const MeetingSchedule());
              //       print('Plus button pressed!');
              //     },
              //     child: const Icon(
              //       Icons.add,
              //       size: 30,
              //     ),
              //   ),
              // ),
            ));
  }
}
