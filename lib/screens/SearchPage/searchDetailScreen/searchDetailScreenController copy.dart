import 'package:bbangnarae_frontend/screens/SearchPage/searchScreenController.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchDetailScreenController extends GetxController {
  // var recentSearchTerms = [].obs;
  // late final TextEditingController termTextcontroller;
  late final Rx<TextEditingController> termTextcontroller;
  late final RxBool hasTermText;
  @override
  void onInit() {
    termTextcontroller =
        TextEditingController(text: Get.arguments['searchTerm'] ?? '').obs;
    if (termTextcontroller.value.text.length > 0) {
      hasTermText = true.obs;
    } else {
      hasTermText = false.obs;
    }

    termTextcontroller.value.selection =
        TextSelection.collapsed(offset: termTextcontroller.value.text.length);
    super.onInit();
  }

  @override
  void onClose() {
    print("SearchDetailScreenController Dispose!");
    super.onClose();
  }
}
