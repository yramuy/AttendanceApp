import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/finance/paymenthistorycontroller.dart';
import 'package:maintenanceapp/widgets/constants.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentHistoryController>(
        init: PaymentHistoryController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xff004cf1),
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  "Payment History",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
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
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/bgimg.png'),
                        alignment: Alignment.center,
                        opacity: 0.05)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFdbdbdb),
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          onTap: () {
                            controller.datePicker(context);
                          },
                          trailing: IconButton(
                            onPressed: () {
                              controller.datePicker(context);
                            },
                            icon: const Icon(
                              Icons.date_range,
                              size: 30,
                            ),
                          ),
                          leading: Text(
                            controller.selectedFromDate.toString(),
                            style:
                                const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: const Color(0xff005F01).withOpacity(0.6),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(20),
                              1: FlexColumnWidth(10)
                            },
                            children: const [
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Opening Balance",
                                          style: Constants.myTextStyle,
                                        ))),
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "10000",
                                    style: Constants.myTextStyle,
                                  ),
                                )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Received Amount",
                                    style: Constants.myTextStyle,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "15000",
                                    style: Constants.myTextStyle,
                                  ),
                                )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Expenses",
                                    style: Constants.myTextStyle2,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "5000",
                                    style: Constants.myTextStyle2,
                                  ),
                                )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Closing Balance",
                                    style: Constants.myTextStyle2,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "20000",
                                    style: Constants.myTextStyle2,
                                  ),
                                )),
                              ])
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Text(
                          "Transaction History",
                          style: Constants.myTextStyle2,
                        ),
                      ),
                      SizedBox(
                        height: 350,
                        width: MediaQuery.of(context).size.width * 1,
                        child: ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xff005F01).withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: Column(
                                  children: [
                                    Table(
                                      // columnWidths: const {
                                      //   0: FlexColumnWidth(20),
                                      //   1: FlexColumnWidth(10)
                                      // },
                                      children: const [
                                        TableRow(children: [
                                          TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text("Payment Type", style: Constants.myTextStyle,),
                                              )
                                          ),
                                          TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text("Received", style: Constants.myTextStyle,),
                                              )
                                          ),
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text("Location", style: Constants.myTextStyle,),
                                              )
                                          ),
                                          TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text("Vizag City", style: Constants.myTextStyle,),
                                              )
                                          ),
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text("Offering Type", style: Constants.myTextStyle,),
                                              )
                                          ),
                                          TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text("General Offering", style: Constants.myTextStyle,),
                                              )
                                          ),
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text("Amount", style: Constants.myTextStyle,),
                                              )
                                          ),
                                          TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text("5650", style: Constants.myTextStyle,),
                                              )
                                          ),
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text("Date", style: Constants.myTextStyle,),
                                              )
                                          ),
                                          TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text("07/07/2024", style: Constants.myTextStyle,),
                                              )
                                          ),
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text("Comments", style: Constants.myTextStyle,),
                                              )
                                          ),
                                          TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text("Received general offering from Vizag city", style: Constants.myTextStyle,),
                                              )
                                          ),
                                        ])
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ));
  }
}
