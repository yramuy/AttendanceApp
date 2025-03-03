import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:maintenanceapp/controllers/administrative/collectbooksamountcontroller.dart';
import 'package:maintenanceapp/widgets/constants.dart';

class CollectBooksAmount extends StatefulWidget {
  const CollectBooksAmount({super.key});

  @override
  State<CollectBooksAmount> createState() => _CollectBooksAmountState();
}

class _CollectBooksAmountState extends State<CollectBooksAmount> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CollectBooksAmountController>(
        init: CollectBooksAmountController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Collect Books Amount",
                  style: Constants.textStyle,
                ),
                centerTitle: true,
                backgroundColor: const Color(0xff004cf1),
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
              body: ListView.builder(
                  itemCount: controller.booksOrder.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    print(controller.booksOrder);
                    var tel = controller.booksOrder[index]['mrbTel'].toString();
                    var eng = controller.booksOrder[index]['mrbEng'].toString();
                    var mrbPrice =
                        controller.booksOrder[index]['mrbPrice'].toString();
                    var mb = controller.booksOrder[index]['mb'].toString();
                    var mbPrice =
                        controller.booksOrder[index]['mbPrice'].toString();
                    var mrbTotal = controller
                        .countBooks(
                            controller.booksOrder[index]['mrbTel'].toString(),
                            controller.booksOrder[index]['mrbEng'].toString(),
                            controller.booksOrder[index]['mrbPrice'].toString())
                        .toString();
                    var mbTotal = controller
                        .countMBTotal(
                            controller.booksOrder[index]['mb'].toString(),
                            controller.booksOrder[index]['mbPrice'].toString())
                        .toString();
                    var mrbTotalVal = int.tryParse(mrbTotal);
                    var mbTotalVal = int.tryParse(mbTotal);
                    var totalAmount = mrbTotalVal! + mbTotalVal!;

                    print("Total AMount : $totalAmount");

                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueGrey),
                      child: Table(
                        children: [
                          TableRow(children: [
                            const TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Name",
                                style: Constants.textStyle,
                              ),
                            )),
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                controller.booksOrder[index]['name'],
                                style: Constants.textStyle,
                              ),
                            )),
                          ]),
                          TableRow(children: [
                            const TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Morning Revival Books",
                                style: Constants.textStyle,
                              ),
                            )),
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Tel : $tel Eng : $eng Price : $mrbPrice",
                                style: Constants.textStyle,
                              ),
                            )),
                          ]),
                          TableRow(children: [
                            const TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Morning Revival Amount",
                                style: Constants.textStyle,
                              ),
                            )),
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                mrbTotal,
                                style: Constants.textStyle,
                              ),
                            ))
                          ]),
                          TableRow(children: [
                            const TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Ministry Books",
                                style: Constants.textStyle,
                              ),
                            )),
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Books : $mb Price : $mbPrice",
                                style: Constants.textStyle,
                              ),
                            )),
                          ]),
                          TableRow(children: [
                            const TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Ministry Books Amount",
                                style: Constants.textStyle,
                              ),
                            )),
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                mbTotal,
                                style: Constants.textStyle,
                              ),
                            ))
                          ]),
                          TableRow(children: [
                            const TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Total Amount",
                                style: Constants.textStyle,
                              ),
                            )),
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                totalAmount.toString(),
                                style: Constants.textStyle,
                              ),
                            ))
                          ]),
                          TableRow(children: [
                            const TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Payment Status",
                                style: Constants.textStyle,
                              ),
                            )),
                            TableCell(
                                child: Align(
                              alignment: Alignment.centerLeft,
                              // child: Switch(
                              //   value: controller.isToggled[index] ?? false,
                              //   onChanged: (bool value) {
                              //     controller.handleToggle(index, value);
                              //   },
                              //   activeColor: Colors.green,
                              //   inactiveThumbColor: Colors.red,
                              //   inactiveTrackColor: Colors.red[200],
                              // ),
                              child: LiteRollingSwitch(
                                value: controller.isToggled[index] ??
                                    false, // Initial state
                                textOn: 'Paid', // Text when switched on
                                textOff: 'Pending', // Text when switched off
                                colorOn: Colors
                                    .green, // Background color when switched on
                                colorOff: Colors
                                    .red, // Background color when switched off
                                iconOn: Icons.done, // Icon when switched on
                                iconOff: Icons
                                    .remove_circle_outline,
                                textOnColor: Colors.white,// Icon when switched off
                                width: MediaQuery.of(context).size.width*0.32,
                                textSize: 16,
                                onChanged: (bool value) {
                                  controller.handleToggle(index, value);
                                  print("Switch is $value");
                                },
                                onTap: () {}, onDoubleTap: () {},
                                onSwipe: () {},
                              ),
                            ))
                          ])
                        ],
                      ),
                    );
                  }),
            ));
  }
}
