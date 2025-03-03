import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/lifestudy/lifestudyquestionlistcontroller.dart';
import 'package:maintenanceapp/views/lifestudy/assignlifestudyquestions.dart';

import '../bottompages/bottomnavigationbar.dart';

class LifeStudyQuestionList extends StatefulWidget {
  const LifeStudyQuestionList({super.key});

  @override
  State<LifeStudyQuestionList> createState() => _LifeStudyQuestionListState();
}

class _LifeStudyQuestionListState extends State<LifeStudyQuestionList> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LifeStudyQuestionListController>(
        init: LifeStudyQuestionListController(),
        builder: (lsqlc) => Scaffold(
            appBar: AppBar(
              title: const Text(
                "Life Study Questions List",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color(0xFF2c2cff),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: GestureDetector(
                onTap: () {
                  Get.offAll(() => const BottomNavigationTileScreen());
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(() => const AssignLifeStudyQuestions());
                    },
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      size: 35,
                    )),
                IconButton(
                    onPressed: (){
                      Get.offAll(() => const BottomNavigationTileScreen());
                    },
                    icon: Icon(Icons.home_outlined, size: 35, color: Colors.white,)
                )
              ],
            ),
            body: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    image: const DecorationImage(
                        image: AssetImage('assets/images/bgimg.png'),
                        alignment: Alignment.center,
                        opacity: 0.05)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(left: 15),
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
                                  lsqlc.meetingDate,
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
                                      lsqlc.datePicker(context);
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
                          margin: EdgeInsets.only(right: 20),
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              color: Colors.white),
                          child: DropdownButtonFormField(
                            // value: controller.districtId,
                            value: lsqlc.districtId.toString() != '0'
                                ? lsqlc.districtId.toString()
                                : null, // Default to null if no valid selection
                            isExpanded: true,
                            isDense: true,
                            hint: const Text("-- Select --"),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                            items: lsqlc.districts.map((e) {
                              return DropdownMenuItem(
                                value: e['id'].toString(),
                                child: Text(e['name'].toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              lsqlc.districtId = value.toString();
                              lsqlc.handleDistrict(value.toString());
                              lsqlc.update();
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
                    lsqlc.lifeStudies.isEmpty
                        ? Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(6),

                            // width: 100,
                            height: MediaQuery.of(context).size.height*0.8,
                            child: Card(
                                color: Colors.white,
                                shadowColor: Colors.purpleAccent,
                                elevation: 5,
                                child: Center(
                                    child: Image.asset(
                                        "assets/images/no_data.jpg"))),
                          )
                        : ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: lsqlc.lifeStudies.length,
                            itemBuilder: (BuildContext context, int index) {
                              log("lifeStudies111 ${lsqlc.lifeStudies}");
                              return Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.all(6),
                                // width: 100,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: Card(
                                  color: Colors.white,
                                  shadowColor: Colors.purpleAccent,
                                  elevation: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                                lsqlc.lifeStudies[index]
                                                        ['district']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              lsqlc.lifeStudies[index]
                                                      ['meetingDate']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Text(
                                              "${lsqlc.lifeStudies[index]['life_study_title'].toString()}, Message 1 : ${lsqlc.lifeStudies[index]['message_1'].toString()}, Message 2 : ${lsqlc.lifeStudies[index]['message_2'].toString()}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            padding: EdgeInsets.all(10),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Colors.green.shade300),
                                            child: IconButton(
                                                onPressed: () {
                                                  lsqlc.handleLifeStudyQnsShare(
                                                      lsqlc.lifeStudies[index]);
                                                },
                                                icon: Icon(
                                                  Icons.share_rounded,
                                                  size: 30,
                                                  color: Colors.white,
                                                )),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                  ],
                ),
              ),
            )));
  }
}
