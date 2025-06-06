import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/attendancerecord/attendancerecordcontroller.dart';

class AttendanceRecord extends StatefulWidget {
  const AttendanceRecord({super.key});

  @override
  State<AttendanceRecord> createState() => _AttendanceRecordState();
}

class _AttendanceRecordState extends State<AttendanceRecord>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceRecordController>(
      init: AttendanceRecordController(),
      builder: (controller) => Scaffold(
        body: controller.isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.purple,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Please wait...',
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: DefaultTabController(
                        length: 4,
                        child: Column(
                          children: [
                            TabBar(
                                onTap: (index) {
                                  controller.updateAttendanceSheet(index);
                                },
                                tabs: [
                                  Tab(text: 'AGP'),
                                  Tab(text: 'GWK'),
                                  Tab(text: 'CITY'),
                                  Tab(text: 'AKP'),
                                ]),
                          ],
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "${controller.districtName} Attendance Sheet (${controller.weekDates[0]} to ${controller.weekDates[6]})",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Table(
                            border: TableBorder.all(color: Colors.black),
                            defaultColumnWidth: const FixedColumnWidth(80),
                            children: [
                              // Header row
                              TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.amber[100]),
                                children: controller.headers.map((header) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      header,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }).toList(),
                              ),

                              // Data rows
                              ...List.generate(controller.saints.length,
                                  (index) {
                                final person = controller.saints[index];
                                final isEven = index % 2 == 0;
                                return TableRow(
                                  decoration: BoxDecoration(
                                    color: isEven
                                        ? Colors.grey[200]
                                        : Colors.white,
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("${index + 1}",
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(person['name'],
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(person['saintType'],
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("--",
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("--",
                                          textAlign: TextAlign.center),
                                    ),

                                    Checkbox(
                                      value: controller.isFruitBearing[index] ??
                                          false,
                                      onChanged: (bool? value) {
                                        controller.isFruitBearing[index] =
                                            value!;
                                        controller.handleSaintAttendance(
                                            person['id'],
                                            value,
                                            1,
                                            'Going out for fruit bearing');
                                        print(controller.isFruitBearing[index]);
                                        controller.update();
                                      },
                                    ),

                                    Checkbox(
                                      value: controller.isShepherding[index] ??
                                          false,
                                      onChanged: (bool? value) {
                                        controller.isShepherding[index] =
                                            value!;
                                        controller.handleSaintAttendance(
                                            person['id'],
                                            value,
                                            2,
                                            "Going out for shepherding");
                                        print(controller.isShepherding[index]);
                                        controller.update();
                                      },
                                    ),

                                    Checkbox(
                                      value: controller.isHomeMeeting[index] ??
                                          false,
                                      onChanged: (bool? value) {
                                        controller.isHomeMeeting[index] =
                                            value!;
                                        print(controller.isHomeMeeting[index]);
                                        controller.update();
                                      },
                                    ),

                                    Checkbox(
                                      value: controller.isGroupMeetig[index] ??
                                          false,
                                      onChanged: (bool? value) {
                                        controller.isGroupMeetig[index] =
                                            value!;
                                        print(controller.isGroupMeetig[index]);
                                        controller.update();
                                      },
                                    ),

                                    Checkbox(
                                      value: controller.isM1[index] ?? false,
                                      onChanged: (bool? value) {
                                        controller.isM1[index] = value!;
                                        print(controller.isM1[index]);
                                        controller.update();
                                      },
                                    ),

                                    Checkbox(
                                      value: controller.isM2[index] ?? false,
                                      onChanged: (bool? value) {
                                        controller.isM2[index] = value!;
                                        print(controller.isM2[index]);
                                        controller.update();
                                      },
                                    ),

                                    Checkbox(
                                      value:
                                          controller.isPrayerMeeting[index] ??
                                              false,
                                      onChanged: (bool? value) {
                                        controller.isPrayerMeeting[index] =
                                            value!;
                                        print(
                                            controller.isPrayerMeeting[index]);
                                        controller.update();
                                      },
                                    ),

                                    Checkbox(
                                      value: controller.isTableMeeting[index] ??
                                          false,
                                      onChanged: (bool? value) {
                                        controller.isTableMeeting[index] =
                                            value!;
                                        print(controller.isTableMeeting[index]);
                                        controller.update();
                                      },
                                    ),

                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child:
                                    //       Text(person['gender'], textAlign: TextAlign.center),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(person['district'],
                                    //       textAlign: TextAlign.center),
                                    // ),
                                    // for (int i = 0; i < 3; i++)
                                    //   Center(
                                    //     child: Checkbox(
                                    //       value: controller.checkboxes[row][i],
                                    //       onChanged: (value) {
                                    //         controller.checkboxes[row][i] = value!;
                                    //         controller.update();
                                    //       },
                                    //     ),
                                    //   ),
                                  ],
                                );
                              }),

                              // Totals Row
                              // TableRow(
                              //   decoration: BoxDecoration(color: Colors.lightBlue[100]),
                              //   children: List.generate(controller.headers.length, (col) {
                              //     if (col < controller.checkboxStartIndex) {
                              //       return const SizedBox();
                              //     }
                              //     int total = controller.checkboxes.fold(
                              //       0,
                              //       (sum, row) =>
                              //           sum +
                              //           (row[col - controller.checkboxStartIndex] ? 1 : 0),
                              //     );
                              //     return Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: Center(
                              //         child: Text(
                              //           '$total',
                              //           style: const TextStyle(fontWeight: FontWeight.bold),
                              //         ),
                              //       ),
                              //     );
                              //   }),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
