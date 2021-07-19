import 'dart:ui';

import 'package:bbangnarae_frontend/screens/BakeryDetailPage/bakeryDetailMainScreen.dart/bakeryDetailMainController.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// 네스트스크롤 실패작.
class BakeryDetailMainScreen extends GetView<BakeryDetailMainController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: controller.scrollListener,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          // appBar: PreferredSize(
          //   preferredSize: Size.fromHeight(5.0.h),
          //   child: AnimatedBuilder(
          //     animation: controller.ColorAnimationController,
          //     builder: (context, child) => AppBar(
          //       backgroundColor: controller.colorTween.value,
          //       title: Transform.translate(
          //         offset: controller.transTween.value,
          //         child: Text("하이"),
          //       ),
          //       titleSpacing: 0.0,
          //       elevation: 0,
          //       centerTitle: true,
          //       automaticallyImplyLeading: false,
          //       leading:
          //           backArrowButtton(color: controller.iconColorTween.value),
          //       iconTheme: IconThemeData(
          //         color: controller.iconColorTween.value,
          //       ),
          //       actions: <Widget>[
          //         GestureDetector(
          //           onTap: () {
          //             Get.back();
          //           },
          //           child: Container(
          //             child: Icon(
          //               Icons.local_grocery_store,
          //               size: 18.0.sp,
          //             ),
          //           ),
          //         ),
          //         GestureDetector(
          //           onTap: () {
          //             Get.back();
          //           },
          //           child: Container(
          //             child: Icon(
          //               Icons.more_vert,
          //               size: 18.0.sp,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    primary: false,
                    titleSpacing: 0.0,
                    automaticallyImplyLeading: false,
                    toolbarHeight: 30.0.h,
                    title: Container(
                      color: Colors.grey,
                      width: double.infinity,
                      height: 30.0.h,
                      child: Stack(children: [
                        ImageFiltered(
                          imageFilter:
                              ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.5),
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
                                                              const EdgeInsets
                                                                  .all(4),
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
                                                                (element) =>
                                                                    Text(
                                                                  '$element${bakeryData['signitureBreads']!.indexOf(element) == bakeryData['signitureBreads']!.length - 1 ? '' : 'ㆍ'}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          9.0
                                                                              .sp,
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
                                                      bakeryData[
                                                              'bakeryFeature']
                                                          .where((e) =>
                                                              int.parse(
                                                                  e['id']) >
                                                              2)
                                                          .toList();

                                                  return Row(children: [
                                                    ...result.map((element) => Text(
                                                        '#${element['filter']} ',
                                                        style: TextStyle(
                                                            fontSize: 9.0.sp,
                                                            color: Colors.white,
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
                                            print("여긴 취향존중");
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
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
                        Container(
                          height: 5.0.h,
                          child: AnimatedBuilder(
                            animation: controller.ColorAnimationController,
                            builder: (context, child) => AppBar(
                              backgroundColor: controller.colorTween.value,
                              elevation: 0,
                              titleSpacing: 0.0,
                              title: Transform.translate(
                                offset: controller.transTween.value,
                                child: Text(
                                  "하이",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              iconTheme: IconThemeData(
                                color: controller.iconColorTween.value,
                              ),
                              actions: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.local_grocery_store,
                                  ),
                                  onPressed: () {
//                          Navigator.of(context).push(TutorialOverlay());
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ];
              },
              body: Container()),
        ),
      ),
    );
  }
}

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        // SliverAppBar(
        //   pinned: true,
        //   primary: false,
        //   toolbarHeight: 5.0.h,
        //   backgroundColor: Colors.grey,
        //   automaticallyImplyLeading: false,
        //   title: Text("헬로"),
        //   centerTitle: true,
        //   elevation: 0,
        //   titleSpacing: 0.0,
        //   // bottom: PreferredSize(
        //   //   preferredSize: Size.fromHeight(20),
        //   //   child: FittedBox(
        //   //       fit: BoxFit.fill,
        //   //       child: Center(child: Text("하이"))),
        // ),
        SliverList(
            key: ValueKey("NEWKEY"),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  height: 30.0.h,
                  color: Colors.blue.withRed(index * 50),
                  child: Center(
                    child: Text("$index 번 박사"),
                  ),
                );
              },
              childCount: 10,
            )),
      ],
    ));
  }
}
// class TestWidget extends StatelessWidget {
//   const TestWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: CustomScrollView(
//       slivers: [
//         SliverAppBar(
//           pinned: true,
//           primary: false,
//           toolbarHeight: 5.0.h,
//           backgroundColor: Colors.grey,
//           automaticallyImplyLeading: false,
//           title: Text("헬로"),
//           centerTitle: true,
//           elevation: 0,
//           titleSpacing: 0.0,
//           // bottom: PreferredSize(
//           //   preferredSize: Size.fromHeight(20),
//           //   child: FittedBox(
//           //       fit: BoxFit.fill,
//           //       child: Center(child: Text("하이"))),
//         ),
//         SliverList(
//             key: ValueKey("NEWKEY"),
//             delegate: SliverChildBuilderDelegate(
//               (context, index) {
//                 return Container(
//                   height: 30.0.h,
//                   color: Colors.blue.withRed(index * 50),
//                   child: Center(
//                     child: Text("$index 번 박사"),
//                   ),
//                 );
//               },
//               childCount: 10,
//             )),
//       ],
//     ));
//   }
// }
