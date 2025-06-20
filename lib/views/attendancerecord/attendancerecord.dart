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
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "${controller.districtName} Attendance Sheet (${controller.weekDates[0]} to ${controller.weekDates[6]})",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    // width: MediaQuery.of(context).size.width * 1,
                    // height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)),
                    child: TextFormField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: "Search by name, district",
                        hintStyle: TextStyle(fontSize: 14),
                        contentPadding: EdgeInsets.only(bottom: 10, left: 10),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        suffixIcon: controller.searchController.text.isEmpty
                            ? Icon(
                                Icons.search_outlined,
                                color: Colors.grey,
                              )
                            : GestureDetector(
                                onTap: () {
                                  controller.loadSaints();
                                  controller.searchController
                                      .clear(); // Clear the text
                                  controller.update(); // Update the UI
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                      ),
                      onChanged: (value) {
                        controller.handleSearch(value);
                      },
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        physics: ScrollPhysics(),
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
                                final attendanceSheet =
                                    controller.saints[index]['attendanceSheet'];
                                log("Sheet $attendanceSheet");
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
                                      child:
                                          Text("", textAlign: TextAlign.center),
                                    ),
                                    Column(
                                      children: [
                                        Checkbox(
                                          value: (attendanceSheet != null &&
                                                  attendanceSheet is Map &&
                                                  attendanceSheet
                                                      .containsKey('1') &&
                                                  attendanceSheet['1']
                                                          .toString() ==
                                                      '1')
                                              ? true
                                              : false,
                                          onChanged: (bool? value) {
                                            controller.isFruitBearing[index] =
                                                value!;
                                            controller.handleSaintAttendance(
                                                person['id'],
                                                value,
                                                1,
                                                'Going out for fruit bearing',
                                                person['saintTypeId']);
                                            controller.update();
                                          },
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            "Going out for fruit bearing",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Checkbox(
                                          value: (attendanceSheet != null &&
                                                  attendanceSheet is Map &&
                                                  attendanceSheet
                                                      .containsKey('2') &&
                                                  attendanceSheet['2']
                                                          .toString() ==
                                                      '1')
                                              ? true
                                              : false,
                                          onChanged: (bool? value) {
                                            controller.isFruitBearing[index] =
                                                value!;
                                            controller.handleSaintAttendance(
                                                person['id'],
                                                value,
                                                2,
                                                "Going out for shepherding",
                                                person['saintTypeId']);
                                            controller.update();
                                          },
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            "Going out for shepherding",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Checkbox(
                                          value: (attendanceSheet != null &&
                                                  attendanceSheet is Map &&
                                                  attendanceSheet
                                                      .containsKey('3') &&
                                                  attendanceSheet['3']
                                                          .toString() ==
                                                      '1')
                                              ? true
                                              : false,
                                          onChanged: (bool? value) {
                                            controller.isHomeMeeting[index] =
                                                value!;
                                            controller.handleSaintAttendance(
                                                person['id'],
                                                value,
                                                3,
                                                "Joined Home Meeting (Sheep)",
                                                person['saintTypeId']);
                                            print(controller
                                                .isHomeMeeting[index]);
                                            controller.update();
                                          },
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            "Joined Home Meeting (Sheep)",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Checkbox(
                                          value: (attendanceSheet != null &&
                                                  attendanceSheet is Map &&
                                                  attendanceSheet
                                                      .containsKey('4') &&
                                                  attendanceSheet['4']
                                                          .toString() ==
                                                      '1')
                                              ? true
                                              : false,
                                          onChanged: (bool? value) {
                                            controller.isGroupMeetig[index] =
                                                value!;
                                            controller.handleSaintAttendance(
                                                person['id'],
                                                value,
                                                4,
                                                "Small Group Meeting",
                                                person['saintTypeId']);
                                            print(controller
                                                .isGroupMeetig[index]);
                                            controller.update();
                                          },
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            "Small Group Meeting",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Checkbox(
                                          value: (attendanceSheet != null &&
                                                  attendanceSheet is Map &&
                                                  attendanceSheet
                                                      .containsKey('5') &&
                                                  attendanceSheet['5']
                                                          .toString() ==
                                                      '1')
                                              ? true
                                              : false,
                                          onChanged: (bool? value) {
                                            controller.isM1[index] = value!;
                                            controller.handleSaintAttendance(
                                                person['id'],
                                                value,
                                                5,
                                                "Life Study M1",
                                                person['saintTypeId']);
                                            print(controller.isM1[index]);
                                            controller.update();
                                          },
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            "Life Study M1",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Checkbox(
                                          value: (attendanceSheet != null &&
                                                  attendanceSheet is Map &&
                                                  attendanceSheet
                                                      .containsKey('6') &&
                                                  attendanceSheet['6']
                                                          .toString() ==
                                                      '1')
                                              ? true
                                              : false,
                                          onChanged: (bool? value) {
                                            controller.isM2[index] = value!;
                                            controller.handleSaintAttendance(
                                                person['id'],
                                                value,
                                                6,
                                                "Life Study M2",
                                                person['saintTypeId']);
                                            print(controller.isM2[index]);
                                            controller.update();
                                          },
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            "Life Study M2",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Checkbox(
                                          value: (attendanceSheet != null &&
                                                  attendanceSheet is Map &&
                                                  attendanceSheet
                                                      .containsKey('7') &&
                                                  attendanceSheet['7']
                                                          .toString() ==
                                                      '1')
                                              ? true
                                              : false,
                                          onChanged: (bool? value) {
                                            controller.isPrayerMeeting[index] =
                                                value!;
                                            controller.handleSaintAttendance(
                                                person['id'],
                                                value,
                                                7,
                                                "Prayer Meeting",
                                                person['saintTypeId']);
                                            print(controller
                                                .isPrayerMeeting[index]);
                                            controller.update();
                                          },
                                        ),
                                        SizedBox(
                                            width: 60,
                                            child: Text(
                                              "Prayer Meeting",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 8),
                                            ))
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Checkbox(
                                          value: (attendanceSheet != null &&
                                                  attendanceSheet is Map &&
                                                  attendanceSheet
                                                      .containsKey('8') &&
                                                  attendanceSheet['8']
                                                          .toString() ==
                                                      '1')
                                              ? true
                                              : false,
                                          onChanged: (bool? value) {
                                            controller.isTableMeeting[index] =
                                                value!;
                                            controller.handleSaintAttendance(
                                                person['id'],
                                                value,
                                                8,
                                                "Lords Table Meeting",
                                                person['saintTypeId']);
                                            print(controller
                                                .isTableMeeting[index]);
                                            controller.update();
                                          },
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            "Lords Table Meeting",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              }),
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
