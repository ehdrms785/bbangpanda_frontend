import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SearchScreenController extends GetxController {
  // SearchScreenController(this.termTextController, this.hasTermText);
  var recentSearchTerms = [].obs;
  late final Rx<TextEditingController> termTextController;
  late final RxBool hasTermText;

  static SearchScreenController get to => Get.find();
  @override
  void onInit() {
    termTextController = TextEditingController().obs;
    hasTermText = false.obs;

    recentSearchTerms.addAll(Hive.box('cache').get('recentSearchTerms') ?? []);
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void clearRecentSearchTerm() {
    recentSearchTerms.clear();
    Hive.box('cache').put('recentSearchTerms', recentSearchTerms);
  }

  void updateRecentSearchTerm() {
    if (recentSearchTerms.length > 6) {
      recentSearchTerms.removeAt(0);
    }
    recentSearchTerms.add(termTextController.value.text);

    recentSearchTerms.refresh();
    this.update();
    Hive.box('cache').put('recentSearchTerms', recentSearchTerms);
  }

  // 이 메서드를 따로 만들어주는 이유는
  // SearchDetail로 넘어가서 RecentSearchTerm을 추가 했을 경우에
  // Get.back()을 했을 때 그 결과 값이 반환이 되지 않더라..
  // 그래서 이렇게 refresh를 해 주는 방법을 사용했다
  void refreshRecentSearchTerm() {
    termTextController.value.clear();
    recentSearchTerms.clear();
    recentSearchTerms.addAll(Hive.box('cache').get('recentSearchTerms'));
  }
}
