import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/meetingschedule/meetingschedulecontroller.dart';

class MeetingSchedule extends StatefulWidget {
  const MeetingSchedule({super.key});

  @override
  State<MeetingSchedule> createState() => _MeetingScheduleState();
}

class _MeetingScheduleState extends State<MeetingSchedule> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeetingScheduleController>(
        init: MeetingScheduleController(),
        builder: (msc) => Scaffold(
              appBar: AppBar(
                title: Text(
                  msc.scheduleID.toString() != '0'
                      ? "Edit Schedule Meeting"
                      : "Schedule Meeting",
                  style: const TextStyle(
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
              body: SizedBox(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                child: Card(
                  child: SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Form(
                        key: msc.scheduleFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Meeting Name",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                controller: msc.meetingType,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 15, bottom: 10),
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
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Meeting Type is required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Meeting Mode",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: "1",
                                    groupValue: msc.meetingMode,
                                    onChanged: (String? value) {
                                      msc.handleRadioButton(value);
                                    }),
                                const Text(
                                  "Offline",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                                Radio(
                                    value: "2",
                                    groupValue: msc.meetingMode,
                                    onChanged: (String? value) {
                                      msc.handleRadioButton(value);
                                    }),
                                const Text(
                                  "Online",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                "Meeting ${msc.meetingMode.toString() == "1" ? "Location" : "Link"}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                controller: msc.meetingLocation,
                                maxLines: 1,
                                decoration: InputDecoration(
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
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Meeting Place is required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Date",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                            Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                  Border.all(color: Colors.grey, width: 1)),
                              child: ListTile(
                                contentPadding:
                                const EdgeInsets.only(left: 10, bottom: 10),
                                leading: Text(
                                  msc.meetingDate,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                trailing: IconButton(
                                    alignment: Alignment.topCenter,
                                    iconSize: 25,
                                    onPressed: () {
                                      msc.datePicker(context);
                                    },
                                    icon: const Icon(
                                      Icons.calendar_month_rounded,
                                      color: Color(0xff005F01),
                                    )),
                              ),
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("From",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        readOnly: true,

                                        controller: TextEditingController(
                                          text: msc.formattedFromTime
                                                  .toString()
                                                  .isNotEmpty
                                              ? msc.formattedFromTime.toString()
                                              : "",
                                        ),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1)),
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
                                          contentPadding: const EdgeInsets.only(
                                              left: 10, top: 10),
                                          // border: InputBorder.none,
                                          hintText: "Select Time",
                                          suffixIcon: IconButton(
                                            iconSize: 25,
                                            alignment: Alignment.center,
                                            onPressed: () {
                                              msc.handleFromTime(context);
                                            },
                                            icon: const Icon(
                                              Icons.timer_outlined,
                                              color: Color(0xff005F01),
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 14),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select a time.';
                                          }
                                          return null;
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("To",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: TextEditingController(
                                          text: msc.formattedToTime
                                                  .toString()
                                                  .isNotEmpty
                                              ? msc.formattedToTime.toString()
                                              : "",
                                        ),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1)),
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
                                          contentPadding: const EdgeInsets.only(
                                              left: 10, top: 10),
                                          // border: InputBorder.none,
                                          hintText: "Select Time",
                                          suffixIcon: IconButton(
                                            iconSize: 25,
                                            alignment: Alignment.center,
                                            onPressed: () {
                                              msc.handleToTime(context);
                                            },
                                            icon: const Icon(
                                              Icons.timer_outlined,
                                              color: Color(0xff005F01),
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 14),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select a time.';
                                          }
                                          return null;
                                        },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (msc.scheduleFormKey.currentState!
                                          .validate()) {
                                        msc.handleSave();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: Text(
                                      msc.scheduleID.toString() != '0'
                                          ? "Update"
                                          : "Schedule",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            CupertinoColors.systemGrey),
                                    child: const Text("Cancel",
                                        style: TextStyle(color: Colors.white)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}
