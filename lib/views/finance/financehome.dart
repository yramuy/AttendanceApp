import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/finance/financehomecontroller.dart';
import 'package:maintenanceapp/views/finance/creditwithdrawalpayment.dart';
import 'package:maintenanceapp/views/finance/paymenthistory.dart';

import '../../widgets/constants.dart';

class FinanceHome extends StatefulWidget {
  const FinanceHome({super.key});

  @override
  State<FinanceHome> createState() => _FinanceHomeState();
}

class _FinanceHomeState extends State<FinanceHome> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FinanceHomeController>(
        init: FinanceHomeController(),
        builder: (controller) => Scaffold(
              // appBar: AppBar(
              //   title: const Text(
              //     'Finance',
              //     style: TextStyle(
              //         color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   backgroundColor: const Color(0xff005F01),
              //   centerTitle: true,
              //   iconTheme: const IconThemeData(color: Colors.white),
              // ),
              body: Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/bgimg.png'),
                        alignment: Alignment.center,
                        opacity: 0.05)),
                child: controller.isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.purpleAccent,
                        ),
                      )
                    : controller.submenus.isNotEmpty
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SizedBox(
                                      child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 2,
                                            mainAxisSpacing: 2,
                                            childAspectRatio: 1),
                                    itemCount: controller.submenus.length,
                                    itemBuilder: (BuildContext context, index) {
                                      // var menuData = jsonDecode(controller.menus.toString());
                                      return GestureDetector(
                                        onTap: () {
                                          if (controller.submenus[index]['id']
                                                  .toString() ==
                                              "4" || controller.submenus[index]['id']
                                                  .toString() ==
                                              "48") {
                                            Get.to(() =>
                                                const CreditWithdrawalPayment());
                                          } else if(controller.submenus[index]['id']
                                              .toString() ==
                                              "5" || controller.submenus[index]['id']
                                              .toString() ==
                                              "49"){
                                            Get.to(() => const PaymentHistory());
                                          }
                                        },
                                        child: Card(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              CircleAvatar(
                                                radius: 30,
                                                foregroundImage: NetworkImage(
                                                    controller.submenus[index]
                                                            ['img_path']
                                                        .toString(),
                                                    scale: 40),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  controller.submenus[index]
                                                          ['name']
                                                      .toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                                )
                              ],
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Text(
                              'No Menus Found',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Constants.darkBlue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
              ),
            ));
  }
}
