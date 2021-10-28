import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerDetailScreen/DibsDrawerDetailController.dart';
import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerDetailScreen/DibsDrawerDetailScreen.dart';
import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerMainScreen/DibsDrawerMainController.dart';
import 'package:bbangnarae_frontend/screens/DibsDrawerPage/dibsDrawerSharedWidget.dart';
import 'package:bbangnarae_frontend/shared/sharedValues.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// 완성!!
class DibsDrawerMainScreen extends GetView<DibsDrawerMainController> {
  @override
  Widget build(BuildContext context) {
    // 찜하기 버튼을 누를 때 someDibsDrawerChanged 가 true로 변경
    // 그런 후에 다시 찜 페이지로 들어오면 데이터가 업데이트 되는 논리
    if (controller.someDibsDrawerChanged) {
      print("데이터를 다시 한 번 불러오자");
      controller.fetchDibsDrawerList();

      controller.someDibsDrawerChanged = false;
    }
    return Scaffold(
      body: Obx(
        () => LoadingModalScreen(
          isLoading: controller.isLoading,
          firstInitLoading: controller.firstInitLoading,
          child: CustomScrollView(
            key: ValueKey('dibsDrawerScroll'),
            controller: controller.scrollController,
            physics: CupertinoScrollPhysics,
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () => Future(() => null),
              ),
              MySliverAppBar(
                title: controller.firstInitLoading.value ? '찜' : "찜",
                isLeading: false,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 2.0.h,
                      ),
                      Container(
                        height: 5.0.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // TextField(autofocus: true),
                            Text('찜한 상품', style: TextStyle(fontSize: 16.0.sp)),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  onPrimary: Colors.grey[800]),
                              onPressed: () {
                                showModalBottomSheet(
                                  isDismissible:
                                      true, // 위에 빈공간 눌렀을때 자동으로 없어지게 하는 기능
                                  isScrollControlled: true, // 풀 스크린 가능하게 만들어줌
                                  context: context,

                                  builder: (context) {
                                    // return Container();
                                    return Container(
                                      width: 100.0.w,
                                      height: 90.0.h,
                                      child: Column(
                                        children: [
                                          MyAppBar(title: '새 서랍 만들기'),
                                          TextField(
                                            onChanged: (value) {
                                              if (value == '') {
                                                controller
                                                    .drawerNameisEmpty(true);
                                              } else {
                                                controller
                                                    .drawerNameisEmpty(false);
                                              }
                                            },
                                            controller: controller
                                                .drawerNameTextController,
                                            decoration: InputDecoration(
                                              hintText:
                                                  "서랍 이름은 최소 한 글자 이상 입력해주세요",
                                              counterStyle: TextStyle(
                                                  fontSize: 11.0.sp,
                                                  letterSpacing: 2),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 3.0.w),
                                              focusedBorder:
                                                  new UnderlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none),
                                            ),
                                            autofocus: true,
                                            maxLength: 30,
                                            maxLines: 2,
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: SizedBox(
                                                    width: 100.0.w,
                                                    height: 7.0.h,
                                                    child: Obx(
                                                      () => ElevatedButton(
                                                        child: Text("완료",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    17.0.sp)),
                                                        onPressed: controller
                                                                .drawerNameisEmpty
                                                                .value
                                                            ? null
                                                            : () {
                                                                controller.createDrawer(
                                                                    name: controller
                                                                        .drawerNameTextController
                                                                        .text);
                                                                controller
                                                                    .drawerNameTextController
                                                                    .text = '';
                                                                Get.back();
                                                              },
                                                      ),
                                                    ))),
                                          ))
                                        ],
                                      ),
                                    );
                                  },
                                );
                                // controller.createDrawer(name: '새로운 서랍이야');
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "+ ",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0.sp),
                                  children: [
                                    TextSpan(
                                        text: "서랍 추가",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0.sp)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 2.0.h),
              ),
              Obx(() {
                print("Come Here");
                print(controller.dibsDrawerList.runtimeType);
                print(controller.dibsDrawerList);

                if (controller.dibsDrawerList?.first == null)
                  return SliverToBoxAdapter(child: SizedBox.shrink());
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                  sliver: SliverFillRemaining(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 46.0.w / 34.0.h,
                          crossAxisSpacing: 2.0.w,
                        ),
                        itemBuilder: (context, index) {
                          return Obx(() {
                            final dibsDrawer =
                                controller.dibsDrawerList![index];
                            var DrawerContainer = Container(
                              width: 46.0.w,
                              height: 25.0.h,
                              child: Builder(
                                builder: (context) {
                                  if (dibsDrawer!.itemCount >= 4)
                                    return GridView.count(
                                      crossAxisCount: 2,
                                      shrinkWrap: true,
                                      crossAxisSpacing: 0.6.w,
                                      childAspectRatio: 22.2.w / 12.8.h,
                                      mainAxisSpacing: 0.2.h,
                                      children: [
                                        ...dibsDrawer.items!.map(
                                          (item) => Container(
                                            decoration: new BoxDecoration(
                                              color: Colors.red.shade100,
                                              image: DecorationImage(
                                                  image: new AssetImage(
                                                      item.thumbnail!),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  else {
                                    return Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.red.shade100,
                                        image: DecorationImage(
                                            image: new AssetImage(
                                                dibsDrawer.itemCount == 0
                                                    ? 'assets/breadImage.jpg'
                                                    : dibsDrawer
                                                        .items![0].thumbnail!),
                                            fit: BoxFit.cover),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  DibsDrawerDetailScreen(),
                                  arguments: {
                                    'drawerId': dibsDrawer!.id,
                                  },
                                  binding: BindingsBuilder(() {
                                    Get.put(DibsDrawerDetailController());
                                  }),
                                );
                              },
                              child: Column(
                                children: [
                                  DrawerContainer,
                                  Container(
                                    width: 46.0.w,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dibsDrawer!.name,
                                                style: TextStyle(
                                                    fontSize: 11.0.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                "찜한 상품 ${dibsDrawer.itemCount}개",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10.0.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                isDismissible: true,
                                                builder: (context) => Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        ListTile(
                                                          onTap: () {
                                                            controller
                                                                    .drawerNameTextController
                                                                    .text =
                                                                dibsDrawer.name;
                                                            Get.back();
                                                            showDibsDrawerModal(
                                                                title:
                                                                    "서랍 이름 바꾸기",
                                                                controller:
                                                                    controller,
                                                                onPressed: () {
                                                                  controller.changeDibsDrawer(
                                                                      id: dibsDrawer
                                                                          .id,
                                                                      name: controller
                                                                          .drawerNameTextController
                                                                          .text);
                                                                  controller
                                                                      .drawerNameTextController
                                                                      .text = '';
                                                                });
                                                          },
                                                          // tileColor: Colors.grey,
                                                          title: Center(
                                                              child: Text(
                                                                  "서랍 이름 변경")),
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          thickness: 1,
                                                        ),
                                                        ListTile(
                                                          onTap: () {
                                                            controller
                                                                .deleteDrawer(
                                                                    id: dibsDrawer
                                                                        .id);
                                                          },
                                                          title: Center(
                                                              child: Text(
                                                                  "서랍 삭제")),
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          thickness: 1,
                                                        ),
                                                        ListTile(
                                                          onTap: () {
                                                            Get.back();
                                                          },
                                                          title: Center(
                                                              child:
                                                                  Text("취소")),
                                                        ),
                                                      ],
                                                    ));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Icon(Icons.more_vert),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                        },
                        itemCount: controller.dibsDrawerList!.length),
                  ),
                );
              }),

              // SliverGrid.count(
              //   crossAxisCount: 2,
              //   // crossAxisSpacing: 3.0.w,
              //   children: [
              //     ...controller.dibsDrawerList.map(
              //       (dibsDrawer) => Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Container(
              //             height: 30.0.h,
              //             color: Colors.red.shade100,
              //           ),
              //           Text(dibsDrawer.name)
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
