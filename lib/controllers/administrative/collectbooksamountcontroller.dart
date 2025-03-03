import 'dart:convert';

import 'package:get/get.dart';

class CollectBooksAmountController extends GetxController {
  List booksOrder = [];
  Map<int, bool> isToggled = {};
  String? saintID = '0';
  bool isPresent = false; // Default state

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  loadData() {
    booksOrder = [
      {
        "id": 1,
        "name": "John",
        "mrbTel": 2,
        "mrbEng": 1,
        "mrbPrice": 110,
        "mb": 1,
        "mbPrice": 200
      },
      {
        "id": 2,
        "name": "Maharajahs",
        "mrbTel": 1,
        "mrbEng": 1,
        "mrbPrice": 110,
        "mb": 0,
        "mbPrice": 0
      },
      {
        "id": 3,
        "name": "Issac",
        "mrbTel": 2,
        "mrbEng": 1,
        "mrbPrice": 110,
        "mb": 2,
        "mbPrice": 0
      },
      {
        "id": 4,
        "name": "Archenemy",
        "mrbTel": 2,
        "mrbEng": 1,
        "mrbPrice": 110,
        "mb": 2,
        "mbPrice": 0
      },
      {
        "id": 5,
        "name": "Daniel",
        "mrbTel": 8,
        "mrbEng": 3,
        "mrbPrice": 110,
        "mb": 5,
        "mbPrice": 280
      }
    ];
    for (int i = 0; i < booksOrder.length; i++) {
      isToggled[i] = false;
    }
    update();
  }

  int countBooks(String tel, String eng, String mrbPrice) {
    var num1 = int.tryParse(tel) ?? 0;
    var num2 = int.tryParse(eng) ?? 0;
    var num3 = int.tryParse(mrbPrice) ?? 0;

    var sum = num1 + num2;
    var total = sum * num3;
    return total;
  }

  int countMBTotal(String mb, String mbPrice) {
    var mbVal = int.tryParse(mb);
    var mbPriceVal = int.tryParse(mbPrice);
    var total = mbVal! * mbPriceVal!;

    return total;
  }

  void handleToggle(int index, bool value) {
    isToggled[index] = value;
    update();
  }
}
