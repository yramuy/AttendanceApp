import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/attendance/attendancereportcontroller.dart';

import '../bottompages/bottomnavigationbar.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceReportController>(
        init: AttendanceReportController(),
        builder: (arc) => Scaffold(
              appBar: AppBar(
                title: Text(
                  "${arc.appBarTitle.toString()} ${arc.attendance.toString() == '1' ? "Attendees" : "Absentees"}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xFF2c2cff),
                // centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
                leading: GestureDetector(
                  onTap: () {
                    Get.offAll(() => const BottomNavigationTileScreen(),
                        arguments: arc.meetingDate);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                  ),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Get.offAll(() => const BottomNavigationTileScreen(),
                            arguments: arc.meetingDate);
                      },
                      icon: Icon(
                        Icons.home_outlined,
                        size: 35,
                        color: Colors.white,
                      ))
                ],
              ),
              body: arc.isLoading == true
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
                                        arc.meetingDate,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      trailing: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: IconButton(
                                            iconSize: 25,
                                            onPressed: () {
                                              arc.datePicker(context);
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
                                      value: arc.districtId.toString() != '0'
                                          ? arc.districtId.toString()
                                          : null, // Default to null if no valid selection
                                      isExpanded: true,
                                      isDense: true,
                                      hint: const Text("--Select District--"),
                                      decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none)),
                                      items: arc.districts.map((e) {
                                        return DropdownMenuItem(
                                          value: e['id'].toString(),
                                          child: Text(e['name'].toString()),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        arc.districtId = value.toString();
                                        arc.handleDistrict(value.toString());
                                        arc.update();
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
                              Container(
                                margin: EdgeInsets.all(5),
                                height: 40,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      child: Text("Name",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Inter-Medium",
                                              fontSize: 14)),
                                    ),
                                    Text("Attendance",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Inter-Medium",
                                            fontSize: 14)),
                                  ],
                                ),
                              ),
                              arc.saints.isEmpty
                                  ? Container(
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
                                      itemCount: arc.saints.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          height: 50,
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${index + 1} . ${arc.saints[index]['name']}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily:
                                                          "Inter-Medium",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                child: arc.saints[index]
                                                                ['attendance']
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
