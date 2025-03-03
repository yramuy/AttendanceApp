import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/finance/creditwithdrawalpaymentcontroller.dart';

class CreditWithdrawalPayment extends StatefulWidget {
  const CreditWithdrawalPayment({super.key});

  @override
  State<CreditWithdrawalPayment> createState() =>
      _CreditWithdrawalPaymentState();
}

class _CreditWithdrawalPaymentState extends State<CreditWithdrawalPayment> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditWithdrawalPaymentController>(
        init: CreditWithdrawalPaymentController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Credit/Withdrawal",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xff004cf1),
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
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    image: const DecorationImage(
                        alignment: Alignment.center,
                        image: AssetImage('assets/images/bgimg.png'),
                        opacity: 0.05)),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Payment Type",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFdbdbdb),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            decoration: const InputDecoration(
                              hintText: "--Select--",
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 20),
                              border: InputBorder.none,
                            ),
                            isDense: true,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            iconSize: 30,

                            items: controller.paymentTypes.map((item) {
                              return new DropdownMenuItem(
                                child: Text(
                                  item['name'].toString(),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                                value: item['name'],
                              );
                            }).toList(),
                            onChanged: (value) {
                              controller.selectedItem = value.toString();
                              controller.handlePaymentType(value.toString());
                              log(controller.selectedItem);
                            },
                            // value: controller.selectedItem.toString(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                            visible: controller.flag,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Location",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFdbdbdb),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    isDense: true,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ),
                                    iconSize: 30,
                                    decoration: const InputDecoration(
                                      hintText: "--Select--",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        left: 10,
                                        right: 20,
                                      ),
                                    ),
                                    items: controller.locations.map((loc) {
                                      return DropdownMenuItem(
                                        child: Text(loc['name']),
                                        value: loc['name'],
                                      );
                                    }).toList(),
                                    onChanged: (value) {},
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Offring Type",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFdbdbdb),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    isDense: true,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ),
                                    iconSize: 30,
                                    decoration: const InputDecoration(
                                      hintText: "--Select--",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        left: 10,
                                        right: 20,
                                      ),
                                    ),
                                    items: controller.offeringTypes.map((loc) {
                                      return DropdownMenuItem(
                                        child: Text(loc['name']),
                                        value: loc['name'],
                                      );
                                    }).toList(),
                                    onChanged: (value) {},
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Date",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
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
                              icon: Icon(
                                Icons.date_range,
                                size: 30,
                              ),
                            ),
                            leading: Text(
                              controller.selectedFromDate.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Amount",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFdbdbdb),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10)),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Comments",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFdbdbdb),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextFormField(
                            maxLines: 4,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 10, top: 10)),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
