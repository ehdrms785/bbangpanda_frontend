import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/showBreadsController.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

Widget BreadList({required ShowBreadsController controller}) {
  return Obx(() {
    // Obx의 단점이 SliverList 안에 hasMoreValue가 있으면
    // 해당을 반영해서 UI 업데이트를 하지 않는다.
    // 그래서 이렇게 명시적으로 써 준다.
    controller.hasMore.value;
    if (controller.isLoading.value == true &&
        controller.simpleBreadListResult.isEmpty) {
      return SliverIndicator();
    }
    print("언제 업데이트 되나 보자zz");
    if (controller.hasMore.value == false &&
        controller.simpleBreadListResult.length == 0) {
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
        if (index == controller.simpleBreadListResult.length) {
          print("마지막 인덱스z");
          if (controller.hasMore.value == false) {
            return Visibility(
                key: ValueKey(index), visible: false, child: Container());
          }
          if (controller.simpleBreadListResult.length > 1) {
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
        BreadSimpleInfo breadData = controller.simpleBreadListResult[index];
        return Container(
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
              Row(
                children: [
                  ...breadData.breadFeatures.map(
                    (breadFeature) => Text(
                      '#$breadFeature ',
                      style: TextStyle(
                          fontSize: 9.0.sp,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
          childCount: !controller.hasMore.value
              ? controller.simpleBreadListResult.length
              : controller.simpleBreadListResult.length + 1),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0.w,
          mainAxisExtent: 40.0.h,
          mainAxisSpacing: 0.0),
    );
  });
}
