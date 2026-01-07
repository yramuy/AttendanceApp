import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/saints/saintscontroller.dart';
import 'package:maintenanceapp/helpers/utilities.dart';
import 'package:maintenanceapp/views/bottompages/bottomnavigationbar.dart';
import 'package:maintenanceapp/views/homescreen.dart';
import 'package:maintenanceapp/views/saint/addsaint.dart';
import 'package:maintenanceapp/widgets/constants.dart';

class Saints extends StatefulWidget {
  const Saints({super.key});

  @override
  State<Saints> createState() => _SaintsState();
}

class _SaintsState extends State<Saints> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaintsController>(
        init: SaintsController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                title: const Text("Saints",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                centerTitle: true,
                backgroundColor: const Color(0xff004cf1),
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
                  Utilities.locationID.toString() ==
                          Utilities.loginLocationID.toString()
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: IconButton(
                              onPressed: () {
                                Get.to(() => const AddSaint(), arguments: {
                                  "id": 0,
                                  "name": "",
                                  "email": "",
                                  "mobile": "",
                                  "dob": "",
                                  "age": "",
                                  "gender": "",
                                  "district": "",
                                  "saintType": "",
                                  "user_name": ""
                                });
                              },
                              icon: Icon(
                                Icons.person_add_alt_1,
                                size: 35,
                              )),
                        )
                      : Container(),
                  IconButton(
                      onPressed: () {
                        Get.offAll(() => const BottomNavigationTileScreen());
                      },
                      icon: Icon(
                        Icons.home_outlined,
                        size: 35,
                        color: Colors.white,
                      ))
                ],
              ),
              body: controller.isLoading == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.purpleAccent,
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 1,
                      // decoration: BoxDecoration(
                      //     color: Colors.green.withOpacity(0.3),
                      //     image: const DecorationImage(
                      //         image: AssetImage('assets/images/bgimg.png'),
                      //         alignment: Alignment.center,
                      //         opacity: 0.05)),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    height: 70,
                                    child: DropdownButtonFormField(
                                      isDense: true,
                                      isExpanded: true,
                                      hint: const Text("All Districts"),
                                      value: controller.districtId,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      items: controller.districts.map((e) {
                                        return DropdownMenuItem(
                                          value: e['id'].toString(),
                                          child: Text(e['name'].toString()),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        controller.districtId =
                                            value.toString();
                                        controller.handleOnchange();
                                        controller.update();
                                        print(value.toString());
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        5), // Added spacing between TextFormFields
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    // height: 70,
                                    child: DropdownButtonFormField(
                                      dropdownColor: Colors.white,
                                      isExpanded: true,
                                      isDense: true,
                                      hint: const Text("-- Category --"),
                                      value: controller.typeId.toString(),
                                      decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                      items: controller.saintTypes.map((e) {
                                        return DropdownMenuItem(
                                          value: e['id'].toString(),
                                          child: Text(e['name'].toString()),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        controller.typeId = value.toString();
                                        controller.handleOnchange();
                                        controller.update();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: controller.dist ? true : false,
                              child: Card(
                                margin: EdgeInsets.all(10),
                                elevation: 10,
                                shadowColor: Colors.blueGrey,
                                surfaceTintColor: Colors.grey,
                                child: DataTable(
                                  columnSpacing: 10,
                                  horizontalMargin: 20,
                                  dataRowMinHeight: 60,
                                  dataRowMaxHeight: 60,
                                  columns: [
                                    DataColumn(
                                        label: SizedBox(
                                      width: 55,
                                      child: Text('Total Saints',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Inter-Medium",
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                    DataColumn(
                                        label: SizedBox(
                                      width: 55,
                                      child: Text('General Saints',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Inter-Medium",
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                    DataColumn(
                                        label: SizedBox(
                                      width: 55,
                                      child: Text('Working Saints',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Inter-Medium",
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                    DataColumn(
                                        label: SizedBox(
                                      width: 55,
                                      child: Text("Collage Students",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Inter-Medium",
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                    DataColumn(
                                        label: SizedBox(
                                      width: 55,
                                      child: Text("Teenagers",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Inter-Medium",
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                  ],
                                  rows: [
                                    DataRow(cells: [
                                      DataCell(Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                            controller.totalSaints.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Inter-Medium",
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                      DataCell(Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            controller.generalSaints.toString(),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontFamily: "Inter-Medium",
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                      DataCell(Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            controller.workingSaints.toString(),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontFamily: "Inter-Medium",
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                      DataCell(Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            controller.youngOnes.toString(),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontFamily: "Inter-Medium",
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                      DataCell(Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            controller.teenagers.toString(),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontFamily: "Inter-Medium",
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                    ])
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: controller.type ? true : false,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Total Saints : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(controller.totalSaints.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 1,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: TextFormField(
                                controller: controller.searchController,
                                decoration: InputDecoration(
                                  hintText: "Search by name, district",
                                  hintStyle: TextStyle(fontSize: 14),
                                  contentPadding:
                                      EdgeInsets.only(bottom: 10, left: 10),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  suffixIcon:
                                      controller.searchController.text.isEmpty
                                          ? Icon(
                                              Icons.search_outlined,
                                              color: Colors.grey,
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                controller.loadSaints();
                                                controller.searchController
                                                    .clear(); // Clear the text
                                                controller
                                                    .update(); // Update the UI
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                            ),
                                ),
                                onChanged: (value) {
                                  controller.handleSearch(value);
                                },
                              ),
                            ),
                            controller.saints.isNotEmpty
                                ? ListView.builder(
                                    physics: const ScrollPhysics(),
                                    itemCount: controller.saints.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        // height: 350,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        padding: const EdgeInsets.all(10),
                                        margin: const EdgeInsets.all(10),
                                        // decoration: BoxDecoration(
                                        //   borderRadius: BorderRadius.circular(10),
                                        //   color: const Color(0xff005F01)
                                        //       .withOpacity(0.6),
                                        // ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.green.shade500,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.purple.shade200,
                                                  blurRadius: 10,
                                                  spreadRadius: 2),
                                            ]),
                                        child: Table(
                                          columnWidths: const {
                                            0: FlexColumnWidth(15),
                                            1: FlexColumnWidth(10)
                                          },
                                          children: [
                                            TableRow(children: [
                                              const TableCell(
                                                  child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Name",
                                                  style: Constants.myTextStyle,
                                                ),
                                              )),
                                              TableCell(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  controller.saints[index]
                                                          ['name']
                                                      .toString(),
                                                  style: Constants.myTextStyle,
                                                ),
                                              ))
                                            ]),
                                            // TableRow(children: [
                                            //   const TableCell(
                                            //       child: Padding(
                                            //     padding: EdgeInsets.all(8),
                                            //     child: Text(
                                            //       "Email",
                                            //       style: Constants.myTextStyle,
                                            //     ),
                                            //   )),
                                            //   TableCell(
                                            //       child: Padding(
                                            //     padding:
                                            //         const EdgeInsets.all(8),
                                            //     child: Text(
                                            //       controller.saints[index]
                                            //               ['email']
                                            //           .toString(),
                                            //       style: Constants.myTextStyle,
                                            //     ),
                                            //   ))
                                            // ]),
                                            TableRow(children: [
                                              const TableCell(
                                                  child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  "Mobile Number",
                                                  style: Constants.myTextStyle,
                                                ),
                                              )),
                                              TableCell(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                  controller.saints[index]
                                                          ['mobile']
                                                      .toString(),
                                                  style: Constants.myTextStyle,
                                                ),
                                              ))
                                            ]),
                                            // TableRow(children: [
                                            //   const TableCell(
                                            //       child: Padding(
                                            //     padding: EdgeInsets.all(8),
                                            //     child: Text(
                                            //       "Gender",
                                            //       style: Constants.myTextStyle,
                                            //     ),
                                            //   )),
                                            //   TableCell(
                                            //       child: Padding(
                                            //     padding: const EdgeInsets.all(8),
                                            //     child: Text(
                                            //       controller.saints[index]['gender']
                                            //           .toString(),
                                            //       style: Constants.myTextStyle,
                                            //     ),
                                            //   ))
                                            // ]),
                                            // TableRow(children: [
                                            //   const TableCell(
                                            //       child: Padding(
                                            //     padding: EdgeInsets.all(8),
                                            //     child: Text(
                                            //       "DOB",
                                            //       style: Constants.myTextStyle,
                                            //     ),
                                            //   )),
                                            //   TableCell(
                                            //       child: Padding(
                                            //     padding: const EdgeInsets.all(8),
                                            //     child: Text(
                                            //       controller.saints[index]['dob']
                                            //           .toString(),
                                            //       style: Constants.myTextStyle,
                                            //     ),
                                            //   ))
                                            // ]),
                                            TableRow(children: [
                                              const TableCell(
                                                  child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  "District",
                                                  style: Constants.myTextStyle,
                                                ),
                                              )),
                                              TableCell(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                  controller.saints[index]
                                                          ['district']
                                                      .toString(),
                                                  style: Constants.myTextStyle,
                                                ),
                                              ))
                                            ]),
                                            // TableRow(children: [
                                            //   const TableCell(
                                            //       child: Padding(
                                            //     padding: EdgeInsets.all(8),
                                            //     child: Text(
                                            //       "Category",
                                            //       style: Constants.myTextStyle,
                                            //     ),
                                            //   )),
                                            //   TableCell(
                                            //       child: Padding(
                                            //     padding:
                                            //         const EdgeInsets.all(8),
                                            //     child: Text(
                                            //       controller.saints[index]
                                            //               ['saintType']
                                            //           .toString(),
                                            //       style: Constants.myTextStyle,
                                            //     ),
                                            //   ))
                                            // ]),
                                            TableRow(children: [
                                              const TableCell(child: Text("")),
                                              TableCell(
                                                  child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white70),
                                                    height: 40,
                                                    width: 40,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          Get.to(
                                                              () =>
                                                                  const AddSaint(),
                                                              arguments:
                                                                  controller
                                                                          .saints[
                                                                      index]);
                                                        },
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          color: Colors.black,
                                                          size: 25,
                                                        )),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.red),
                                                    height: 40,
                                                    width: 40,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          controller.saintID =
                                                              controller
                                                                  .saints[index]
                                                                      ['id']
                                                                  .toString();
                                                          controller.saintName =
                                                              controller
                                                                  .saints[index]
                                                                      ['name']
                                                                  .toString();
                                                          controller
                                                              .showConfirmDialog(
                                                                  context);
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete_rounded,
                                                          color: Colors.white70,
                                                          size: 25,
                                                        )),
                                                  ),
                                                ],
                                              ))
                                            ])
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.3),
                                    child: const Text(
                                      "No records found",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
            ));
  }
}
