import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/bottompages/meetingscontroller.dart';
import 'package:maintenanceapp/widgets/constants.dart';

class Meetings extends StatefulWidget {
  const Meetings({super.key});

  @override
  State<Meetings> createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeetingController>(
        init: MeetingController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                title: Text(
                  "Meetings",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xff005F01),
              ),
              body: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height * 0.4,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueGrey),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: const Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Praise the Lord Saints",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Table(
                                  children: const [
                                    TableRow(children: [
                                      TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Meeting Title",
                                          style: Constants.myTextStyle,
                                        ),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Thanks giving meeting",
                                          style: Constants.myTextStyle,
                                        ),
                                      ))
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Meeting Date",
                                          style: Constants.myTextStyle,
                                        ),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "25-08-2024",
                                          style: Constants.myTextStyle,
                                        ),
                                      ))
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Meeting Time",
                                          style: Constants.myTextStyle,
                                        ),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "6:30pm",
                                          style: Constants.myTextStyle,
                                        ),
                                      ))
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Meeting Place",
                                          style: Constants.myTextStyle,
                                        ),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Bro. Asheervadham House, Sector-1, 223 UkkuNagaram.",
                                          style: Constants.myTextStyle,
                                        ),
                                      ))
                                    ])
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      })),
            ));
  }
}
