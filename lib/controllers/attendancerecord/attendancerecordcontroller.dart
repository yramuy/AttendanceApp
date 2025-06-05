import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import '../../apiservice/restapi.dart';
import 'package:intl/intl.dart';

class AttendanceRecordController extends GetxController {
  final List<String> headers = [
    'Sno',
    'Saint Name',
    'Category',
    'Service',
    'Shephred',
    'Going Out for Fruit Bearing',
    'Going Out for Shepherding (Shepherd)',
    'Joined Home Meeting (Sheep)',
    'Small Group Meeting',
    'Life Study M1',
    'Life Study M2',
    'Prayer Meeting',
    'Lords Table Meeting',
  ];

  List saints = [];
  String districtId = "0";
  String districtName = "AGP";
  String typeId = "0";

  int checkboxStartIndex = 4;

  // Each row has 3 booleans (Sunday, Tuesday, Friday)
  List<List<bool>> checkboxes = [];
  bool isChecked = false;
  Map<int, bool> isFruitBearing = {};
  Map<int, bool> isShepherding = {};
  Map<int, bool> isHomeMeeting = {};
  Map<int, bool> isGroupMeetig = {};
  Map<int, bool> isM1 = {};
  Map<int, bool> isM2 = {};
  Map<int, bool> isPrayerMeeting = {};
  Map<int, bool> isTableMeeting = {};
  int selectedIndex = 0;
  bool isLoading = false;
  List weekDates = [];

  @override
  void onInit() {
    super.onInit();
    updateAttendanceSheet(selectedIndex);
    getCurrentWeekDates();
    // print(currentWeek[0]); // prints yyyy-MM-dd
    // for (var date in currentWeek) {
    //   print(date.toString().split(' ')[0]); // prints yyyy-MM-dd
    // }
    loadSaints();
  }

  getCurrentWeekDates() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday; // 1 = Monday, 7 = Sunday
    DateTime monday = now.subtract(Duration(days: currentWeekday - 1));

    weekDates = List.generate(7, (index) {
      DateTime day = monday.add(Duration(days: index));
      return DateFormat("MM-dd-yyy").format(day);
      // DateFormat('yyyy-MM-dd').format(day);
    });

    print("weekDates $weekDates");
    // return weekDates;
  }

  updateAttendanceSheet(index) {
    selectedIndex = index;
    update();
    if (index == 0) {
      districtId = "1";
      districtName = "AGP";
      update();
    } else if (index == 1) {
      districtId = "2";
      districtName = "GWK";
      update();
    } else if (index == 2) {
      districtId = "4";
      districtName = "CITY";
      update();
    } else {
      districtId = "3";
      districtName = "AKP";
      update();
    }
    loadSaints();
    update();
  }

  loadSaints() async {
    log("District $districtId");
    if (selectedIndex == 0) {
      isLoading = true;
    }
    final body = jsonEncode({
      "districtId": districtId.toString(),
      "typeId": typeId,
      "date": "",
      "meetingType": ""
    });
    log("Encode Body $body");
    await ApiService.post("saints", body).then((success) {
      if (success.statusCode == 200) {
        var responseBody = jsonDecode(success.body);
        if (responseBody['status'].toString() == '200') {
          // log("responseBody $responseBody");
          saints = responseBody['saints'];
          if (selectedIndex == 0) {
            isLoading = false;
          }

          log("Saints $saints");

          checkboxes =
              List.generate(saints.length, (_) => [false, false, false]);

          // isLoading = false;
          // Get.rawSnackbar(
          //     snackPosition: SnackPosition.TOP,
          //     message: responseBody['message'].toString());
          update();
        } else {
          if (selectedIndex == 0) {
            isLoading = false;
          }
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
    update();
  }

  loadData() {
    // saints = scontroller.saints;
    update();
  }
  //   return DataColumn(
  //     label: Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.black26),
  //       ),
  //       padding: EdgeInsets.all(8),
  //       child: Text(
  //         text,
  //         style: TextStyle(
  //             color: Colors.black,
  //             fontFamily: "Inter-Medium",
  //             fontSize: 14,
  //             fontWeight: FontWeight.bold),
  //       ),
  //     ),
  //   );
  // }

  // DataCell buildCell(String text) {
  //   return DataCell(
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.black26),
  //       ),
  //       padding: EdgeInsets.all(8),
  //       child: Text(
  //         text,
  //         style: TextStyle(fontSize: 13),
  //       ),
  //     ),
  //   );
  // }
}
