import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BooksOrderController extends GetxController {
  final TextEditingController nameController = TextEditingController();

  String? selectedUserName;
  int? selectedUserId;
  List userData = [];
  List filteredUserData = [];
  bool isTelSelected = false;
  bool isEngSelected = false;
  int telVal = 0;
  int engVal = 0;
  TextEditingController telvalController = TextEditingController();
  TextEditingController engvalController = TextEditingController();
  TextEditingController mbController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserData();
  }

  getUserData() {
    userData = [];
    filteredUserData = [
      {'id': 1, 'name': 'John Doe'},
      {'id': 2, 'name': 'Jane Smith'},
      {'id': 3, 'name': 'Michael Johnson'},
      {'id': 4, 'name': 'Emily Davis'},
    ];

    update();
  }

  onSearchChanged() {
    userData = [];
    if (nameController.text.isNotEmpty) {
      userData = filteredUserData
          .where((user) => user['name']
              .toLowerCase()
              .contains(nameController.text.toLowerCase()))
          .toList();
    } else {
      userData = [];
    }
    update();
  }

  updateData(data) {
    selectedUserName = data['name'];
    selectedUserId = data['id'];
    nameController.text = selectedUserName!;
    userData = [];

    print('Selected User ID: $selectedUserId');

    update();
  }

  void handleCheckbox(bool? value, String checkbox) {
    if (checkbox.toString() == "Tel") {
      isTelSelected = value ?? false;
      telVal = isTelSelected ? 1 : 0;
      telvalController.text = "";
    } else {
      isEngSelected = value ?? false;
      engVal = isEngSelected ? 2 : 0;
      engvalController.text = "";
    }

    print("Tel : $telVal");
    print("Eng : $engVal");
    update();
  }
}
