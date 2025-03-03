import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/bottompages/prayerrequestcontroller.dart';

class PrayerRequests extends StatefulWidget {
  const PrayerRequests({super.key});

  @override
  State<PrayerRequests> createState() => _PrayerRequestsState();
}

class _PrayerRequestsState extends State<PrayerRequests> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrayerRequestController>(
        init: PrayerRequestController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xff005F01),
                title: const Text(
                  "Prayer Requests",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // centerTitle: true,
              ),
              body: SizedBox(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height * 0.2,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              // margin: EdgeInsets.only(right: 30),
                              child: Text(
                                textAlign: TextAlign.left,
                                "Prayer Request : ",
                                style: TextStyle(
                                    color: Colors.amberAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "I am facing some important decisions in my life right now, "
                                  "and I could use your prayers for clarity, wisdom, and guidance. "
                                  "Please pray that I may make the right choices and find peace in my "
                                  "path forward.I am facing some important decisions in my life right now, "
                                  "and I could use your prayers for clarity, wisdom, and guidance. "
                                  "Please pray that I may make the right choices and find peace in my "
                                  "path forward.",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ));
  }
}
