import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/lifestudy/assignlifestudyquestionscontroller.dart';

class AssignLifeStudyQuestions extends StatefulWidget {
  const AssignLifeStudyQuestions({super.key});

  @override
  State<AssignLifeStudyQuestions> createState() =>
      _AssignLifeStudyQuestionsState();
}

class _AssignLifeStudyQuestionsState extends State<AssignLifeStudyQuestions> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssignLifeStudyQuestionsController>(
        init: AssignLifeStudyQuestionsController(),
        builder: (alsqc) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Assign Life Study Questions",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
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
              body: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Container(
                  // height: MediaQuery.of(context).size.height * 1,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      image: const DecorationImage(
                          image: AssetImage('assets/images/bgimg.png'),
                          alignment: Alignment.center,
                          opacity: 0.05)),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.87,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade50),
                              color: Colors.white),
                          child: TextField(
                            controller: alsqc.lifeStudyTitle,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: "Enter Life Study Title",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1)),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade50),
                                  color: Colors.white),
                              child: TextField(
                                controller: alsqc.message1,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: "Enter Message 1",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade50),
                                  color: Colors.white),
                              child: TextField(
                                controller: alsqc.message2,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: "Enter Message 2",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.grey)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              // padding: EdgeInsets.all(5),
                              // margin: EdgeInsets.all(5),
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      alsqc.meetingDate,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  Container(
                                    // margin: EdgeInsets.symmetric(horizontal: 10),
                                    child: IconButton(
                                        iconSize: 25,
                                        onPressed: () {
                                          alsqc.datePicker(context);
                                        },
                                        icon: const Icon(
                                          Icons.calendar_month_rounded,
                                          color: Color(0xff005F01),
                                        )),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              // padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white),
                              child: DropdownButtonFormField(
                                // value: controller.districtId,
                                value: alsqc.districtId.toString() != '0'
                                    ? alsqc.districtId.toString()
                                    : null, // Default to null if no valid selection
                                isExpanded: true,
                                isDense: true,
                                hint: const Text("--Select District--"),
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none)),
                                items: alsqc.districts.map((e) {
                                  return DropdownMenuItem(
                                    value: e['id'].toString(),
                                    child: Text(e['name'].toString()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  alsqc.districtId = value.toString();
                                  alsqc.handleDistrict(value.toString());
                                  alsqc.update();
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
                        Container(
                          margin: EdgeInsets.all(5),
                          height: 40,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue.shade100),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text("ID", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
                              // SizedBox(width: 50,),
                              Text("Name",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),

                              Container(
                                  // margin: EdgeInsets.only(left: 90),
                                  child: Container(
                                margin: EdgeInsets.only(left: 40),
                                child: Text("Message",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              )),
                              Container(
                                  // margin: EdgeInsets.only(left: 90),
                                  child: Text("Question No.",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16))),
                            ],
                          ),
                        ),
                        ListView.builder(
                            physics: const ScrollPhysics(),
                            itemCount: alsqc.saints.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 50,
                                padding: EdgeInsets.only(left: 10),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        "${index + 1} . ${alsqc.saints[index]['name']}",
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.28,
                                    ),
                                    Container(
                                      // padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(right: 20),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.grey),
                                          color: Colors.white),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(
                                              left: 15, bottom: 10),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide.none),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.red, width: 1)),
                                        ),
                                        onChanged: (String value) {
                                          alsqc.handleMessage(
                                              alsqc.saints[index]['id'], value);
                                        },
                                      ),
                                    ),
                                    Container(
                                      // padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(right: 20),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.grey),
                                          color: Colors.white),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(
                                              left: 15, bottom: 10),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide.none),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.red, width: 1)),
                                        ),
                                        onChanged: (String value) {
                                          alsqc.handleQuestionNo(
                                              alsqc.saints[index]['id'], value);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        alsqc.handleSave();
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey)),
                  ],
                ),
              ),
            ));
  }
}
