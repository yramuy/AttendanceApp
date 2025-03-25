import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/finance/monthlymaintenancecontroller.dart';
import 'package:maintenanceapp/views/bottompages/bottomnavigationbar.dart';
import 'package:maintenanceapp/views/finance/adddailymaintenance.dart';
import 'package:maintenanceapp/views/finance/financehome.dart';

class MonthlyMaintenance extends StatelessWidget {
  const MonthlyMaintenance({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MonthlyMaintenanceController>(
        init: MonthlyMaintenanceController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xff004cf1),
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  "Maintenance History",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                leading: GestureDetector(
                  onTap: () {
                    Get.offAll(const BottomNavigationTileScreen());
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const AddDailyMaintenance());
                    },
                    child: Icon(Icons.add, size: 40,),
                  ),
                  SizedBox(
                    width: 15,
                  )
                ],
              ),
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                   physics: ScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 180,
                                // margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.white),
                                child: DropdownButtonFormField(
                                    isExpanded: true,
                                    isDense: true,
                                    iconSize: 30,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        hintText: "--Select Month--"),
                                    items: controller.monthList.entries
                                        .map<DropdownMenuItem<String>>((entry) {
                                      return DropdownMenuItem<String>(
                                        value: entry
                                            .key, // Month name as the value
                                        child: Text(
                                            '${entry.value}'), // Display key and value
                                      );
                                    }).toList(),
                                    value:
                                        "${controller.selectedMonth.toString()}",
                                    onChanged: (value) {
                                      controller.handleMonth(value);
                                      log(value.toString());

                                    }),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  padding: EdgeInsets.all(10),
                                  // margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    "Generate Report",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          // width: 400,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.purple.shade200,
                                    blurRadius: 3,
                                    spreadRadius: 2)
                              ]),
                          child: DataTable(
                            columnSpacing: 0,
                            horizontalMargin: 5,
                            dataRowMinHeight: 50,
                            dataRowMaxHeight: 50,
                            // showCheckboxColumn: true,
                            columns: [
                              DataColumn(
                                  label: SizedBox(
                                width: 90,
                                child: Text('Opening Balance',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Inter-Medium",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              )),
                              DataColumn(
                                  label: SizedBox(
                                width: 80,
                                child: Text('Income',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Inter-Medium",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              )),
                              DataColumn(
                                  label: SizedBox(
                                width: 80,
                                child: Text('Expense',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Inter-Medium",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              )),
                              DataColumn(
                                  label: SizedBox(
                                width: 90,
                                child: Text('Closing Balance',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Inter-Medium",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              )),
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(SizedBox(
                                  width: 80,
                                  child: Text(controller.openingBalance,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Inter-Medium",
                                          fontSize: 14)),
                                )),
                                DataCell(SizedBox(
                                  width: 70,
                                  child: Text(controller.receivedAmount,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontFamily: "Inter-Medium",
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                )),
                                DataCell(SizedBox(
                                  width: 70,
                                  child: Text(controller.expenseAmount,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: "Inter-Medium",
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                )),
                                DataCell(SizedBox(
                                  width: 80,
                                  child: Text(controller.closingBalance,
                                      style: TextStyle(
                                          fontFamily: "Inter-Medium",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                )),
                              ]),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            "Transaction History",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Inter-Medium"),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.green.shade200,
                                    blurRadius: 3,
                                    spreadRadius: 2)
                              ]),
                          child: DataTable(
                            columnSpacing: 0,
                            horizontalMargin: 5,
                            dataRowMinHeight: 60,
                            dataRowMaxHeight: 60,
                            columns: [
                              DataColumn(
                                label: SizedBox(
                                  width: 90,
                                  child: Text(
                                    'Date',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Inter-Medium",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 60,
                                  child: Text(
                                    'Type',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Inter-Medium",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 80,
                                  child: Text(
                                    'Amount',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Inter-Medium",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 90,
                                  child: Text(
                                    'Description',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Inter-Medium",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: controller.maintenanceHistory.isNotEmpty
                                ? controller.maintenanceHistory
                                .map((transaction) {
                              return DataRow(cells: [
                                DataCell(Text(
                                  transaction['transaction_date']
                                      .toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(

                                    fontFamily: "Inter-Medium",
                                  ),
                                )),
                                DataCell(Text(
                                  transaction['transaction_type']
                                      .toString(),
                                  style: TextStyle(
                                    color:
                                    transaction['transaction_type'] ==
                                        'credit'
                                        ? Colors.green
                                        : Colors.red,
                                    fontFamily: "Inter-Medium",


                                  ),
                                )),
                                DataCell(Text(
                                  transaction['amount'].toString(),
                                  style: TextStyle(
                                    fontFamily: "Inter-Medium",

                                  ),
                                )),
                                DataCell(Text(
                                  transaction['description'],
                                  style: TextStyle(
                                    fontFamily: "Inter-Medium"
                                  ),
                                )),
                              ]);
                            }).toList()
                                : [
                              DataRow(cells: [
                                DataCell(Text(
                                  "No records found",
                                  style: TextStyle(
                                    fontFamily: "Inter-Medium",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                DataCell.empty,
                                DataCell.empty,
                                DataCell.empty,
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
