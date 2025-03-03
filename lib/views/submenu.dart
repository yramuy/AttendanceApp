import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/submenucontroller.dart';

class SubMenu extends StatefulWidget {
  const SubMenu({super.key});

  @override
  State<SubMenu> createState() => _SubMenuState();
}

class _SubMenuState extends State<SubMenu> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubMenuController>(
        init: SubMenuController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                  child: const Icon(Icons.arrow_back_ios),
                  onTap: () {
                    // controller.navigateTo();
                  },
                ),
                backgroundColor: const Color(0xff005F01),
                iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                title: Text(
                  controller.menuName,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/bgimg.png'),
                        alignment: Alignment.center,
                        opacity: 0.05)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2,
                                    childAspectRatio: 1),
                            itemCount: controller.menus.length,
                            itemBuilder: (BuildContext context, index) {
                              return GestureDetector(
                                onTap: () {
                                  log("selected menu ");
                                  log(controller.menus[index]['id'].toString());
                                  // Get.to(() => const SubMenu(), arguments: [
                                  //   controller.menus[index]['id'].toString(),
                                  //   controller.menus[index]['name'].toString()
                                  // ]);
                                  // controller.getSubMenuData(controller.menus[index]['id'].toString(),controller.menus[index]['name'].toString(),'child');
                                },
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CircleAvatar(
                                        radius: 30,
                                        foregroundImage: NetworkImage(
                                            controller.menus[index]['img_path']
                                                .toString(),
                                            scale: 40),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          controller.menus[index]['name']
                                              .toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
