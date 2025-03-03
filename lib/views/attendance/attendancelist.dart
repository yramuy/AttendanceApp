import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:maintenanceapp/controllers/attendance/attendancelistcontroller.dart';
import 'package:maintenanceapp/views/attendance/attendance.dart';

import '../bottompages/bottomnavigationbar.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceListController>(
        init: AttendanceListController(),
        builder: (alc) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Attendance List",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xFF2c2cff),
                // centerTitle: true,
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
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () {
                          Get.to(() => const Attendance());
                        },
                        icon: Icon(
                          Icons.add_circle_outline_rounded,
                          size: 35,
                        )),
                  ),
                  IconButton(
                      onPressed: (){
                        Get.offAll(() => const BottomNavigationTileScreen());
                      },
                      icon: Icon(Icons.home_outlined, size: 35, color: Colors.white,)
                  )
                ],
              ),
              body: alc.isLoading == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.purpleAccent,
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 1,
                        width: MediaQuery.of(context).size.width * 1,
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            image: const DecorationImage(
                                image: AssetImage('assets/images/bgimg.png'),
                                alignment: Alignment.center,
                                opacity: 0.05)),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Container(
                              //   // padding: EdgeInsets.all(5),
                              //   margin: EdgeInsets.all(5),
                              //   height: 50,
                              //   width: MediaQuery.of(context).size.width * 0.9,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(10),
                              //       border: Border.all(color: Colors.grey),
                              //       color: Colors.white),
                              //   child: DropdownButtonFormField(
                              //     // value: controller.districtId,
                              //     value: alc.meetingTypeId.toString() != '0'
                              //         ? alc.meetingTypeId.toString()
                              //         : null, // Default to null if no valid selection
                              //     isExpanded: true,
                              //     isDense: true,
                              //     hint: const Text("--Select Meeting Type--"),
                              //     decoration: const InputDecoration(
                              //         contentPadding: EdgeInsets.only(left: 10),
                              //         border: OutlineInputBorder(
                              //             borderSide: BorderSide.none)),
                              //     items: alc.meetingTypes.map((e) {
                              //       return DropdownMenuItem(
                              //         value: e['id'].toString(),
                              //         child: Text(e['name'].toString()),
                              //       );
                              //     }).toList(),
                              //     onChanged: (value) {
                              //       alc.meetingTypeId = value.toString();
                              //       alc.handleMeetingType(value.toString());
                              //       alc.update();
                              //     },
                              //     validator: (value) {
                              //       if (value == "") {
                              //         return "Meeting Type is required";
                              //       }
                              //
                              //       return null;
                              //     },
                              //   ),
                              // ),
                              Row(
                                children: [
                                  Container(
                                    // padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),
                                    height: 50,
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.white),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.only(left: 12),
                                      leading: Text(
                                        alc.meetingDate,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      trailing: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: IconButton(
                                            iconSize: 25,
                                            onPressed: () {
                                              alc.datePicker(context);
                                            },
                                            icon: const Icon(
                                              Icons.calendar_month_rounded,
                                              color: Color(0xff005F01),
                                            )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    // padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.white),
                                    child: DropdownButtonFormField(
                                      // value: controller.districtId,
                                      value: alc.districtId.toString() != '0'
                                          ? alc.districtId.toString()
                                          : null, // Default to null if no valid selection
                                      isExpanded: true,
                                      isDense: true,
                                      hint: const Text("--Select District--"),
                                      decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none)),
                                      items: alc.districts.map((e) {
                                        return DropdownMenuItem(
                                          value: e['id'].toString(),
                                          child: Text(e['name'].toString()),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        alc.districtId = value.toString();
                                        alc.handleDistrict(value.toString());
                                        alc.update();
                                      },
                                      validator: (value) {
                                        if (value == "") {
                                          return "District is required";
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Container(
                              //       padding: EdgeInsets.all(10),
                              //       margin: EdgeInsets.all(10),
                              //       height: 80,
                              //       width: 100,
                              //       decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(10),
                              //           color: Colors.white),
                              //       child: Column(
                              //         children: [
                              //           Text(
                              //             alc.total.toString(),
                              //             style: TextStyle(
                              //                 color: Colors.blueAccent,
                              //                 fontWeight: FontWeight.bold,
                              //                 fontSize: 18),
                              //           ),
                              //           Text("Total",
                              //               style: TextStyle(
                              //                   color: Colors.blueAccent,
                              //                   fontWeight: FontWeight.bold,
                              //                   fontSize: 18))
                              //         ],
                              //       ),
                              //     ),
                              //     Container(
                              //       padding: EdgeInsets.all(10),
                              //       margin: EdgeInsets.all(10),
                              //       height: 80,
                              //       width: 100,
                              //       decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(10),
                              //           color: Colors.white),
                              //       child: Column(
                              //         children: [
                              //           Text(
                              //             alc.present.toString(),
                              //             style: TextStyle(
                              //                 color: Colors.green,
                              //                 fontWeight: FontWeight.bold,
                              //                 fontSize: 18),
                              //           ),
                              //           Text("Present",
                              //               style: TextStyle(
                              //                   color: Colors.green,
                              //                   fontWeight: FontWeight.bold,
                              //                   fontSize: 18))
                              //         ],
                              //       ),
                              //     ),
                              //     Container(
                              //       padding: EdgeInsets.all(10),
                              //       margin: EdgeInsets.all(10),
                              //       height: 80,
                              //       width: 100,
                              //       decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(10),
                              //           color: Colors.white),
                              //       child: Column(
                              //         children: [
                              //           Text(
                              //             alc.absent.toString(),
                              //             style: TextStyle(
                              //                 color: Colors.red,
                              //                 fontWeight: FontWeight.bold,
                              //                 fontSize: 18),
                              //           ),
                              //           Text("Absent",
                              //               style: TextStyle(
                              //                   color: Colors.red,
                              //                   fontWeight: FontWeight.bold,
                              //                   fontSize: 18))
                              //         ],
                              //       ),
                              //     )
                              //   ],
                              // ),
                              Container(
                                margin: EdgeInsets.all(5),
                                height: 40,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width:180,
                                      child: Text("Name",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Inter-Medium",
                                              fontSize: 14)),
                                    ),
                                    Row(
                                      children: [
                                        Text("PM",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Inter-Medium",
                                                fontSize: 14)),
                                        SizedBox(
                                          width:40,
                                        ),
                                        Text("GM",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Inter-Medium",
                                                fontSize: 14)),
                                        SizedBox(
                                          width:40,
                                        ),
                                        Text("LTM",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Inter-Medium",
                                                fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                  physics: const ScrollPhysics(),
                                  itemCount: alc.saints.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      height: 50,
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                                "${index + 1} . ${alc.saints[index]['name']}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily: "Inter-Medium",
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ),
                                          Container(
                                            // margin: EdgeInsets.only(right: 80),
                                            child: alc.saints[index]
                                                            ['meetingAttendance']['tuesdayMeeting']
                                                        .toString() ==
                                                    "null"
                                                ? Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      // Outer circle (empty attendance icon)
                                                      Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: Colors.blue,
                                                            width: 2,
                                                          ),
                                                        ),
                                                      ),
                                                      // Inner circle
                                                      // Container(
                                                      //   width: 40,
                                                      //   height: 40,
                                                      //   decoration:
                                                      //       BoxDecoration(
                                                      //     shape:
                                                      //         BoxShape.circle,
                                                      //     color: Colors
                                                      //         .blue, // You can change the color as needed
                                                      //   ),
                                                      // ),
                                                    ],
                                                  )
                                                : alc.saints[index]
                                            ['meetingAttendance']['tuesdayMeeting']
                                                .toString() ==
                                                        '1'
                                                    ? Container(
                                                        width: 40.0,
                                                        height: 40.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors
                                                              .green, // You can change the color as needed
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.check,
                                                            color: Colors
                                                                .white, // You can change the color as needed
                                                            size:
                                                                25.0, // You can adjust the size as needed
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 40.0,
                                                        height: 40.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors
                                                              .redAccent, // You can change the color as needed
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.close,
                                                            color: Colors
                                                                .white, // You can change the color as needed
                                                            size:
                                                                25.0, // You can adjust the size as needed
                                                          ),
                                                        ),
                                                      ),
                                          ),
                                          Container(
                                            // margin: EdgeInsets.only(right: 80),
                                            child: alc.saints[index]
                                            ['meetingAttendance']['fridayMeeting']
                                                .toString() ==
                                                "null"
                                                ? Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                // Outer circle (empty attendance icon)
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration:
                                                  BoxDecoration(
                                                    shape:
                                                    BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.blue,
                                                      width: 2,
                                                    ),
                                                  ),
                                                ),
                                                // Inner circle

                                              ],
                                            )
                                                : alc.saints[index]
                                            ['meetingAttendance']['fridayMeeting']
                                                .toString() ==
                                                '1'
                                                ? Container(
                                              width: 40.0,
                                              height: 40.0,
                                              decoration:
                                              BoxDecoration(
                                                shape:
                                                BoxShape.circle,
                                                color: Colors
                                                    .green, // You can change the color as needed
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors
                                                      .white, // You can change the color as needed
                                                  size:
                                                  25.0, // You can adjust the size as needed
                                                ),
                                              ),
                                            )
                                                : Container(
                                              width: 40.0,
                                              height: 40.0,
                                              decoration:
                                              BoxDecoration(
                                                shape:
                                                BoxShape.circle,
                                                color: Colors
                                                    .redAccent, // You can change the color as needed
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors
                                                      .white, // You can change the color as needed
                                                  size:
                                                  25.0, // You can adjust the size as needed
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // margin: EdgeInsets.only(right: 80),
                                            child: alc.saints[index]
                                            ['meetingAttendance']['sundayMeeting']
                                                .toString() ==
                                                "null"
                                                ? Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                // Outer circle (empty attendance icon)
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration:
                                                  BoxDecoration(
                                                    shape:
                                                    BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.blue,
                                                      width: 2,
                                                    ),
                                                  ),
                                                ),
                                                // Inner circle
                                                // Container(
                                                //   width: 40,
                                                //   height: 40,
                                                //   decoration:
                                                //   BoxDecoration(
                                                //     shape:
                                                //     BoxShape.circle,
                                                //     color: Colors
                                                //         .blue, // You can change the color as needed
                                                //   ),
                                                // ),
                                              ],
                                            )
                                                : alc.saints[index]
                                            ['meetingAttendance']['sundayMeeting']
                                                .toString() ==
                                                '1'
                                                ? Container(
                                              width: 40.0,
                                              height: 40.0,
                                              decoration:
                                              BoxDecoration(
                                                shape:
                                                BoxShape.circle,
                                                color: Colors
                                                    .green, // You can change the color as needed
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors
                                                      .white, // You can change the color as needed
                                                  size:
                                                  25.0, // You can adjust the size as needed
                                                ),
                                              ),
                                            )
                                                : Container(
                                              width: 40.0,
                                              height: 40.0,
                                              decoration:
                                              BoxDecoration(
                                                shape:
                                                BoxShape.circle,
                                                color: Colors
                                                    .redAccent, // You can change the color as needed
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors
                                                      .white, // You can change the color as needed
                                                  size:
                                                  25.0, // You can adjust the size as needed
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
            ));
  }
}
