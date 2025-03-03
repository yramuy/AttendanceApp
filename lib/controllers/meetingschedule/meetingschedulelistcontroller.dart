import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:maintenanceapp/apiservice/restapi.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class MeetingScheduleListController extends GetxController {
  List meetingSchedules = [];
  late DateTime meetingDate;
  String currentDate = Jiffy(DateTime.now()).format('yyyy-MM-dd');
  String? dayOfWeek;
  String? scheduleId;
  // Create a list to hold all Sundays
  List sundays = [];
  @override
  void onInit() {
    // TODO: implement onInit
    getCurrentMonthSundays();
    super.onInit();
  }

  loadMeetingSchedules() async {
    // var body = jsonEncode({'from_date': "", 'to_date': ""});

    await ApiService.get('meetingSchedules').then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          meetingSchedules = responseBody['schedules'];
          log("Schedules $meetingSchedules");
          update();
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
    });

    update();
  }

  handleShare(meetingSchedule) async {
    try {
      // Parse the meeting_date string to a DateTime object
      meetingDate = DateTime.parse(meetingSchedule['meeting_date']);

      if (currentDate.toString() ==
          meetingSchedule['meeting_date'].toString()) {
        // Get the day of the week
        dayOfWeek = "Today";
      } else {
        // Get the day of the week
        dayOfWeek = getDayOfWeek(meetingDate);
      }

      // Construct the message
      String message =
          "Praise the lord Saints\n\n${meetingSchedule['meeting_type'].toString()}\n\n"
          "Date : ${meetingSchedule['meeting_date'].toString()} ($dayOfWeek)\n\n"
          "Time : ${meetingSchedule['from_time'].toString()} to ${meetingSchedule['to_time'].toString()}\n\n"
          "${meetingSchedule['meeting_mode'].toString() == "1" ? "Address" : "Meeting Link"} : ${meetingSchedule['meeting_location'].toString()}";

      // Share the message
      await Share.share(message);
      update();
    } catch (e) {
      print("Error: $e");
    }
  }

  getCurrentMonthSundays() {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    // Get the first day of the current month
    DateTime firstDayOfMonth = DateTime(currentYear, currentMonth, 1);

    // Get the number of days in the current month
    int daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;

    // Loop through all the days of the current month
    for (int i = 1; i <= daysInMonth; i++) {
      DateTime date = DateTime(currentYear, currentMonth, i);

      // Check if the day is Sunday (0 = Sunday)
      if (date.weekday == DateTime.sunday) {
        // Format the date to only include the date part
        String formattedDate = Jiffy(date).format('yyyy-MM-dd');
        sundays.add(formattedDate);
      }
    }

    loadMeetingSchedules();

    update();
  }

  handleMultipleShare() async {
    log("Week Days $sundays");
    String currentMonth = Jiffy().format('MMMM');
    ; // Full month name, e.g., "January"

    String multiMsg =
        "Praise the lord saints $currentMonth month Lord's Table Meeting Schedule\n\n";
    for (int i = 0; i < meetingSchedules.length; i++) {
      log("Date is ${meetingSchedules[i]['meeting_date']}");
      // Parse the meeting_date string to a DateTime object
      meetingDate = DateTime.parse(meetingSchedules[i]['meeting_date']);

      if (currentDate.toString() ==
          meetingSchedules[i]['meeting_date'].toString()) {
        // Get the day of the week
        dayOfWeek = "Today";
      } else {
        // Get the day of the week
        dayOfWeek = getDayOfWeek(meetingDate);
      }
      if (meetingSchedules[i].toString().isNotEmpty &&
          sundays.contains(meetingSchedules[i]['meeting_date'])) {
        multiMsg +=
            "${i + 1} . (${meetingSchedules[i]['meeting_date'].toString()}) ${meetingSchedules[i]['meeting_type'].toString()}\n\n"
            "Date : ${meetingSchedules[i]['meeting_date'].toString()} ($dayOfWeek)\n\n"
            "Time : ${meetingSchedules[i]['from_time'].toString()} to ${meetingSchedules[i]['to_time'].toString()}\n\n"
            "${meetingSchedules[i]['meeting_mode'].toString() == "1" ? "Address" : "Meeting Link"} : ${meetingSchedules[i]['meeting_location'].toString()}\n\n\n";
      }
    }

    await Share.share(multiMsg);
  }

  getDayOfWeek(DateTime date) {
    // Get the weekday as a number (1 = Monday, 7 = Sunday)
    int weekday = date.weekday;

    // Map the number to the day of the week
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  void showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation Delete"),
          content: const Text("Are you sure you want to proceed?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    ).then((value) async {
      if (value == true) {
        // Action confirmed
        print("User confirmed the action");
        String apiUrl =
            'http://192.168.235.39/maintenanceApp/api/meetingScheduleDelete/$scheduleId';
        final response = await http.delete(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          if (responseBody['status'].toString() == '200') {
            Get.rawSnackbar(
                snackPosition: SnackPosition.TOP,
                message: responseBody['message'].toString());
            loadMeetingSchedules();
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
      } else {
        // Action cancelled
        print("User cancelled the action");
      }
    });

    update();
  }
}
