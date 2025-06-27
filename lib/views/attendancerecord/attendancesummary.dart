import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/attendancerecord/attendancesummarycontroller.dart';

class AttendanceSummary extends StatefulWidget {
  const AttendanceSummary({super.key});

  @override
  State<AttendanceSummary> createState() => _AttendanceSummaryState();
}

class _AttendanceSummaryState extends State<AttendanceSummary> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceSummaryController>(
        init: AttendanceSummaryController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                title: Text(
                  "Attendance Monthly Summary",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xFF2c2cff),
                // centerTitle: true,
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
              body: Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "${controller.monthName.toString()} Month Attendance Summary",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          border: TableBorder.all(color: Colors.black),
                          defaultColumnWidth: const FixedColumnWidth(80),
                          children: [
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
                            ...List.generate(controller.districts.length,
                                (index) {
                              final district = controller.districts[index];

                              final isEven = index % 2 == 0;
                              return TableRow(
                                decoration: BoxDecoration(
                                  color:
                                      isEven ? Colors.grey[200] : Colors.white,
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        district['short_text'].toString(),
                                        textAlign: TextAlign.center),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FutureBuilder(
                                      future:
                                          controller.getMeetingDataByDistrict(
                                              district['config_id'], 1),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text("Error");
                                        } else {
                                          return Text(
                                            snapshot.data.toString(),
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FutureBuilder(
                                      future:
                                          controller.getMeetingDataByDistrict(
                                              district['config_id'], 2),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text("Error");
                                        } else {
                                          return Text(
                                            snapshot.data.toString(),
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FutureBuilder(
                                      future:
                                          controller.getMeetingDataByDistrict(
                                              district['config_id'], 3),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text("Error");
                                        } else {
                                          return Text(
                                            snapshot.data.toString(),
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FutureBuilder(
                                      future:
                                          controller.getMeetingDataByDistrict(
                                              district['config_id'], 4),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text("Error");
                                        } else {
                                          return Text(
                                            snapshot.data.toString(),
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FutureBuilder(
                                      future:
                                          controller.getMeetingDataByDistrict(
                                              district['config_id'], 5),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text("Error");
                                        } else {
                                          return Text(
                                            snapshot.data.toString(),
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FutureBuilder(
                                      future:
                                          controller.getMeetingDataByDistrict(
                                              district['config_id'], 6),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text("Error");
                                        } else {
                                          return Text(
                                            snapshot.data.toString(),
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FutureBuilder(
                                      future:
                                          controller.getMeetingDataByDistrict(
                                              district['config_id'], 7),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text("Error");
                                        } else {
                                          return Text(
                                            snapshot.data.toString(),
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FutureBuilder(
                                      future:
                                          controller.getMeetingDataByDistrict(
                                              district['config_id'], 8),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text("Error");
                                        } else {
                                          return Text(
                                            snapshot.data.toString(),
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FutureBuilder(
                                      future:
                                          controller.getMeetingDataByDistrict(
                                              district['config_id'], 9),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text("Error");
                                        } else {
                                          return Text(
                                            snapshot.data.toString(),
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                            TableRow(
                              decoration:
                                  BoxDecoration(color: Colors.amber[100]),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                    future: controller.getMonthlyTotal(1),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        return const Text("Error");
                                      } else {
                                        return Text(
                                          snapshot1.data.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                    future: controller.getMonthlyTotal(2),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        return const Text("Error");
                                      } else {
                                        return Text(
                                          snapshot1.data.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                    future: controller.getMonthlyTotal(3),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        return const Text("Error");
                                      } else {
                                        return Text(
                                          snapshot1.data.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                    future: controller.getMonthlyTotal(4),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        return const Text("Error");
                                      } else {
                                        return Text(
                                          snapshot1.data.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                    future: controller.getMonthlyTotal(5),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        return const Text("Error");
                                      } else {
                                        return Text(
                                          snapshot1.data.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                    future: controller.getMonthlyTotal(6),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        return const Text("Error");
                                      } else {
                                        return Text(
                                          snapshot1.data.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                    future: controller.getMonthlyTotal(7),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        return const Text("Error");
                                      } else {
                                        return Text(
                                          snapshot1.data.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                    future: controller.getMonthlyTotal(8),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        return const Text("Error");
                                      } else {
                                        return Text(
                                          snapshot1.data.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                    future: controller.getMonthlyTotal(9),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        return const Text("Error");
                                      } else {
                                        return Text(
                                          snapshot1.data.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
