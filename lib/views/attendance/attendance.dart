import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:maintenanceapp/controllers/attendance/attendancecontroller.dart';
import 'package:maintenanceapp/views/attendance/attendancelist.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(
        init: AttendanceController(),
        builder: (ac) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Attendance",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xFF2c2cff),
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
                leading: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                  ),
                ),
              ),
              body: SingleChildScrollView(
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
                        Container(
                          // padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              color: Colors.white),
                          child: DropdownButtonFormField(
                            // value: controller.districtId,
                            value: ac.meetingTypeId.toString() != '0'
                                ? ac.meetingTypeId.toString()
                                : null, // Default to null if no valid selection
                            isExpanded: true,
                            isDense: true,
                            hint: const Text("--Select Meeting Type--"),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                            items: ac.meetingTypes.map((e) {
                              return DropdownMenuItem(
                                value: e['id'].toString(),
                                child: Text(e['name'].toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              ac.meetingTypeId = value.toString();
                              ac.handleMeetingType(value.toString());
                              ac.update();
                            },
                            validator: (value) {
                              if (value == "") {
                                return "Meeting Type is required";
                              }

                              return null;
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              // padding: EdgeInsets.all(5),
                              // margin: EdgeInsets.all(5),
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white),
                              child: ListTile(
                                contentPadding: const EdgeInsets.only(left: 12),
                                leading: Text(
                                  ac.meetingDate,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                trailing: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: IconButton(
                                      iconSize: 25,
                                      onPressed: () {
                                        ac.datePicker(context);
                                      },
                                      icon: const Icon(
                                        Icons.calendar_month_rounded,
                                        color: Color(0xff005F01),
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              // padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white),
                              child: DropdownButtonFormField(
                                // value: controller.districtId,
                                value: ac.districtId.toString() != '0'
                                    ? ac.districtId.toString()
                                    : null, // Default to null if no valid selection
                                isExpanded: true,
                                isDense: true,
                                hint: const Text("--Select District--"),
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none)),
                                items: ac.districts.map((e) {
                                  return DropdownMenuItem(
                                    value: e['id'].toString(),
                                    child: Text(e['name'].toString()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  ac.districtId = value.toString();
                                  ac.handleDistrict(value.toString());
                                  ac.update();
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
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Container(
                              child: ElevatedButton(
                                  onPressed: () {
                                    ac.handleUpdateChildrenAttendance();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  child: Text(
                                    "Update Children Attendance",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Inter-Medium",
                                        fontSize: 14),
                                  )),
                            ),
                            SizedBox(width: 10,),
                            ElevatedButton(
                                onPressed: (){
                                  ac.handleReset();
                                },
                                child: Text("Reset", style: TextStyle(
                                    fontFamily: "Inter-Medium",
                                    fontSize: 14, color: Colors.redAccent),)
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.all(5),
                          height: 50,
                          padding: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue.shade100),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text("ID", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
                              // SizedBox(width: 50,),
                              Text("${ac.nameText.toString()}",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              // SizedBox(
                              //   width: 40,
                              // ),
                              Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Text("Attendance",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16))),
                              // SizedBox(height: 5,),
                            ],
                          ),
                        ),
                        if (ac.isLoading == true)
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.purpleAccent,
                            ),
                          )
                        else
                          ListView.builder(
                              physics: const ScrollPhysics(),
                              itemCount: ac.saints.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 10),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                            "${index + 1} . ${ac.saints[index]['name']}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 2),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                ac.handleAttendance(index, '1',
                                                    ac.saints[index]['id'],ac.saints[index]['saintTypeId']);
                                                log("Pressed on Present");
                                              },
                                              child: Column(
                                                children: [
                                                  ac.isToggled[index]
                                                              .toString() ==
                                                          '1'
                                                      ? Container(
                                                          width: 30.0,
                                                          height: 30.0,
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
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color:
                                                                  Colors.blue,
                                                              width: 2,
                                                            ),
                                                          ),
                                                        ),
                                                  Text(
                                                    "Present",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontFamily:
                                                            "Inter-Medium",
                                                        fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                ac.handleAttendance(index, '0',
                                                    ac.saints[index]['id'],ac.saints[index]['saintTypeId']);
                                                log("Pressed on Absent");
                                              },
                                              child: Column(
                                                children: [
                                                  ac.isToggled[index]
                                                              .toString() ==
                                                          '0'
                                                      ? Container(
                                                          width: 30.0,
                                                          height: 30.0,
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
                                                        )
                                                      : Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color:
                                                                  Colors.blue,
                                                              width: 2,
                                                            ),
                                                          ),
                                                        ),
                                                  Text(
                                                    "Absent",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontFamily:
                                                            "Inter-Medium",
                                                        fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                          ],
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
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ac.handleSave();
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Get.off(() => const AttendanceList());
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey)),
                  ],
                ),
              ),
            ));
  }
}
