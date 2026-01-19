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
                            SingleChildScrollView(
                              physics: ScrollPhysics(),
                              child: Container(
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
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    physics: ScrollPhysics(),
                                                    child: SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      physics: ScrollPhysics(),
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
                                                              'Meetings',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          ...controller
                                                              .meetingTypeDistricts
                                                              .map(
                                                            (d) => DataColumn(
                                                              label: Text(
                                                                d,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          const DataColumn(
                                                            label: Text(
                                                              'Total',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],

                                                        // -------------------------------
                                                        // Rows
                                                        // -------------------------------

                                                        rows: controller
                                                            .meetingTypes
                                                            .map((meetingType) {
                                                          int rowTotal = 0;

                                                          return DataRow(
                                                            cells: [
                                                              // Category Name
                                                              DataCell(
                                                                SizedBox(
                                                                  width: 140,
                                                                  child: Text(
                                                                    meetingType,
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                              ),

                                                              // District-wise values
                                                              ...controller
                                                                  .meetingTypeDistricts
                                                                  .map(
                                                                      (district) {
                                                                int count = controller
                                                                    .getMeetingAttendanceCount(
                                                                        district,
                                                                        meetingType);
                                                                rowTotal += count;

                                                                return DataCell(
                                                                  Text(
                                                                    count
                                                                        .toString(),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                  ),
                                                                );
                                                              }),

                                                              // Total Column (Clickable)
                                                              DataCell(
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Get.to(
                                                                      () =>
                                                                          const Saints(),
                                                                      arguments: {
                                                                        "category":
                                                                            meetingType,
                                                                      },
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    rowTotal
                                                                        .toString(),
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .blueAccent,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                    Axis.vertical,
                                                    child: SingleChildScrollView(
                                                      scrollDirection:
                                                      Axis.horizontal,
                                                      physics: ScrollPhysics(),
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
                                                              'Meetings',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                          ),
                                                          ...controller
                                                              .meetingTypeDistricts
                                                              .map(
                                                                (d) => DataColumn(
                                                              label: Text(
                                                                d,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          const DataColumn(
                                                            label: Text(
                                                              'Total',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                          ),
                                                        ],

                                                        // -------------------------------
                                                        // Rows
                                                        // -------------------------------

                                                        rows: controller
                                                            .meetingTypes
                                                            .map((meetingType) {
                                                          int rowTotal = 0;

                                                          return DataRow(
                                                            cells: [
                                                              // Category Name
                                                              DataCell(
                                                                SizedBox(
                                                                  width: 140,
                                                                  child: Text(
                                                                    meetingType,
                                                                    maxLines: 2,
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                        14),
                                                                  ),
                                                                ),
                                                              ),

                                                              // District-wise values
                                                              ...controller
                                                                  .meetingTypeDistricts
                                                                  .map(
                                                                      (district) {
                                                                    int count = controller
                                                                        .getMeetingAbsentCount(
                                                                        district,
                                                                        meetingType);
                                                                    rowTotal += count;

                                                                    return DataCell(
                                                                      Text(
                                                                        count
                                                                            .toString(),
                                                                        style:
                                                                        const TextStyle(
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .black54,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }),

                                                              // Total Column (Clickable)
                                                              DataCell(
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Get.to(
                                                                          () =>
                                                                      const Saints(),
                                                                      arguments: {
                                                                        "category":
                                                                        meetingType,
                                                                      },
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    rowTotal
                                                                        .toString(),
                                                                    style:
                                                                    const TextStyle(
                                                                      color: Colors
                                                                          .blueAccent,
                                                                      decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
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

                                      rows:
                                          controller.categories.map((category) {
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 14),
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
                                                    decoration: TextDecoration
                                                        .underline,
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
