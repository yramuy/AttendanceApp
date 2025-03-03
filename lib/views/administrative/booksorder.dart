import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/administrative/booksordercontroller.dart';

class BooksOrder extends StatefulWidget {
  const BooksOrder({super.key});

  @override
  State<BooksOrder> createState() => _BooksOrderState();
}

class _BooksOrderState extends State<BooksOrder> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BooksOrderController>(
        init: BooksOrderController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Books Order",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
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
              body: Container(
                height: MediaQuery.of(context).size.height*1,
                width: MediaQuery.of(context).size.width*1,
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Saint Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        // width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.4)),
                        child: TextFormField(
                          controller: controller.nameController,
                          decoration: const InputDecoration(
                              hintText: "Search Saint...",
                              contentPadding:
                                  EdgeInsets.only(left: 10, bottom: 10),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          onChanged: (value) {
                            controller.onSearchChanged();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      controller.userData.isNotEmpty
                          ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueGrey,
                            ),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.userData.length,
                                itemBuilder: (BuildContext context, index) {
                                  var userData = controller.userData;
                                  return ListTile(
                                    title: Text(userData[index]['name'], style: TextStyle(color: Colors.white),),
                                    onTap: () {
                                      controller.updateData(userData[index]);
                                    },
                                  );
                                }),
                          )
                          : Container(),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Morning Revaival Books",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                                title: Text("Telugu"),
                                value: controller.isTelSelected,
                                onChanged: (value) {
                                  controller.handleCheckbox(value, "Tel");
                                  // controller.isTelSelected = value ?? false;
                                }),
                          ),
                          Expanded(
                              child: CheckboxListTile(
                            title: Text("English"),
                            value: controller.isEngSelected,
                            onChanged: (value) {
                              controller.handleCheckbox(value, "Eng");
                            },
                          )),
                        ],
                      ),
                      Row(
                        children: [
                          Visibility(
                              visible: controller.isTelSelected,
                              child: Expanded(
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.4)),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: "Enter Book Count...",
                                        contentPadding: EdgeInsets.only(
                                            left: 10, bottom: 10),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none)),
                                    controller: controller.telvalController,
                                  ),
                                ),
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Visibility(
                              visible: controller.isEngSelected,
                              child: Expanded(
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.4)),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Enter Book Count...",
                                        contentPadding: EdgeInsets.only(
                                            left: 10, bottom: 20),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none)),
                                    keyboardType: TextInputType.number,
                                    controller: controller.engvalController,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Ministry Books",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.4)),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: "Enter MB Books and Count...",
                              contentPadding:
                                  EdgeInsets.only(left: 10, bottom: 20),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          // keyboardType: TextInputType.number,
                          controller: controller.mbController,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text(
                                "Save",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("Cancel",
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: CupertinoColors.systemGrey),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
