import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/finance/adddailymaintenancecontroller.dart';

class AddDailyMaintenance extends StatelessWidget {
  const AddDailyMaintenance({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddDailyMaintenanceController>(
        init: AddDailyMaintenanceController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xff004cf1),
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  "Add Daily Maintenance",
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
              body: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  // width: 400,
                  // height: 100,
                  child: Card(
                    margin: EdgeInsets.all(5),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Transaction Type",
                            style: TextStyle(
                                fontFamily: "Inter-Medium", fontSize: 14),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            hint: const Text("--Select--"),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10, bottom: 10, right: 10),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
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
                                value: item['name'].toString(),
                              );
                            }).toList(),
                            onChanged: (value) {
                              controller.handlePaymentType(value.toString());
                            },
                            // value: controller.selectedItem.toString(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Amount",
                            style: TextStyle(
                                fontFamily: "Inter-Medium", fontSize: 14),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: TextFormField(
                            controller: controller.amount,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10, bottom: 10, right: 10),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Description",
                            style: TextStyle(
                                fontFamily: "Inter-Medium", fontSize: 14),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: TextFormField(
                            controller: controller.description,
                            maxLines: 3,
                            minLines: 3,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10, bottom: 10, right: 10),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Transaction Date",
                            style: TextStyle(
                                fontFamily: "Inter-Medium", fontSize: 14),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.datePicker(context);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.transactionDate.toString(),
                                  style: TextStyle(
                                      fontFamily: "Inter-Medium", fontSize: 14),
                                ),
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: Colors.purple,
                                  size: 25,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if(controller.paymentType.toString() == "") {
                                  Get.rawSnackbar(
                                      snackPosition: SnackPosition.TOP,
                                      padding: EdgeInsets.all(15),
                                      margin: EdgeInsets.all(5),
                                      message: "Transaction type required");
                                }else if(controller.amount.text.toString() == "") {
                                  Get.rawSnackbar(
                                      snackPosition: SnackPosition.TOP,
                                      padding: EdgeInsets.all(15),
                                      margin: EdgeInsets.all(5),
                                      message: "Amount required");
                                }else if(controller.description.text.toString() == "") {
                                  Get.rawSnackbar(
                                      snackPosition: SnackPosition.TOP,
                                      padding: EdgeInsets.all(15),
                                      margin: EdgeInsets.all(5),
                                      message: "Description required");
                                }else {
                                  controller.handleSave();
                                }

                              },
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.green),
                                child: Text(
                                  "Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Inter-Medium',
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey),
                                child: Text(
                                  "Back",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Inter-Medium',
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
