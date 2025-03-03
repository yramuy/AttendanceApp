import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:maintenanceapp/controllers/meetingschedule/meetingschedulelistcontroller.dart';
import 'package:maintenanceapp/views/meetingschedule/meetingschedulelist.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/restapi.dart';

class MeetingScheduleController extends GetxController {
  final scheduleFormKey = GlobalKey<FormState>();
  String? meetingMode = "1";
  late DateTime currentDate;
  String meetingDate = Jiffy(DateTime.now()).format('yyyy-MM-dd');
  TimeOfDay? selectedFromTime = TimeOfDay.now();
  TimeOfDay? selectedToTime = TimeOfDay.now();
  TextEditingController meetingType = TextEditingController();
  TextEditingController meetingLocation = TextEditingController();
  String? formattedFromTime = "";
  String? formattedToTime = "";
  String? createdBy;
  String? scheduleID = '0';
  String? userID = '0';
  dynamic argumentData = Get.arguments;
  final MeetingScheduleListController msc = Get.put(MeetingScheduleListController());
  FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    // TODO: implement onInit
    loadLoginData();
    log("Argument Data $argumentData");
    super.onInit();
  }

  loadLoginData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    createdBy = pref.getString('userID');
    if (argumentData is Map && argumentData.containsKey('scheduleId') && argumentData['scheduleId'].toString() != '0'
        ) {
      scheduleID = argumentData['scheduleId'].toString();
      meetingType.text = argumentData['meeting_type'].toString();
      meetingLocation.text = argumentData['meeting_location'].toString();
      meetingDate = argumentData['meeting_date'].toString();
      formattedFromTime = argumentData['from_time'].toString();
      formattedToTime = argumentData['to_time'].toString();
      update();
    }
    update();
  }

  void handleRadioButton(String? value) {
    meetingMode = value;
    update();
  }

  datePicker(BuildContext context) async {
    currentDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ))!;
    meetingDate = Jiffy(currentDate).format('yyyy-MM-dd');
  //if the user has selected a date

    update();
  }

  handleFromTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedFromTime ?? TimeOfDay.now(),
    );

    if (time != null) {
      selectedFromTime = time;
      formattedFromTime = formatTimeOfDay(time);
      print("From $formattedFromTime");
    }

    update();
  }

  handleToTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedToTime ?? TimeOfDay.now(),
    );

    if (time != null) {
      selectedToTime = time;
      formattedToTime = formatTimeOfDay(time);
      print("From $formattedToTime");
    }
    update();
  }

  String formatTimeOfDay(TimeOfDay time) {
    final int hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod; // Convert 0 to 12 for AM
    final String period = time.period == DayPeriod.am ? "AM" : "PM";
    final String minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }

  handleSave() async {
    var body = jsonEncode({
      "schedule_id": scheduleID,
      "meeting_type": meetingType.text,
      "meeting_mode": meetingMode,
      "meeting_location": meetingLocation.text,
      "meeting_date": meetingDate,
      "from_time": formattedFromTime,
      "to_time": formattedToTime,
      "created_by": createdBy
    });

    print("Body $body");

    await ApiService.post("saveOrUpdateMeetingSchedule", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: responseBody['message'].toString());
          msc.loadMeetingSchedules();
          Get.off(() => const MeetingScheduleList());
        } else {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: responseBody['message'].toString());
        }
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: 'Something went wrong, Please retry later');
      }
      update();
    });
  }
}
