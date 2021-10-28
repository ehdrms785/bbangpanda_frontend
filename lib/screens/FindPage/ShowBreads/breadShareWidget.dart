import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/BreadDetailPage/breadDetailMainController.dart';
import 'package:bbangnarae_frontend/screens/BreadDetailPage/breadDetailMainScreen.dart';
import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerMainScreen/DibsDrawerMainController.dart';
import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerPageQuery.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/showBreadsController.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:bbangnarae_frontend/theme/buttonTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

Widget SimpleBreadList({
  required RxBool isLoading,
  required RxBool hasMore,
  required RxList<dynamic> simpleBreadListResult,
}) {
  return Obx(() {
    // Obx의 단점이 SliverList 안에 hasMoreValue가 있으면
    // 해당을 반영해서 UI 업데이트를 하지 않는다.
    // 그래서 이렇게 명시적으로 써 준다.
    hasMore.value;
    if (isLoading.value == true && simpleBreadListResult.isEmpty) {
      return SliverIndicator();
    }
    print("언제 업데이트 되나 보자zz");
    if (hasMore.value == false && simpleBreadListResult.length == 0) {
      return SliverToBoxAdapter(
        child: Container(
          height: 50.0.h,
          child: Center(
              child:
                  Text("해당 조건의 빵이 없어요.", style: TextStyle(fontSize: 20.0.sp))),
        ),
      );
    }
    return SliverGrid(
      key: ValueKey("BrLKey"), // BreadList Key
      delegate: SliverChildBuilderDelegate((context, index) {
        print('$index 들어왔다');
        if (index == simpleBreadListResult.length) {
          print("마지막 인덱스z");
          if (hasMore.value == false) {
            return Visibility(
                key: ValueKey(index), visible: false, child: Container());
          }
          if (simpleBreadListResult.length > 1) {
            return Align(
              alignment: Alignment.topRight,
              child: CupertinoActivityIndicator(
                key: ValueKey(index),
              ),
            );
          } else {
            return Visibility(
                key: ValueKey(index), visible: false, child: Container());
          }
        }
        BreadSimpleInfo breadData = simpleBreadListResult[index];
        RxBool _isGotDibs = breadData.isGotDibs!.obs;
        print('Look At Here 2');
        print('${breadData.name} 의 isGotDibs 는 ${breadData.isGotDibs}');
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Get.to(
                  BreadDetailMainScreen(),
                  arguments: {'breadId': breadData.id},
                  binding: BindingsBuilder(
                    () {
                      Get.lazyPut(() => BreadDetailMainController());
                    },
                  ),
                );
              },
              child: Container(
                color: Colors.transparent,
                key: ValueKey(index),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 45.0.w,
                      height: 25.0.h,
                      padding: EdgeInsets.only(bottom: 1.0.h),
                      child: Image.asset(
                        breadData.thumbnail,
                        fit: BoxFit.cover,
                      ),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: breadData.bakeryName.length > 12
                                ? '[${breadData.bakeryName.substring(0, 12)}...]\n'
                                : '[${breadData.bakeryName}] ',
                            style: TextStyle(
                              fontSize: 10.0.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade700,
                            ),
                            children: [
                              TextSpan(
                                text: breadData.name,
                                style: TextStyle(
                                  fontSize: 12.0.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ]),
                      ]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          '${breadData.discount}%',
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: Colors.redAccent,
                          ),
                        ),
                        SizedBox(width: 2.0.w),
                        Text(priceToString(breadData.price),
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Text(
                      breadData.description ?? '설명 없음',
                      style: TextStyle(
                        fontSize: 9.0.sp,
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    FeatureListTextWidget(features: breadData.breadFeatures!),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.symmetric(
                vertical: 1.0.h,
                horizontal: 2.0.w,
              ),
              child: GestureDetector(
                onTap: () async {
                  print("Look at Here");
                  // DibsDrawerMainController.to;
                  // print("Look at Here 22");
                  // print(DibsDrawerMainController.to.initialized);
                  // print(DibsDrawerMainController.to.dibsDrawerList);
                  // final queryRequest = Request(
                  //   operation: Operation(
                  //       document: gql(
                  //           DibsDrawerPageQuery.getDibsDrawerListQuery(
                  //               count: 4))),
                  // );
                  // final readCache = client.cache.readQuery(queryRequest);
                  // print(readCache);
                  print(DibsDrawerMainController.to.dibsDrawerList);
                  // print(DibsDrawerMainController.to.isLoading);
                  // print(DibsDrawerMainController.to.firstInitLoading);
                  // print(DibsDrawerMainController.to.scrollController);
                  // Future.delayed(Duration(seconds: 3), () async {
                  //   // if (readCache == null) {
                  //   await DibsDrawerMainController.to.fetchDibsDrawerList();
                  //   print("다시보기");

                  //   // DibsDraw
                  //   // }
                  //   print("뭐지");
                  // });
                  if (_isGotDibs.value == true) {
                    bool _isOk = await DibsDrawerMainController.to
                        .toggleItemToDibsDrawer(
                      isGotDibs: _isGotDibs.value,
                      itemId: breadData.id,
                      breadName: breadData.name,
                    );
                    if (_isOk) {
                      print("_isGotDibs false로 바꾼다");
                      _isGotDibs(false);
                      DibsDrawerMainController.to.someDibsDrawerChanged = true;
                    }
                    return;
                  }
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Container(
                        width: 100.0.w,
                        height: 85.0.h,
                        child: CustomScrollView(
                          slivers: [
                            MySliverAppBar(title: '찜할 서랍 선택'),
                            SliverAppBar(
                              pinned: true,
                              toolbarHeight: 0,
                              automaticallyImplyLeading: false,
                              elevation: 0,
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(9.0.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.0.w, vertical: 1.0.h),
                                  decoration: new BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 0),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 15.0.w,
                                        height: 7.0.h,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new AssetImage(
                                                'assets/breadImage.jpg'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5.0.w),
                                      Text(
                                        '새 서랍 만들기',
                                        style: TextStyle(
                                            fontSize: 13.0.sp,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              title: null,
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                ...DibsDrawerMainController.to.dibsDrawerList!
                                    .map(
                                  (dibsDrawer) => GestureDetector(
                                    onTap: () async {
                                      bool isOk = await DibsDrawerMainController
                                          .to
                                          .toggleItemToDibsDrawer(
                                              isGotDibs: _isGotDibs.value,
                                              drawerId: dibsDrawer!.id,
                                              itemId: breadData.id,
                                              breadName: breadData.name,
                                              drawerName: dibsDrawer.name);
                                      if (isOk) {
                                        print("_isGotDibs true로 바꾼다");
                                        _isGotDibs(true);
                                        DibsDrawerMainController
                                            .to.someDibsDrawerChanged = true;
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3.0.w, vertical: 1.0.h),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0))),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 15.0.w,
                                            height: 7.0.h,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: new AssetImage(dibsDrawer!
                                                            .itemCount <=
                                                        0
                                                    ? 'assets/bakeryImage.jpg'
                                                    : dibsDrawer
                                                        .items![0].thumbnail!),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.0.w),
                                          Text(
                                            dibsDrawer.name,
                                            style: TextStyle(
                                                fontSize: 13.0.sp,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        )),
                  );
                },
                child: Obx(
                  () => Icon(
                    _isGotDibs.value == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: _isGotDibs.value == true ? Colors.red : Colors.white,
                    size: 20.0.sp,
                  ),
                ),
              ),
            ),
          ],
        );
      },
          childCount: !hasMore.value
              ? simpleBreadListResult.length
              : simpleBreadListResult.length + 1),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0.w,
          mainAxisExtent: 40.0.h,
          mainAxisSpacing: 0.0),
    );
  });
}

Widget BreadFilterBar(BreadModel controller) => SliverAppBar(
    pinned: true,
    toolbarHeight: 0, // bottom을 Title로 쓰기 위해
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(6.0.h),
      child: Column(
        children: [
          Container(
            height: 5.0.h,
            margin: EdgeInsets.only(bottom: 0.5.h),
            // color: Colors.amber.shade100,
            child: Row(
              // scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 2.0.w),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isDismissible: true,
                      isScrollControlled: true,
                      context: Get.context!,
                      builder: (context) {
                        return Obx(
                          () => Wrap(
                            children: [
                              MyAppBar(title: "정렬 설정"),
                              ...BreadSortFilters.map((sortFilter) => ListTile(
                                    onTap: () {
                                      controller.sortFilterId(sortFilter.id);
                                      controller.refreshBakeryInfoData;
                                      print("여기요");
                                      Get.back();
                                      print("여기요22");
                                    },
                                    title: Text(sortFilter.filter),
                                    selected: sortFilter.id ==
                                        controller.sortFilterId.value,
                                    selectedTileColor: Colors.grey,
                                  )),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 2.0.w),
                      child: Chip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        label: Text(
                          "${BreadSortFilters.where((element) => element.id == controller.sortFilterId.value).first.filter} ∇",
                          style: TextStyle(
                              fontSize: 9.0.sp, fontWeight: FontWeight.w600),
                        ),
                        labelPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // showCheckmark: false,
                        padding: EdgeInsets.all(5.0),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.transparent,
                      )),
                ),
                BreadFilterIcon(controller),
                Center(
                    child: Text(' | ', style: TextStyle(color: Colors.grey))),
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Colors.black,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black,
                        ],
                        stops: [0.0, 0.02, 0.97, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstOut,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(width: 2.0.w),
                        ...(controller.breadFilterResult.where((filter) {
                          if (controller.filterIdList.contains(filter['id'])) {
                            return true;
                          } else {
                            return false;
                          }
                        }).toList())
                            .map((e) {
                          return Padding(
                            padding: EdgeInsets.only(right: 2.0.w),
                            child: RawChip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              label: Text(
                                e['filter'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 9.0.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              selected: false,
                              selectedColor: Colors.blueAccent.shade200,
                              showCheckmark: false,
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
        ],
      ),
    ));
Widget BreadFilterIcon(BreadModel controller) => GestureDetector(
      child: RawChip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(
          "상세옵션 ∇",
          style: TextStyle(fontSize: 9.0.sp, fontWeight: FontWeight.w600),
        ),
        labelPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0, color: Colors.grey),
          // borderRadius: BorderRadius.only(
          //   topRight: Radius.circular(25),
          // ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        showCheckmark: false,
        padding: EdgeInsets.all(5.0),
        backgroundColor: Colors.transparent,
      ),
      onTap: () async {
        showModalBottomSheet(
          isDismissible: false, // 위에 빈공간 눌렀을때 자동으로 없어지게 하는 기능
          isScrollControlled: true, // 풀 스크린 가능하게 만들어줌
          context: Get.context!,
          builder: (context) {
            // return Container();
            return FilterModal(controller);
          },
        ).whenComplete(() {
          print("종료");
          return;
        });
      },
    );
Widget FilterModal(BreadModel controller) {
  // TempFilterIdList는 현재 filterIdList를 복사한 값으로 사용
  // controller.tempFilterIdList.clear();
  // controller.tempFilterIdList.addAll(controller.filterIdList);
  return Container(
      width: 100.0.w,
      height: 90.0.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0.w),
        child: Obx(() {
          List<Widget> filterWidgetList = [];
          controller.breadFilterResult
              .asMap()
              .entries
              .forEach((MapEntry entry) {
            filterWidgetList
                .add(MakeChoiceChip(controller.tempFilterIdList, entry));
          });
          return Column(
            children: [
              MyAppBar(title: "필터"),
              Container(
                width: double.infinity,
                child: Wrap(
                    spacing: 2.0.w,
                    runSpacing: 0.0,
                    children: [...filterWidgetList]),
              ),

              // 맨 아래에 버튼을 두기 위한 Expanded
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 30.0.w,
                          height: 5.0.h,
                          child: ElevatedButton(
                            child: Text("초기화",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              controller.initFilterSelected();
                            },
                            style: elevatedButtonWhiteBackground,
                          ),
                        ),
                        SizedBox(
                          width: 50.0.w,
                          height: 5.0.h,
                          child: ElevatedButton(
                            child: Text("적용"),
                            onPressed: () async {
                              Get.back();
                              controller.applyFilterChanged;
                            },
                            style: ElevatedButton.styleFrom(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ));
}

Widget MakeChoiceChip(RxList<dynamic> tempFilterIdList, MapEntry entry) =>
    ChoiceChip(
      disabledColor: Colors.grey.shade700,
      selectedColor: Colors.blueAccent.shade200,
      selected: tempFilterIdList.contains((entry.key + 1).toString()),
      onSelected: (value) {
        // 택배가능, 매장취식 건들 때

        tempFilterIdList.contains((entry.key + 1).toString())
            ? tempFilterIdList.remove((entry.key + 1).toString())
            : tempFilterIdList.add((entry.key + 1).toString());
      },
      label: Text(entry.value['filter'], style: TextStyle()),
    );
