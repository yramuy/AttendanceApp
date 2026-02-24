import 'package:flutter/material.dart'
    '';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/attendance/weeklyreportcontroller.dart';

class WeeklyReport extends StatefulWidget {
  const WeeklyReport({super.key});

  @override
  State<WeeklyReport> createState() => _WeeklyReportState();
}

class _WeeklyReportState extends State<WeeklyReport> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeeklyReportController>(
      init: WeeklyReportController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text(
            "Weekly Reports",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            image: const DecorationImage(
              image: AssetImage('assets/images/bgimg.png'),
              alignment: Alignment.center,
              opacity: 0.05,
            ),
          ),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Meeting Date",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            controller.meetingDate,
                          ),
                          margin: EdgeInsets.only(left: 10),
                        ),
                        IconButton(
                            onPressed: () {
                              controller.datePicker(context);
                            },
                            icon: Icon(Icons.calendar_month_rounded))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.districts.length,
                      itemBuilder: (BuildContext, index) {
                        return GestureDetector(
                          onTap: () {
                            controller.handleReport(
                                controller.districts[index]['config_id'],controller.districts[index]['name']);
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    controller.districts[index]['name']
                                        .toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Container(
                                  child: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 30,
                                    color: Colors.blueAccent,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
