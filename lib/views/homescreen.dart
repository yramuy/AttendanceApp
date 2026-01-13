import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/homecontroller.dart';
import 'package:maintenanceapp/helpers/utilities.dart';
import 'package:maintenanceapp/views/attendance/attendancelist.dart';
import 'package:maintenanceapp/views/attendance/attendancereport.dart';
import 'package:maintenanceapp/views/myprofile.dart';
import 'package:maintenanceapp/views/saint/saints.dart';
import 'package:maintenanceapp/views/submenu.dart';

import '../widgets/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) => Scaffold(
              body: controller.isLoading == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.purpleAccent,
                      ),
                    )
                  : Container(
                      // height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          image: const DecorationImage(
                              image: AssetImage('assets/images/bgimg.png'),
                              alignment: Alignment.center,
                              opacity: 0.05)),
                      child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.blue,
                                        blurRadius: 5,
                                        spreadRadius: 2),
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.blue),
                                        color: Colors.white),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.datePicker(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              controller.meetingDate,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontFamily: "Inter-Medium"),
                                            ),
                                          ),
                                          IconButton(
                                              iconSize: 25,
                                              onPressed: () {
                                                controller.datePicker(context);
                                              },
                                              icon: const Icon(
                                                Icons.calendar_month_rounded,
                                                color: Color(0xff005F01),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          onPressed: () async {
                                            await controller
                                                .generateReport('week');
                                          },
                                          child: Text("Weekly Report",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          onPressed: () async {
                                            controller.handleReport('month');
                                          },
                                          child: Text("Monthly Report",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10, top: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.orange,
                                        blurRadius: 5,
                                        spreadRadius: 2)
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.57,
                                    child: DefaultTabController(
                                      length: 2,
                                      child: Column(
                                        children: [
                                          TabBar(
                                            tabs: [
                                              Tab(
                                                  icon: Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 30,
                                                  ),
                                                  text: 'Attendees'),
                                              Tab(
                                                  icon: Icon(
                                                    Icons.cancel_rounded,
                                                    color: Colors.red,
                                                    size: 30,
                                                  ),
                                                  text: 'Absentees'),
                                            ],
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              children: [
                                                DataTable(
                                                  columnSpacing: 5,
                                                  horizontalMargin: 10,
                                                  dataRowMinHeight: 40,
                                                  dataRowMaxHeight: 60,
                                                  // showCheckboxColumn: true,
                                                  columns: [
                                                    DataColumn(
                                                        label: SizedBox(
                                                      width: 100,
                                                      child: Text('Meetings',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  "Inter-Medium",
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    )),
                                                    DataColumn(
                                                        label: Text('Agp',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    DataColumn(
                                                        label: Text('City',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    DataColumn(
                                                        label: Text('Akp',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    DataColumn(
                                                        label: Text('Gwk',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    DataColumn(
                                                        label: Text('Total (%)',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                  ],
                                                  rows: [
                                                    DataRow(cells: [
                                                      DataCell(SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                            "Lord's Table Meeting",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14)),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .sundayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '1',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Lord's Table Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .sundayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "1",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .sundayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '4',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Lord's Table Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .sundayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "4",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .sundayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '3',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Lord's Table Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .sundayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "3",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .sundayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '2',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Lord's Table Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .sundayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "2",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            controller
                                                                .updateAttendeesSunTotalPercentage(
                                                                    'Present',
                                                                    'week'),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )),
                                                    ]),
                                                    DataRow(cells: [
                                                      DataCell(SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                            "Prayer Meeting",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14)),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .tuesdayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '1',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Prayer Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .tuesdayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "1",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .tuesdayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '4',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Prayer Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .tuesdayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "4",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .tuesdayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '3',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Prayer Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .tuesdayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "3",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .tuesdayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '2',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Prayer Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .tuesdayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "2",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            controller
                                                                .updateAttendeesTuesTotalPercentage(
                                                                    'Present',
                                                                    'week'),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )),
                                                    ]),
                                                    DataRow(cells: [
                                                      DataCell(SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                            "Group Meeting",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14)),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .fridayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '1',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Group Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .fridayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "1",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .fridayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '4',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Group Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .fridayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "4",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .fridayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '3',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Group Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .fridayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "3",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .fridayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '2',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Group Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .fridayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "2",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            controller
                                                                .updateAttendeesFriTotalPercentage(
                                                                    'Present',
                                                                    'week'),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )),
                                                    ]),
                                                    DataRow(cells: [
                                                      DataCell(SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                            "Home Meeting",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14)),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .homeMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .homeMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller.homeMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () => const AttendanceReport(),
                                                                  arguments: [
                                                                      '1',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Home Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .homeMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "1",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .homeMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .homeMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller.homeMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () => const AttendanceReport(),
                                                                  arguments: [
                                                                      '4',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Home Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .homeMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "4",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .homeMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .homeMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller.homeMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () => const AttendanceReport(),
                                                                  arguments: [
                                                                      '3',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Home Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .homeMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "3",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .homeMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .homeMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller.homeMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () => const AttendanceReport(),
                                                                  arguments: [
                                                                      '2',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Home Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .homeMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "2",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            controller
                                                                .updateAttendeesHomeTotalPercentage(
                                                                    'Present',
                                                                    'week'),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )),
                                                    ]),
                                                    DataRow(cells: [
                                                      DataCell(SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                            "Gospel Meeting",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14)),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .gospelMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '1',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Gospel Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .gospelMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "1",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .gospelMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '4',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Gospel Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .gospelMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "4",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .gospelMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '3',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Gospel Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .gospelMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "3",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .gospelMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '2',
                                                                      mDate
                                                                          .toString(),
                                                                      '1',
                                                                      "Gospel Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .gospelMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "2",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Present": "0"
                                                                              })[
                                                                      'Present']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            controller
                                                                .updateAttendeesGospelTotalPercentage(
                                                                    'Present',
                                                                    'week'),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )),
                                                    ]),
                                                  ],
                                                ),
                                                DataTable(
                                                  columnSpacing: 5,
                                                  horizontalMargin: 10,
                                                  dataRowMinHeight: 40,
                                                  dataRowMaxHeight: 60,
                                                  // showCheckboxColumn: true,
                                                  columns: [
                                                    DataColumn(
                                                        label: SizedBox(
                                                      width: 100,
                                                      child: Text('Meetings',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  "Inter-Medium",
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    )),
                                                    DataColumn(
                                                        label: Text('Agp',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    DataColumn(
                                                        label: Text('City',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    DataColumn(
                                                        label: Text('Akp',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    DataColumn(
                                                        label: Text('Gwk',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    DataColumn(
                                                        label: Text('Total (%)',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                  ],
                                                  rows: [
                                                    DataRow(cells: [
                                                      DataCell(SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                            "Lord's Table Meeting",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14)),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .sundayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '1',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Lord's Table Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .sundayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "1",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .sundayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '4',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Lord's Table Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .sundayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "4",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .sundayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '3',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Lord's Table Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .sundayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "3",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .sundayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .sundayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '2',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Lord's Table Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .sundayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "2",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            controller
                                                                .updateAttendeesSunTotalPercentage(
                                                                    'Absent',
                                                                    'week'),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )),
                                                    ]),
                                                    DataRow(cells: [
                                                      DataCell(SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                            "Prayer Meeting",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14)),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .tuesdayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '0',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Prayer Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .tuesdayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "1",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .tuesdayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '4',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Prayer Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .tuesdayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "4",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .tuesdayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '3',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Prayer Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .tuesdayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "3",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .tuesdayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .tuesdayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '2',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Prayer Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .tuesdayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "2",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            controller
                                                                .updateAttendeesTuesTotalPercentage(
                                                                    'Absent',
                                                                    'week'),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )),
                                                    ]),
                                                    DataRow(cells: [
                                                      DataCell(SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                            "Group Meeting",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14)),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .fridayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '1',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Group Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .fridayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "1",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .fridayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '4',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Group Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .fridayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "4",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .fridayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '3',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Group Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .fridayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "3",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .fridayMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .fridayMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '2',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Group Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .fridayMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "2",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            controller
                                                                .updateAttendeesFriTotalPercentage(
                                                                    'Absent',
                                                                    'week'),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )),
                                                    ]),
                                                    DataRow(cells: [
                                                      DataCell(SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                            "Home Meeting",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14)),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .homeMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .homeMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller.homeMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () => const AttendanceReport(),
                                                                  arguments: [
                                                                      '1',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Home Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .homeMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "1",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .homeMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .homeMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller.homeMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () => const AttendanceReport(),
                                                                  arguments: [
                                                                      '4',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Home Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .homeMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "4",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .homeMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .homeMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller.homeMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () => const AttendanceReport(),
                                                                  arguments: [
                                                                      '3',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Home Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .homeMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "3",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .homeMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .homeMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller.homeMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () => const AttendanceReport(),
                                                                  arguments: [
                                                                      '2',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Home Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .homeMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "2",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            controller
                                                                .updateAttendeesHomeTotalPercentage(
                                                                    'Absent',
                                                                    'week'),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )),
                                                    ]),
                                                    DataRow(cells: [
                                                      DataCell(SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                            "Gospel Meeting",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14)),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .gospelMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '1',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Gospel Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .gospelMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "1",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .gospelMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '4',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Gospel Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .gospelMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "4",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .gospelMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '3',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Gospel Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .gospelMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "3",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(GestureDetector(
                                                        onTap: () {
                                                          var mDate = controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? controller
                                                                  .gospelMeeting[
                                                                      0][
                                                                      'meetingDate']
                                                                  .toString()
                                                              : controller
                                                                  .meetingDate
                                                                  .toString();
                                                          controller
                                                                  .gospelMeeting
                                                                  .isNotEmpty
                                                              ? Get.to(
                                                                  () =>
                                                                      const AttendanceReport(),
                                                                  arguments: [
                                                                      '2',
                                                                      mDate
                                                                          .toString(),
                                                                      '0',
                                                                      "Gospel Meeting"
                                                                    ])
                                                              : Get.rawSnackbar(
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  message:
                                                                      'No attendance found in this meeting');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              controller
                                                                  .gospelMeeting
                                                                  .firstWhere(
                                                                      (sunday) =>
                                                                          sunday['districtID'].toString() ==
                                                                          "2",
                                                                      orElse:
                                                                          () =>
                                                                              {
                                                                                "Absent": "0"
                                                                              })[
                                                                      'Absent']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .green,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontFamily:
                                                                      "Inter-Medium",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      )),
                                                      DataCell(Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            controller
                                                                .updateAttendeesGospelTotalPercentage(
                                                                    'Absent',
                                                                    'week'),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontFamily:
                                                                    "Inter-Medium",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )),
                                                    ]),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              // padding: EdgeInsets.all(5),
                              // height: MediaQuery.of(context).size.height * 0.42,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.purpleAccent,
                                        blurRadius: 5,
                                        spreadRadius: 2),
                                  ]),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Text(
                                        "Children Lords table meeting attendance",
                                        style: TextStyle(
                                            color: Colors.deepPurpleAccent,
                                            fontFamily: "Inter-Medium",
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  DataTable(
                                    columnSpacing: 10,
                                    horizontalMargin: 10,
                                    dataRowMinHeight: 40,
                                    dataRowMaxHeight: 50,
                                    // showCheckboxColumn: true,
                                    columns: [
                                      DataColumn(
                                          label: SizedBox(
                                        width: 100,
                                        child: Text('Attendance',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Inter-Medium",
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                      DataColumn(
                                          label: Text('AGP',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('CITY',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('AKP',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('GWK',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Total',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],
                                    rows: [
                                      DataRow(cells: [
                                        DataCell(SizedBox(
                                          width: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Present",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "Inter-Medium",
                                                    fontSize: 16)),
                                          ),
                                        )),
                                        DataCell(Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              controller.sundayMeeting
                                                  .firstWhere(
                                                      (sunday) =>
                                                          sunday['districtID']
                                                              .toString() ==
                                                          "1",
                                                      orElse: () => {
                                                            "childPresent": "0"
                                                          })['childPresent']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                        DataCell(Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              controller.sundayMeeting
                                                  .firstWhere(
                                                      (sunday) =>
                                                          sunday['districtID']
                                                              .toString() ==
                                                          "4",
                                                      orElse: () => {
                                                            "childPresent": "0"
                                                          })['childPresent']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                        DataCell(Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              controller.sundayMeeting
                                                  .firstWhere(
                                                      (sunday) =>
                                                          sunday['districtID']
                                                              .toString() ==
                                                          "3",
                                                      orElse: () => {
                                                            "childPresent": "0"
                                                          })['childPresent']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                        DataCell(Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              controller.sundayMeeting
                                                  .firstWhere(
                                                      (sunday) =>
                                                          sunday['districtID']
                                                              .toString() ==
                                                          "2",
                                                      orElse: () => {
                                                            "childPresent": "0"
                                                          })['childPresent']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                        DataCell(GestureDetector(
                                          onTap: () {
                                            Get.to(() => const Saints(),
                                                arguments: {
                                                  "id": 0,
                                                  "name": "",
                                                  "email": "",
                                                  "mobile": "",
                                                  "dob": "",
                                                  "age": "",
                                                  "gender": "",
                                                  "district": "0",
                                                  "saintType": "4",
                                                  "user_name": ""
                                                });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                controller
                                                    .updateChildTotal(
                                                        'childPresent')
                                                    .toString(),
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        Colors.green,
                                                    color: Colors.blueAccent,
                                                    fontFamily: "Inter-Medium",
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        )),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(SizedBox(
                                          width: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Absent",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "Inter-Medium",
                                                    fontSize: 16)),
                                          ),
                                        )),
                                        DataCell(Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              controller.sundayMeeting
                                                  .firstWhere(
                                                      (sunday) =>
                                                          sunday['districtID']
                                                              .toString() ==
                                                          "1",
                                                      orElse: () => {
                                                            "childAbsent": "0"
                                                          })['childAbsent']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                        DataCell(Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              controller.sundayMeeting
                                                  .firstWhere(
                                                      (sunday) =>
                                                          sunday['districtID']
                                                              .toString() ==
                                                          "4",
                                                      orElse: () => {
                                                            "childAbsent": "0"
                                                          })['childAbsent']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                        DataCell(Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              controller.sundayMeeting
                                                  .firstWhere(
                                                      (sunday) =>
                                                          sunday['districtID']
                                                              .toString() ==
                                                          "3",
                                                      orElse: () => {
                                                            "childAbsent": "0"
                                                          })['childAbsent']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                        DataCell(Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              controller.sundayMeeting
                                                  .firstWhere(
                                                      (sunday) =>
                                                          sunday['districtID']
                                                              .toString() ==
                                                          "2",
                                                      orElse: () => {
                                                            "childAbsent": "0"
                                                          })['childAbsent']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                        DataCell(GestureDetector(
                                          onTap: () {
                                            Get.to(() => const Saints(),
                                                arguments: {
                                                  "id": 0,
                                                  "name": "",
                                                  "email": "",
                                                  "mobile": "",
                                                  "dob": "",
                                                  "age": "",
                                                  "gender": "",
                                                  "district": "0",
                                                  "saintType": "4",
                                                  "user_name": ""
                                                });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                controller
                                                    .updateChildTotal(
                                                        'childAbsent')
                                                    .toString(),
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        Colors.green,
                                                    color: Colors.blueAccent,
                                                    fontFamily: "Inter-Medium",
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        )),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              // padding: EdgeInsets.all(5),
                              // height: MediaQuery.of(context).size.height * 0.42,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.blue,
                                        blurRadius: 5,
                                        spreadRadius: 2),
                                  ]),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Text("Area wise saints",
                                        style: TextStyle(
                                            color: Colors.deepPurpleAccent,
                                            fontFamily: "Inter-Medium",
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  DataTable(
                                    columnSpacing: 20,
                                    horizontalMargin: 10,
                                    dataRowMinHeight: 40,
                                    dataRowMaxHeight: 60,
                                    columns: controller.buildColumns(),
                                    rows: controller.buildRows(),
                                  ),
                                ],
                              ),
                            ),
                            // Container(
                            //   margin: EdgeInsets.all(10),
                            //   // padding: EdgeInsets.all(5),
                            //   // height: MediaQuery.of(context).size.height * 0.42,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(8),
                            //       color: Colors.white,
                            //       boxShadow: [
                            //         BoxShadow(
                            //             color: Colors.purpleAccent,
                            //             blurRadius: 5,
                            //             spreadRadius: 2),
                            //       ]),
                            //   child: Column(
                            //     children: [
                            //       SizedBox(
                            //         height: 10,
                            //       ),
                            //       Center(
                            //         child: Text("Category wise saints",
                            //             style: TextStyle(
                            //                 color: Colors.deepPurpleAccent,
                            //                 fontFamily: "Inter-Medium",
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.bold)),
                            //       ),
                            //       SizedBox(
                            //         height: 2,
                            //       ),
                            //       DataTable(
                            //         columnSpacing: 10,
                            //         horizontalMargin: 10,
                            //         dataRowMinHeight: 40,
                            //         dataRowMaxHeight: 60,
                            //         // showCheckboxColumn: true,
                            //         columns: [
                            //           DataColumn(
                            //               label: SizedBox(
                            //             width: 100,
                            //             child: Text('Category',
                            //                 overflow: TextOverflow.ellipsis,
                            //                 maxLines: 2,
                            //                 style: TextStyle(
                            //                     color: Colors.black,
                            //                     fontFamily: "Inter-Medium",
                            //                     fontSize: 16,
                            //                     fontWeight: FontWeight.bold)),
                            //           )),
                            //           DataColumn(
                            //               label: Text('AGP',
                            //                   style: TextStyle(
                            //                       color: Colors.black,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 14,
                            //                       fontWeight:
                            //                           FontWeight.bold))),
                            //           DataColumn(
                            //               label: Text('CITY',
                            //                   style: TextStyle(
                            //                       color: Colors.black,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 14,
                            //                       fontWeight:
                            //                           FontWeight.bold))),
                            //           DataColumn(
                            //               label: Text('AKP',
                            //                   style: TextStyle(
                            //                       color: Colors.black,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 14,
                            //                       fontWeight:
                            //                           FontWeight.bold))),
                            //           DataColumn(
                            //               label: Text('GWK',
                            //                   style: TextStyle(
                            //                       color: Colors.black,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 14,
                            //                       fontWeight:
                            //                           FontWeight.bold))),
                            //           DataColumn(
                            //               label: Text('Total',
                            //                   style: TextStyle(
                            //                       color: Colors.black,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 14,
                            //                       fontWeight:
                            //                           FontWeight.bold))),
                            //         ],
                            //         rows: [
                            //           DataRow(cells: [
                            //             DataCell(SizedBox(
                            //               width: 100,
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(8.0),
                            //                 child: Text("General Saints",
                            //                     maxLines: 2,
                            //                     overflow: TextOverflow.ellipsis,
                            //                     style: TextStyle(
                            //                         color: Colors.black,
                            //                         fontFamily: "Inter-Medium",
                            //                         fontSize: 16)),
                            //               ),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.generalSaints
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "1",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.generalSaints
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "4",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.generalSaints
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "3",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.generalSaints
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "2",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(GestureDetector(
                            //               onTap: () {
                            //                 Get.to(() => const Saints(),
                            //                     arguments: {
                            //                       "id": 0,
                            //                       "name": "",
                            //                       "email": "",
                            //                       "mobile": "",
                            //                       "dob": "",
                            //                       "age": "",
                            //                       "gender": "",
                            //                       "district": "0",
                            //                       "saintType": "1",
                            //                       "user_name": ""
                            //                     });
                            //               },
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(8.0),
                            //                 child: Text(
                            //                     controller.generalSaints
                            //                         .fold<int>(
                            //                             0,
                            //                             (sum, gen) =>
                            //                                 sum +
                            //                                 int.parse(gen[
                            //                                         'count']
                            //                                     .toString()))
                            //                         .toString(),
                            //                     style: TextStyle(
                            //                         decoration: TextDecoration
                            //                             .underline,
                            //                         decorationColor:
                            //                             Colors.green,
                            //                         color: Colors.blueAccent,
                            //                         fontFamily: "Inter-Medium",
                            //                         fontSize: 16,
                            //                         fontWeight:
                            //                             FontWeight.bold)),
                            //               ),
                            //             )),
                            //           ]),
                            //           DataRow(cells: [
                            //             DataCell(SizedBox(
                            //               width: 100,
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(8.0),
                            //                 child: Text("Young Working Saints",
                            //                     maxLines: 2,
                            //                     overflow: TextOverflow.ellipsis,
                            //                     style: TextStyle(
                            //                         color: Colors.black,
                            //                         fontFamily: "Inter-Medium",
                            //                         fontSize: 16)),
                            //               ),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.workingSaints
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "1",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.workingSaints
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "4",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.workingSaints
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "3",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.workingSaints
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "2",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(GestureDetector(
                            //               onTap: () {
                            //                 Get.to(() => const Saints(),
                            //                     arguments: {
                            //                       "id": 0,
                            //                       "name": "",
                            //                       "email": "",
                            //                       "mobile": "",
                            //                       "dob": "",
                            //                       "age": "",
                            //                       "gender": "",
                            //                       "district": "0",
                            //                       "saintType": "2",
                            //                       "user_name": ""
                            //                     });
                            //               },
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(8.0),
                            //                 child: Text(
                            //                     controller.workingSaints
                            //                         .fold<int>(
                            //                             0,
                            //                             (sum, gen) =>
                            //                                 sum +
                            //                                 int.parse(gen[
                            //                                         'count']
                            //                                     .toString()))
                            //                         .toString(),
                            //                     style: TextStyle(
                            //                         decoration: TextDecoration
                            //                             .underline,
                            //                         decorationColor:
                            //                             Colors.green,
                            //                         color: Colors.blueAccent,
                            //                         fontFamily: "Inter-Medium",
                            //                         fontSize: 16,
                            //                         fontWeight:
                            //                             FontWeight.bold)),
                            //               ),
                            //             )),
                            //           ]),
                            //           DataRow(cells: [
                            //             DataCell(SizedBox(
                            //               width: 100,
                            //               child: Text("Collage Students",
                            //                   maxLines: 2,
                            //                   overflow: TextOverflow.ellipsis,
                            //                   style: TextStyle(
                            //                       color: Colors.black,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.youngOne
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "1",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.youngOne
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "4",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.youngOne
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "3",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.youngOne
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "2",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(GestureDetector(
                            //               onTap: () {
                            //                 Get.to(() => const Saints(),
                            //                     arguments: {
                            //                       "id": 0,
                            //                       "name": "",
                            //                       "email": "",
                            //                       "mobile": "",
                            //                       "dob": "",
                            //                       "age": "",
                            //                       "gender": "",
                            //                       "district": "0",
                            //                       "saintType": "3",
                            //                       "user_name": ""
                            //                     });
                            //               },
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(8.0),
                            //                 child: Text(
                            //                     controller.youngOne
                            //                         .fold<int>(
                            //                             0,
                            //                             (sum, gen) =>
                            //                                 sum +
                            //                                 int.parse(gen[
                            //                                         'count']
                            //                                     .toString()))
                            //                         .toString(),
                            //                     style: TextStyle(
                            //                         decoration: TextDecoration
                            //                             .underline,
                            //                         decorationColor:
                            //                             Colors.green,
                            //                         color: Colors.blueAccent,
                            //                         fontFamily: "Inter-Medium",
                            //                         fontSize: 16,
                            //                         fontWeight:
                            //                             FontWeight.bold)),
                            //               ),
                            //             )),
                            //           ]),
                            //           DataRow(cells: [
                            //             DataCell(SizedBox(
                            //               width: 100,
                            //               child: Text("Teenagers",
                            //                   maxLines: 2,
                            //                   overflow: TextOverflow.ellipsis,
                            //                   style: TextStyle(
                            //                       color: Colors.black,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.teenagers
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "1",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.teenagers
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "4",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.teenagers
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "3",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.teenagers
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "2",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(GestureDetector(
                            //               onTap: () {
                            //                 Get.to(() => const Saints(),
                            //                     arguments: {
                            //                       "id": 0,
                            //                       "name": "",
                            //                       "email": "",
                            //                       "mobile": "",
                            //                       "dob": "",
                            //                       "age": "",
                            //                       "gender": "",
                            //                       "district": "0",
                            //                       "saintType": "6",
                            //                       "user_name": ""
                            //                     });
                            //               },
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(8.0),
                            //                 child: Text(
                            //                     controller.teenagers
                            //                         .fold<int>(
                            //                             0,
                            //                             (sum, gen) =>
                            //                                 sum +
                            //                                 int.parse(gen[
                            //                                         'count']
                            //                                     .toString()))
                            //                         .toString(),
                            //                     style: TextStyle(
                            //                         decoration: TextDecoration
                            //                             .underline,
                            //                         decorationColor:
                            //                             Colors.green,
                            //                         color: Colors.blueAccent,
                            //                         fontFamily: "Inter-Medium",
                            //                         fontSize: 16,
                            //                         fontWeight:
                            //                             FontWeight.bold)),
                            //               ),
                            //             )),
                            //           ]),
                            //           DataRow(cells: [
                            //             DataCell(SizedBox(
                            //               width: 100,
                            //               child: Text("Children",
                            //                   maxLines: 2,
                            //                   overflow: TextOverflow.ellipsis,
                            //                   style: TextStyle(
                            //                       color: Colors.black,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.children
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "1",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.children
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "4",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.children
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "3",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.children
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "2",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(GestureDetector(
                            //               onTap: () {
                            //                 Get.to(() => const Saints(),
                            //                     arguments: {
                            //                       "id": 0,
                            //                       "name": "",
                            //                       "email": "",
                            //                       "mobile": "",
                            //                       "dob": "",
                            //                       "age": "",
                            //                       "gender": "",
                            //                       "district": "0",
                            //                       "saintType": "4",
                            //                       "user_name": ""
                            //                     });
                            //               },
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(8.0),
                            //                 child: Text(
                            //                     controller.children
                            //                         .fold<int>(
                            //                             0,
                            //                             (sum, gen) =>
                            //                                 sum +
                            //                                 int.parse(gen[
                            //                                         'count']
                            //                                     .toString()))
                            //                         .toString(),
                            //                     style: TextStyle(
                            //                         decoration: TextDecoration
                            //                             .underline,
                            //                         decorationColor:
                            //                             Colors.green,
                            //                         color: Colors.blueAccent,
                            //                         fontFamily: "Inter-Medium",
                            //                         fontSize: 16,
                            //                         fontWeight:
                            //                             FontWeight.bold)),
                            //               ),
                            //             )),
                            //           ]),
                            //           DataRow(cells: [
                            //             DataCell(SizedBox(
                            //               width: 100,
                            //               child: Text("Dormant Saints",
                            //                   maxLines: 2,
                            //                   overflow: TextOverflow.ellipsis,
                            //                   style: TextStyle(
                            //                       color: Colors.black,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.dormantSaints
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "1",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.dormantSaints
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "4",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.dormantSaints
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "3",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                   controller.dormantSaints
                            //                       .firstWhere(
                            //                           (sunday) =>
                            //                               sunday['districtID']
                            //                                   .toString() ==
                            //                               "2",
                            //                           orElse: () => {
                            //                                 "count": "0"
                            //                               })['count']
                            //                       .toString(),
                            //                   style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontFamily: "Inter-Medium",
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //             )),
                            //             DataCell(GestureDetector(
                            //               onTap: () {
                            //                 Get.to(() => const Saints(),
                            //                     arguments: {
                            //                       "id": 0,
                            //                       "name": "",
                            //                       "email": "",
                            //                       "mobile": "",
                            //                       "dob": "",
                            //                       "age": "",
                            //                       "gender": "",
                            //                       "district": "0",
                            //                       "saintType": "5",
                            //                       "user_name": ""
                            //                     });
                            //               },
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(8.0),
                            //                 child: Text(
                            //                     controller.dormantSaints
                            //                         .fold<int>(
                            //                             0,
                            //                             (sum, gen) =>
                            //                                 sum +
                            //                                 int.parse(gen[
                            //                                         'count']
                            //                                     .toString()))
                            //                         .toString(),
                            //                     style: TextStyle(
                            //                         decoration: TextDecoration
                            //                             .underline,
                            //                         decorationColor:
                            //                             Colors.green,
                            //                         color: Colors.blueAccent,
                            //                         fontFamily: "Inter-Medium",
                            //                         fontSize: 16,
                            //                         fontWeight:
                            //                             FontWeight.bold)),
                            //               ),
                            //             )),
                            //           ]),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Container(
                              margin: EdgeInsets.all(10),
                              // padding: EdgeInsets.all(5),
                              // height: MediaQuery.of(context).size.height * 0.42,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.purpleAccent,
                                        blurRadius: 5,
                                        spreadRadius: 2),
                                  ]),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Text("Category wise saints",
                                        style: TextStyle(
                                            color: Colors.deepPurpleAccent,
                                            fontFamily: "Inter-Medium",
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columnSpacing: 16,
                                      horizontalMargin: 12,
                                      dataRowMinHeight: 45,
                                      dataRowMaxHeight: 60,

                                      // -------------------------------
                                      // Columns
                                      // -------------------------------
                                      columns: [
                                        const DataColumn(
                                          label: Text(
                                            'Category',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ...controller.cwDistricts.map(
                                          (d) => DataColumn(
                                            label: Text(
                                              d,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            'Total',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],

                                      // -------------------------------
                                      // Rows
                                      // -------------------------------

                                      rows: controller.categories.map((category) {
                                        int rowTotal = 0;

                                        return DataRow(
                                          cells: [
                                            // Category Name
                                            DataCell(
                                              SizedBox(
                                                width: 140,
                                                child: Text(
                                                  category,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style:
                                                      const TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ),

                                            // District-wise values
                                            ...controller.cwDistricts
                                                .map((district) {
                                              int count =
                                                  controller.getCategoryCount(
                                                      district, category);
                                              rowTotal += count;

                                              return DataCell(
                                                Text(
                                                  count.toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              );
                                            }),

                                            // Total Column (Clickable)
                                            DataCell(
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                    () => const Saints(),
                                                    arguments: {
                                                      "category": category,
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  rowTotal.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.blueAccent,
                                                    decoration:
                                                        TextDecoration.underline,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ));
  }
}
