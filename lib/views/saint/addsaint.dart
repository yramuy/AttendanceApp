import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/saints/addsaintcontroller.dart';
import 'package:maintenanceapp/widgets/constants.dart';

class AddSaint extends StatefulWidget {
  const AddSaint({super.key});

  @override
  State<AddSaint> createState() => _AddSaintState();
}

class _AddSaintState extends State<AddSaint> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSaintController>(
        init: AddSaintController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                    controller.saintID.toString() != '0'
                        ? "Edit Saint"
                        : "Add Saint",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: const Color(0xFF2c2cff),
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
              body: SafeArea(
                bottom: true,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      image: const DecorationImage(
                          alignment: Alignment.center,
                          image: AssetImage('assets/images/bgimg.png'),
                          opacity: 0.05)),
                  child: Card(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Form(
                          key: controller.saintFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Saint Name",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: controller.name,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 15, bottom: 10),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
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
                                      return "Saint name is required";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: controller.email,
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
                                    // if (value!.isEmpty) {
                                    //   return "Email is required";
                                    // }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Mobile Number",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: controller.mobile,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'^\+?[0-9]*$')), // Allow only numbers and + at start
                                  ],
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
                                      return "Mobile number is required";
                                    } else if (value.toString().length < 10) {
                                      return "The mobile number should be exactly 10 digits long.";
                                    } else if (value.toString().length > 15) {
                                      return "A mobile number is allowed up to 14 digits, including the country code.";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Username",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: controller.username,
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
                                    // if (value!.isEmpty) {
                                    //   return "Username is required";
                                    // }

                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Password",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: controller.password,
                                  obscureText: controller.showPassword,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 15, bottom: 10),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 1)),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            controller.showPassword =
                                                !controller.showPassword;
                                            controller.update();
                                          },
                                          icon: controller.showPassword
                                              ? Icon(
                                                  Icons.visibility_off,
                                                  color: Constants.appBarColor,
                                                )
                                              : Icon(
                                                  Icons.visibility,
                                                  color: Constants.appBarColor,
                                                ))),
                                  validator: (value) {
                                    if (value!.isEmpty &&
                                        controller.saintID.toString().isEmpty) {
                                      return "Password is required";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Gender",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: const Text("Male"),
                                      leading: Radio<String>(
                                          value: "1",
                                          groupValue: controller.gender,
                                          onChanged: (String? value) {
                                            controller.handleRadioButton(value);
                                          }),
                                    ),
                                  ),
                                  Expanded(
                                      child: ListTile(
                                    title: const Text("Female"),
                                    leading: Radio(
                                        value: "2",
                                        groupValue: controller.gender,
                                        onChanged: (String? value) {
                                          controller.handleRadioButton(value);
                                        }),
                                  ))
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Date of Birth",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.only(
                                      left: 18, bottom: 10),
                                  leading: Text(
                                    controller.dob,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: IconButton(
                                      alignment: Alignment.topCenter,
                                      iconSize: 25,
                                      onPressed: () {
                                        controller.datePicker(context);
                                      },
                                      icon: const Icon(
                                        Icons.calendar_month_rounded,
                                        color: Color(0xff005F01),
                                      )),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Role",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: DropdownButtonFormField(
                                  value: controller.roleId != null &&
                                          controller.roleId.toString() != '0'
                                      ? controller.roleId.toString()
                                      : null, // Default to null if no valid selection
                                  isExpanded: true,
                                  isDense: true,
                                  hint: const Text("--Select--"),
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 10, bottom: 10),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none)),
                                  items: controller.roles.map((e) {
                                    log("RoleID is ${controller.roleId}");
                                    return DropdownMenuItem(
                                      value: e['config_id'].toString(),
                                      child: Text(e['name'].toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.roleId = value.toString();
                                    controller.update();
                                  },
                                  validator: (value) {
                                    if (value == "") {
                                      return "Role is required";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Location",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButtonFormField(
                                  // value: controller.districtId,
                                  value: controller.locationID.toString() != ''
                                      ? controller.locationID.toString()
                                      : null, // Default to null if no valid selection
                                  isExpanded: true,
                                  isDense: true,
                                  hint: const Text("--Select--"),
                                  decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 1)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFd2d2d2),
                                            width: 1.5)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFd2d2d2),
                                            width: 1.5)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFd2d2d2),
                                            width: 1.5)),
                                  ),

                                  items: controller.locations.map((e) {
                                    return DropdownMenuItem(
                                      value: e['id'].toString(),
                                      child: Text(e['name'].toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.locationID = value.toString();
                                    controller.loadDistricts(value);
                                    controller.update();
                                  },
                                  validator: (value) {
                                    if (controller.locationID.toString() ==
                                        "") {
                                      return "Location is required";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Districts",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButtonFormField(
                                  // value: controller.districtId,
                                  value: controller.districtId.toString() != '0'
                                      ? controller.districtId.toString()
                                      : null, // Default to null if no valid selection
                                  isExpanded: true,
                                  isDense: true,
                                  hint: const Text("--Select--"),
                                  decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 1)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFd2d2d2),
                                            width: 1.5)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFd2d2d2),
                                            width: 1.5)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFd2d2d2),
                                            width: 1.5)),
                                  ),

                                  items: controller.districts.map((e) {
                                    return DropdownMenuItem(
                                      value: e['config_id'].toString(),
                                      child: Text(e['name'].toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.districtId = value.toString();
                                    controller.update();
                                  },
                                  validator: (value) {
                                    if (controller.districtId.toString() ==
                                        "0") {
                                      return "District is required";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Category",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButtonFormField(
                                  // value: controller.saintType,
                                  value: controller.saintType.toString() != '0'
                                      ? controller.saintType.toString()
                                      : null, // Default to null if no valid selection
                                  isExpanded: true,
                                  hint: const Text("--Select--"),
                                  decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 1)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFd2d2d2),
                                            width: 1.5)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFd2d2d2),
                                            width: 1.5)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFd2d2d2),
                                            width: 1.5)),
                                  ),
                                  items: controller.saintTypes.map((e) {
                                    return DropdownMenuItem(
                                      value: e['config_id'].toString(),
                                      child: Text(e['name'].toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.saintType = value.toString();
                                  },
                                  validator: (value) {
                                    if (controller.saintType.toString() ==
                                        "0") {
                                      return "Category is required";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Clasification",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButtonFormField(
                                  // value: controller.saintType,
                                  value: controller.classificationID
                                              .toString() !=
                                          '0'
                                      ? controller.classificationID.toString()
                                      : null, // Default to null if no valid selection
                                  isExpanded: true,
                                  hint: const Text("--Select--"),
                                  decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 1)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFd2d2d2),
                                            width: 1.5)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFd2d2d2),
                                            width: 1.5)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFd2d2d2),
                                            width: 1.5)),
                                  ),
                                  items: controller.clasifications.map((e) {
                                    return DropdownMenuItem(
                                      value: e['config_id'].toString(),
                                      child: Text(e['name'].toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.classificationID =
                                        value.toString();
                                  },
                                  validator: (value) {
                                    if (controller.classificationID
                                            .toString() ==
                                        "0") {
                                      return "Classification is required";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              // const Padding(
                              //   padding: EdgeInsets.all(10),
                              //   child: Text(
                              //     "Saint Status",
                              //     style: TextStyle(
                              //         fontSize: 16, color: Colors.black),
                              //   ),
                              // ),
                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(10),
                              //       border:
                              //       Border.all(color: Colors.grey, width: 1)),
                              //   child: DropdownButtonFormField(
                              //     // value: controller.saintType,
                              //     value: controller.saintStatus.toString(), // Default to null if no valid selection
                              //     isExpanded: true,
                              //     hint: const Text("--Select--"),
                              //     decoration: const InputDecoration(
                              //         contentPadding:
                              //         EdgeInsets.only(left: 10, bottom: 10),
                              //         border: OutlineInputBorder(
                              //             borderSide: BorderSide.none)),
                              //     items: controller.status.map((e) {
                              //       return DropdownMenuItem(
                              //         value: e['id'].toString(),
                              //         child: Text(e['name'].toString()),
                              //       );
                              //     }).toList(),
                              //     onChanged: (value) {
                              //       controller.saintStatus = value.toString();
                              //       controller.update();
                              //     },
                              //     validator: (value) {
                              //       if (value.toString() == "--Select--") {
                              //         return "Saint Type is required";
                              //       }
                              //
                              //       return null;
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Wrap(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: Platform.isAndroid
                            ? MediaQuery.of(context).padding.bottom
                            : 0),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      padding:
                          EdgeInsets.only(bottom: Platform.isAndroid ? 0 : 20),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (controller.saintFormKey.currentState!
                                  .validate()) {
                                if (controller.districtId.toString() == "0") {
                                  Get.rawSnackbar(
                                      snackPosition: SnackPosition.TOP,
                                      message: "District is required");
                                } else {
                                  controller.handleSave();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: Text(
                              controller.saintID.toString() != '0'
                                  ? "Update"
                                  : "Save",
                              style: const TextStyle(color: Colors.white),
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
                                backgroundColor: CupertinoColors.systemGrey),
                            child: const Text("Cancel",
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ));
  }
}
