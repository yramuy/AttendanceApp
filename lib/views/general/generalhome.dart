import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/general/generalhomecontroller.dart';
import 'package:maintenanceapp/helpers/utilities.dart';
import 'package:maintenanceapp/views/attendance/attendance.dart';
import 'package:maintenanceapp/views/attendance/attendancelist.dart';
import 'package:maintenanceapp/views/attendancerecord/attendancerecord.dart';
import 'package:maintenanceapp/views/attendancerecord/attendancesummary.dart';
import 'package:maintenanceapp/views/saint/addsaint.dart';
import 'package:maintenanceapp/views/saint/saints.dart';
import '../../widgets/constants.dart';
import '../finance/monthlymaintanance.dart';

class GeneralHome extends StatefulWidget {
  const GeneralHome({super.key});

  @override
  State<GeneralHome> createState() => _GeneralHomeState();
}

class _GeneralHomeState extends State<GeneralHome> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralHomeController>(
      init: GeneralHomeController(),
      builder: (controller) {
        /// Menu IDs to hide when location ID mismatches
        final hiddenMenuIds = [
          // Add Saint
          "13", "21", "23", "41",
          // Update Attendance
          "16", "26", "32", "44", "55"
        ];

        /// Filter menus safely
        final filteredMenus = controller.submenus.where((menu) {
          if (Utilities.loginLocationID.toString() ==
              Utilities.locationID.toString()) {
            return true; // show all menus
          }
          return !hiddenMenuIds.contains(menu['id'].toString());
        }).toList();

        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              image: const DecorationImage(
                image: AssetImage('assets/images/bgimg.png'),
                alignment: Alignment.center,
                opacity: 0.05,
              ),
            ),
            child: controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.purpleAccent,
                    ),
                  )
                : filteredMenus.isNotEmpty
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredMenus.length,
                            itemBuilder: (context, index) {
                              final menu = filteredMenus[index];
                              final menuId = menu['id'].toString();

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    if (["12", "20", "22", "40"]
                                        .contains(menuId)) {
                                      Get.to(() => const Saints(), arguments: {
                                        "id": 0,
                                        "name": "",
                                        "email": "",
                                        "mobile": "",
                                        "dob": "",
                                        "age": "",
                                        "gender": "",
                                        "district": "0",
                                        "saintType": "0",
                                        "user_name": ""
                                      });
                                    } else if (["13", "21", "23", "41"]
                                        .contains(menuId)) {
                                      Get.to(() => const AddSaint(),
                                          arguments: {
                                            "id": 0,
                                            "name": "",
                                            "email": "",
                                            "mobile": "",
                                            "dob": "",
                                            "age": "",
                                            "gender": "",
                                            "district": "0",
                                            "saintType": "0",
                                            "user_name": ""
                                          });
                                    } else if (["16", "26", "32", "44"]
                                        .contains(menuId)) {
                                      Get.to(() => Attendance());
                                    } else if (["17", "27", "33", "45"]
                                        .contains(menuId)) {
                                      Get.to(() => AttendanceList());
                                    } else if (menuId == "53" &&
                                        controller.userID.toString() == "18") {
                                      Get.to(() => const MonthlyMaintenance());
                                    } else if (menuId == "54") {
                                      Get.to(() => const AttendanceSummary());
                                    } else if (menuId == "55") {
                                      Get.to(() => const AttendanceRecord());
                                    }
                                  },
                                  child: Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 25,
                                                foregroundImage: NetworkImage(
                                                  menu['img_path'].toString(),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Text(
                                                menu['name'].toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.blueAccent,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'No Menus Found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Constants.darkBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
          ),
        );
      },
    );
  }
}
