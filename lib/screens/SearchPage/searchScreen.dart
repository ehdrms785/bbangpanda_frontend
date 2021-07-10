import 'package:bbangnarae_frontend/screens/SearchPage/searchDetailScreen/searchDetailScreen.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchDetailScreen/searchDetailScreenController.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchScreenController.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchScreenSharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchPage extends GetView<SearchScreenController> {
  @override
  Widget build(BuildContext context) {
    print("어딘지 알아보자 0");
    return SafeArea(
      child: Scaffold(
        appBar:
            SearchScreenAppBar(context, controller, onSubmit: searchOnSubmit),
        body: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.5, end: 0.0),
            curve: Curves.easeOutCubic,
            duration: const Duration(milliseconds: 2000),
            onEnd: () {
              print("Animation End");
            },
            builder: (context, value, child) {
              return Transform.translate(
                  offset: Offset(value * 150, 0.0), child: child);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.0.w),
              child: Obx(
                () => ListView(
                  children: [
                    Visibility(
                      visible: controller.recentSearchTerms.length > 0,
                      child: Container(
                        // height: 40.0.h,
                        // color: Colors.grey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("최근 검색어",
                                    style: TextStyle(fontSize: 14.0.sp)),
                                GestureDetector(
                                    onTap: () {
                                      controller.clearRecentSearchTerm();
                                    },
                                    child: Text("전체 삭제",
                                        style: TextStyle(fontSize: 14.0.sp))),
                              ],
                            ),
                            Wrap(
                              spacing: 2.0.w,
                              runSpacing: 0,
                              children: [
                                ...controller.recentSearchTerms.map(
                                  (recentTerm) => RawChip(
                                    label: Text(recentTerm,
                                        style: TextStyle(fontSize: 12.0.sp)),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 0,
                            )
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          controller.updateRecentSearchTerm();
                        },
                        child: Text("최근 검색어 추가")),
                    Container(
                        color: Colors.red.shade100,
                        child: Column(
                          children: [
                            Text("인기 검색어"),
                            Wrap(
                              spacing: 2.0.w,
                              runSpacing: 0,
                              children: [
                                ...List.generate(
                                  5,
                                  (index) => RawChip(
                                    label: Text('테스트 입니다요링 $index'),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void searchOnSubmit(String val) {
    controller.updateRecentSearchTerm();
    Get.to(SearchDetailScreen(), binding: BindingsBuilder(() {
      Get.lazyPut(
        () => SearchDetailScreenController(),
      );
    }), arguments: {'searchTerm': val}, transition: Transition.noTransition)
        ?.whenComplete(() {
      controller.refreshRecentSearchTerm();
    });
  }
}
