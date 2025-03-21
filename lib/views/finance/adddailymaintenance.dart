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
        )
    );
  }
}
