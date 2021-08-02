import 'dart:ui';

import 'package:bbangnarae_frontend/screens/BakeryDetailPage/bakeryDetailMainController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadShareWidget.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// 앱바 스크롤 컬러 애니메이션 테스트용 백업

var test = true.obs;

class BakeryDetailMainScreen extends GetView<BakeryDetailMainController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Obx(
          () => ModalProgressScreen(
            isAsyncCall: controller.isLoading.value,
            child: controller.firstInitLoading.value
                ? Center(child: CupertinoActivityIndicator())
                : NotificationListener<ScrollNotification>(
                    onNotification: controller.scrollListener,
                    child: CustomScrollView(
                      controller: controller.scrollController,
                      physics: const BouncingScrollPhysics(
                          parent: const AlwaysScrollableScrollPhysics()),
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () => Future(() => null),
                        ),
                        SliverOverlapAbsorber(
                          handle: SliverOverlapAbsorberHandle(),
                          sliver: AnimatedBuilder(
                            animation: controller.ColorAnimationController,
                            builder: (context, child) => SliverAppBar(
                              backgroundColor: controller.colorTween.value,
                              title: Text(
                                controller.bakeryDetailInfo.value.name,
                                style: TextStyle(
                                  color: controller.appBarTextColorTween.value,
                                ),
                              ),
                              toolbarHeight: 7.0.h,
                              titleSpacing: 0.0,
                              elevation: 0,
                              pinned: true,
                              centerTitle: true,
                              automaticallyImplyLeading: false,
                              leading: backArrowButtton(
                                  color: controller.iconColorTween.value),
                              iconTheme: IconThemeData(
                                color: controller.iconColorTween.value,
                              ),
                              actions: <Widget>[
                                Obx(() {
                                  if (controller.bakeryLikeBtnShow.value) {
                                    return GestureDetector(
                                      onTap: () {
                                        print("Like");
                                        controller.toggleGetDibsBakery();
                                        // Get.back();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Obx(
                                          () => Container(
                                            child: Icon(
                                              controller.isGotDibs.value
                                                  ? CupertinoIcons.star_fill
                                                  : CupertinoIcons.star,
                                              color: controller.isGotDibs.value
                                                  ? Colors.red
                                                  : Colors.grey,
                                              size: 18.0.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return SizedBox.shrink();
                                }),
                                Container(
                                  // color: Colors.red,
                                  child: GestureDetector(
                                    onTap: () {
                                      print("Search");
                                      Get.toNamed('/search');
                                      // Get.back();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Container(
                                        child: Icon(
                                          Icons.search,
                                          size: 18.0.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  // color: Colors.red,
                                  child: GestureDetector(
                                    onTap: () {
                                      print("Home");
                                      Get.until((route) => route.isFirst);
                                      AuthController.to.mainPageController
                                          .jumpToPage(0);
                                      // Get.back();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Container(
                                        child: Icon(
                                          Icons.home_outlined,
                                          size: 18.0.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  // color: Colors.blue,
                                  child: GestureDetector(
                                    onTap: () {
                                      print("Cart");
                                      // Get.back();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 10),
                                      child: Container(
                                        child: Icon(
                                          Icons.local_grocery_store,
                                          size: 18.0.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                                  imageFilter: ImageFilter.blur(
                                      sigmaX: 1.0, sigmaY: 0.5),
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
                                    color: Colors.black.withOpacity(0.25),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.0.w),
                                    // color: Colors.transparent,
                                    child: Builder(builder: (context) {
                                      BakeryDetailInfo bakeryData =
                                          controller.bakeryDetailInfo.value;
                                      // Map<String, dynamic> bakeryData = {
                                      //   'thumbnail': 'assets/breadImage.jpg',
                                      //   'name': '다로베이커리',
                                      //   'signitureBreads': [
                                      //     '다로1빵',
                                      //     '다로2빵',
                                      //     '다로3빵'
                                      //   ],
                                      //   'bakeryFeature': [
                                      //     {'id': '3', 'filter': "유후"}
                                      //   ],
                                      //   'description':
                                      //       '다로베이커리 입니다. 잘 부탁드립니다. 맛있고 건강한 빵을 만들기 위해서 최선을 다 하겠습니다.',
                                      // };
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 6.0.h,
                                          ),
                                          Container(
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
                                                      alignment:
                                                          Alignment.topCenter,
                                                      image: new AssetImage(
                                                          bakeryData.thumbnail),
                                                    ),
                                                  ),
                                                ),
                                                Container(width: 2.0.w),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            bakeryData.name,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    12.0.sp,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                          SizedBox(
                                                              width: 2.0.w),
                                                        ],
                                                      ),
                                                      Builder(
                                                        builder: (context) {
                                                          final List<
                                                                  BakeryFilterInfo>
                                                              result =
                                                              bakeryData
                                                                  .bakeryFeature
                                                                  .where((e) =>
                                                                      int.parse(
                                                                          e.id) >
                                                                      2)
                                                                  .toList();

                                                          return Row(children: [
                                                            ...result.map((element) => Text(
                                                                '#${element.filter} ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        9.0.sp,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300))),
                                                          ]);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    print(
                                                        "여긴 취향존중 ${bakeryData.isGotDibs}");
                                                    // toggleDibsBakery
                                                    controller
                                                        .toggleGetDibsBakery();
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5.0),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Obx(
                                                          () => Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                controller.isGotDibs
                                                                        .value
                                                                    ? CupertinoIcons
                                                                        .star_fill
                                                                    : CupertinoIcons
                                                                        .star,
                                                                color: controller
                                                                        .isGotDibs
                                                                        .value
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .white,
                                                                size: 20.0.sp,
                                                              ),
                                                              Text(
                                                                  "${controller.gotDibsUserCount}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          8.0
                                                                              .sp,
                                                                      color: Colors
                                                                          .white)),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          bakeryData.signitureBreads?.length ==
                                                  0
                                              ? Container()
                                              : Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  color: Colors.green.shade700
                                                      .withOpacity(0.1),
                                                  child: RichText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      text: "대표빵  ",
                                                      children: [
                                                        ...bakeryData
                                                            .signitureBreads!
                                                            .map(
                                                          (element) => TextSpan(
                                                            text:
                                                                '${element['name']}${bakeryData.signitureBreads!.indexOf(element) == bakeryData.signitureBreads!.length - 1 ? '' : ', '}',
                                                            style: TextStyle(
                                                              fontSize: 10.0.sp,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          Material(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            elevation: 15.0,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 2.0.w,
                                                vertical: 0.5.h,
                                              ),
                                              // alignment: Alignment.centerLeft
                                              child: Text(
                                                bakeryData.description ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11.0.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 1.5.h,
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  print("리뷰보기 탭");
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.white),
                                                  )),
                                                  child: Text("리뷰 1.7만",
                                                      style: TextStyle(
                                                        fontSize: 9.0.sp,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                              ),
                                              SizedBox(width: 5.0.w),
                                              GestureDetector(
                                                onTap: () {
                                                  print("마켓정보 보기탭");
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.white),
                                                  )),
                                                  child: Text("마켓정보",
                                                      style: TextStyle(
                                                        fontSize: 9.0.sp,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => SliverAppBar(
                            backgroundColor: Colors.blue,
                            // toolbarHeight: test.value ? 7.0.h : 12.0.h,
                            toolbarHeight: 5.0.h,
                            primary: false,
                            pinned: true,
                            elevation: 0,
                            forceElevated: false,
                            automaticallyImplyLeading: false,
                            flexibleSpace: FlexibleSpaceBar(
                              titlePadding: EdgeInsets.zero,
                              title: Column(
                                children: [
                                  Container(
                                    height: 5.0.h,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Builder(
                                            builder: (context) {
                                              List<BreadCategory>
                                                  breadLargeCategories = [
                                                new BreadCategory.fromJson({
                                                  'id': '0',
                                                  'category': '전체'
                                                }),
                                                ...controller.bakeryDetailInfo
                                                    .value.breadLargeCategories
                                                    .map((breadLargeCategory) =>
                                                        BreadCategory.fromJson(
                                                            breadLargeCategory))
                                              ];
                                              print(breadLargeCategories);
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.0.w),
                                                child: Obx(
                                                  () => Wrap(
                                                    spacing: 2.0.w,
                                                    children: [
                                                      ...breadLargeCategories
                                                          .map(
                                                              (largeCategory) =>
                                                                  RawChip(
                                                                    label: Text(
                                                                      largeCategory
                                                                          .category,
                                                                      style: TextStyle(
                                                                          fontSize: 10.0
                                                                              .sp,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    materialTapTargetSize:
                                                                        MaterialTapTargetSize
                                                                            .shrinkWrap,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .grey,
                                                                    onPressed:
                                                                        () {
                                                                      print(largeCategory
                                                                          .category);
                                                                      controller
                                                                          .applyLargeCateogryChanged(
                                                                              largeCategory.id);
                                                                    },
                                                                    selected: largeCategory
                                                                            .id ==
                                                                        controller
                                                                            .breadLargeCategoryId
                                                                            .value,
                                                                    showCheckmark:
                                                                        false,
                                                                    selectedColor: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.8),
                                                                    visualDensity:
                                                                        VisualDensity
                                                                            .compact,
                                                                  )),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            test(!test.value);
                                          },
                                          child: Container(
                                            width: 15.0.w,
                                            child: Center(
                                              child: Text(
                                                  test.value ? "상세옵션" : "접기",
                                                  style: TextStyle(
                                                      fontSize: 10.0.sp)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              centerTitle: true,
                            ),
                          ),
                        ),

                        // SliverAppBar(
                        //   titleSpacing: 0,
                        //   toolbarHeight: test.value ? 0 : 5.0.h,
                        //   automaticallyImplyLeading: false,
                        //   title: AnimatedContainer(
                        //     duration:
                        //         Duration(milliseconds: test.value ? 0 : 600),
                        //     curve: Curves.fastOutSlowIn,
                        //     // color: Colors.red,
                        //     height: test.value ? 0 : 5.0.h,
                        //     child: Container(
                        //       width: double.infinity,
                        //       color: Colors.red,
                        //       child: Text("하이"),
                        //     ),
                        //   ),
                        // ),
                        SliverAppBar(
                          pinned: true,
                          titleSpacing: 0,
                          toolbarHeight: test.value ? 0 : 5.0.h,
                          automaticallyImplyLeading: false,
                          backgroundColor: Colors.red,
                          title: AnimatedContainer(
                            duration:
                                Duration(milliseconds: test.value ? 0 : 600),
                            curve: Curves.fastOutSlowIn,
                            // color: Colors.red,
                            height: test.value ? 0 : 5.0.h,
                            child: Container(
                              height: 5.0.h,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Builder(
                                      builder: (context) {
                                        List<BreadCategory>
                                            breadSmallCategoreis = [
                                          new BreadCategory.fromJson(
                                              {'id': '0', 'category': '전체'}),
                                          ...controller.bakeryDetailInfo.value
                                              .breadSmallCategories
                                              .map((breadSmallCategory) =>
                                                  BreadCategory.fromJson(
                                                      breadSmallCategory))
                                        ];
                                        // print(breadSmallCategoreis);
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.0.w),
                                          child: Obx(
                                            () => Wrap(
                                              spacing: 2.0.w,
                                              children: [
                                                ...breadSmallCategoreis.map(
                                                    (smallCategory) => RawChip(
                                                          label: Text(
                                                            smallCategory
                                                                .category,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    10.0.sp,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          materialTapTargetSize:
                                                              MaterialTapTargetSize
                                                                  .shrinkWrap,
                                                          backgroundColor:
                                                              Colors.grey,
                                                          onPressed: () {
                                                            print(smallCategory
                                                                .category);
                                                            controller
                                                                .applySmallCateogryChanged(
                                                                    smallCategory
                                                                        .id);
                                                          },
                                                          selected: smallCategory
                                                                  .id ==
                                                              controller
                                                                  .breadSmallCategoryId
                                                                  .value,
                                                          showCheckmark: false,
                                                          selectedColor: Colors
                                                              .black
                                                              .withOpacity(0.8),
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                        )),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        BreadFilterBar(controller),
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                          sliver: SimpleBreadList(
                            isLoading: controller.isLoading,
                            hasMore: controller.hasMore,
                            simpleBreadListResult:
                                controller.simpleBreadListResult,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
