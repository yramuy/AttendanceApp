import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/myprofilecontroller.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyProfileController>(
        init: MyProfileController(),
        builder: (controller) => Scaffold(
              body: Container(
                // height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.3),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/bgimg.png'),
                        alignment: Alignment.center,
                        opacity: 0.05)),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        radius: 80,
                        foregroundImage: NetworkImage(
                            controller.imagePath.toString(),
                            scale: 50),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(left: 50),
                      //   child: IconButton(
                      //       onPressed: (){},
                      //       icon: Icon(Icons.edit)
                      //   ),
                      // ),

                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.purple.shade200,
                                  blurRadius: 10,
                                  spreadRadius: 2),
                            ]),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: controller.userName,
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Inter-Medium',
                                color: Colors.purple,
                              ),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.purple,
                              )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.purple.shade200,
                                  blurRadius: 10,
                                  spreadRadius: 2),
                            ]),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: controller.userEmail,
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Inter-Medium',
                                color: Colors.purple,
                              ),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.purple,
                              )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.purple.shade200,
                                  blurRadius: 10,
                                  spreadRadius: 2),
                            ]),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: controller.userPhone,
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Inter-Medium',
                                color: Colors.purple,
                              ),
                              prefixIcon: const Icon(
                                Icons.phone,
                                color: Colors.purple,
                              )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.purple.shade200,
                                  blurRadius: 10,
                                  spreadRadius: 2),
                            ]),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: controller.userRole,
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Inter-Medium',
                                color: Colors.purple,
                              ),
                              prefixIcon: const Icon(
                                Icons.verified_user,
                                color: Colors.purple,
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.clearData();
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.purple.shade200,
                                    blurRadius: 10,
                                    spreadRadius: 2)
                              ]),
                          child: const TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Logout",
                                hintStyle: TextStyle(
                                    fontFamily: 'Inter-Medium',
                                    color: Colors.purple,
                                    fontSize: 16),
                                prefixIcon: Icon(
                                  Icons.exit_to_app,
                                  color: Colors.purple,
                                )),
                          ),
                        ),
                      ),
                      // Card(
                      //   elevation: 50,
                      //   shadowColor: Colors.blueAccent,
                      //   color: const Color(0xFF024702),
                      //   child: SizedBox(
                      //     width: 300,
                      //     height: 300,
                      //     child: Column(
                      //       children: [
                      //         // Table(
                      //         //   children: [
                      //         //     TableRow(children: [
                      //         //       const TableCell(
                      //         //           child: Padding(
                      //         //             padding: EdgeInsets.all(15.0),
                      //         //             child: Text(
                      //         //               'Name',
                      //         //               style: TextStyle(
                      //         //                   fontWeight: FontWeight.bold,color: Colors.white),
                      //         //             ),
                      //         //           )),
                      //         //       TableCell(
                      //         //           child: Padding(
                      //         //             padding: const EdgeInsets.all(15.0),
                      //         //             child: Text(controller.userName.toString(), style: TextStyle(color: Colors.white),),
                      //         //           )),
                      //         //     ]),
                      //         //     TableRow(children: [
                      //         //       TableCell(
                      //         //           child: Padding(
                      //         //             padding: EdgeInsets.all(15.0),
                      //         //             child: Text(
                      //         //               'Email',
                      //         //               style: TextStyle(
                      //         //                   fontWeight: FontWeight.bold,color: Colors.white),
                      //         //             ),
                      //         //           )),
                      //         //       TableCell(
                      //         //           child: Padding(
                      //         //             padding: EdgeInsets.all(15.0),
                      //         //             child: Text(controller.userEmail.toString(), style: TextStyle(color: Colors.white),),
                      //         //           )),
                      //         //     ]),
                      //         //     TableRow(children: [
                      //         //       TableCell(
                      //         //           child: Padding(
                      //         //             padding: EdgeInsets.all(15.0),
                      //         //             child: Text(
                      //         //               'Mobile Number',
                      //         //               style: TextStyle(
                      //         //                   fontWeight: FontWeight.bold,color: Colors.white),
                      //         //             ),
                      //         //           )),
                      //         //       TableCell(
                      //         //           child: Padding(
                      //         //             padding: EdgeInsets.all(15.0),
                      //         //             child: Text(controller.userPhone.toString(), style: TextStyle(color: Colors.white),),
                      //         //           )),
                      //         //     ]),
                      //         //     TableRow(children: [
                      //         //       TableCell(
                      //         //           child: Padding(
                      //         //             padding: EdgeInsets.all(15.0),
                      //         //             child: Text(
                      //         //               'User Role',
                      //         //               style: TextStyle(
                      //         //                   fontWeight: FontWeight.bold,color: Colors.white),
                      //         //             ),
                      //         //           )),
                      //         //       TableCell(
                      //         //           child: Padding(
                      //         //             padding: EdgeInsets.all(15.0),
                      //         //             child: Text(controller.userRole.toString(), style: TextStyle(color: Colors.white),),
                      //         //           )),
                      //         //     ]),
                      //         //   ],
                      //         // ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
