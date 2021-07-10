import 'package:bbangnarae_frontend/screens/SearchPage/searchScreenController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchDetailScreenController extends SearchScreenController
    with SingleGetTickerProviderMixin {
  // SearchDetailScreenController(this.termTextController, this.hasTermText)
  //     : super();

  final Rx<TextEditingController> termTextController =
      SearchScreenController.to.termTextController;
  final RxBool hasTermText = SearchScreenController.to.hasTermText;
  late final TabController tabController;
  @override
  void onInit() {
    // termTextController =
    // hasTermText
    tabController = TabController(length: 3, vsync: this);

    super.onInit();
  }

  @override
  void onClose() {
    print("SearchDetailScreenController Dispose!");
    super.onClose();
  }
}
