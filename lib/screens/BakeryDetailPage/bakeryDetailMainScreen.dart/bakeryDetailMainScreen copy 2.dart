import 'dart:ui';

import 'package:bbangnarae_frontend/screens/BakeryDetailPage/bakeryDetailMainScreen.dart/bakeryDetailMainController.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// 백업용
class BakeryDetailMainScreen extends GetView<BakeryDetailMainController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(4.0.h),
          child: Obx(
            () => AppBar(
              title: Text("하이"),
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor:
                  Colors.white.withOpacity(controller.appBarOpacity.value),

              // toolbarHeight: 4.0.h,
              // backgroundColor: Colors.transparent,
            ),
          ),
        ),
        body: CustomScrollView(
          controller: controller.scrollController,
          physics: const BouncingScrollPhysics(
              parent: const AlwaysScrollableScrollPhysics()),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () => Future(() => null),
            ),
            SliverAppBar(
              title: Text("슬리버 앱 바 "),
              pinned: true,
              // toolbarHeight: 4.0.h,
              // backgroundColor: Colors.transparent,
            ),

            // 베이커리 메인 프로필
            SliverToBoxAdapter(
              child: Container(
                color: Colors.grey,
                width: double.infinity,
                height: 30.0.h,
                child: Stack(
                  children: [
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.5),
                      child: Container(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/bakeryImage.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        // color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5.0.h,
                            ),
                            Builder(builder: (context) {
                              Map<String, dynamic> bakeryData = {
                                'thumbnail': 'assets/breadImage.jpg',
                                'name': '다로베이커리',
                                'signitureBreads': ['다로1빵', '다로2빵', '다로3빵'],
                                'bakeryFeature': [
                                  {'id': '3', 'filter': "유후"}
                                ]
                              };
                              return Container(
                                height: 10.0.h,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 15.0.w,
                                      height: double.infinity,
                                      padding: EdgeInsets.zero,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                          image: new AssetImage(
                                              bakeryData['thumbnail']),
                                        ),
                                      ),
                                    ),
                                    Container(width: 2.0.w),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                bakeryData['name'],
                                                style: TextStyle(
                                                    fontSize: 12.0.sp,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                              SizedBox(width: 2.0.w),
                                              bakeryData['signitureBreads']
                                                          ?.length ==
                                                      0
                                                  ? Container()
                                                  : Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      color: Colors
                                                          .green.shade700
                                                          .withOpacity(0.1),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            '대표빵 - ',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    9.0.sp,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          ...bakeryData[
                                                                  'signitureBreads']!
                                                              .map(
                                                            (element) => Text(
                                                              '$element${bakeryData['signitureBreads']!.indexOf(element) == bakeryData['signitureBreads']!.length - 1 ? '' : 'ㆍ'}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      9.0.sp,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          Builder(
                                            builder: (context) {
                                              final List<dynamic> result =
                                                  bakeryData['bakeryFeature']
                                                      .where((e) =>
                                                          int.parse(e['id']) >
                                                          2)
                                                      .toList();

                                              return Row(children: [
                                                ...result.map((element) => Text(
                                                    '#${element['filter']} ',
                                                    style: TextStyle(
                                                        fontSize: 9.0.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w300))),
                                              ]);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print("여긴 취향존중");
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  CupertinoIcons.star,
                                                  color: Colors.red,
                                                  size: 16.0.sp,
                                                ),
                                                Text("1.2만",
                                                    style: TextStyle(
                                                        fontSize: 8.0.sp)),
                                              ],
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: Text("하이헬로")),
            SliverToBoxAdapter(child: Text("하이헬로")),
            SliverToBoxAdapter(child: Text("하이헬로")),
            SliverToBoxAdapter(child: Text("하이헬로")),
            SliverToBoxAdapter(child: Text("하이헬로")),
            SliverToBoxAdapter(child: Text("하이헬로")),
            // 라지 카테고리 && 세부카테고리(접이식)
            // 필터 & 세부옵션
            // 상품목록
          ],
        ),
      ),
    );
  }
}
