import 'dart:math';

import 'package:bbangnarae_frontend/screens/FindPage/BreadSmallCategoryScreen/breadCategory.dart';
import 'package:bbangnarae_frontend/screens/FindPage/BreadSmallCategoryScreen/breadSmallCategoryController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final isInit = false;

class BreadSmallCategoryScreen extends StatelessWidget {
  const BreadSmallCategoryScreen({Key? key, required this.largeCategory})
      : super(key: key);
  final BreadLargeCategory largeCategory;
  @override
  Widget build(BuildContext context) {
    print("BreadSmallCateogryScreen 빌드!");
    return GetBuilder<BreadSmallCategoryController>(
      key: ValueKey(describeEnum(largeCategory)),
      init: BreadSmallCategoryController(largeCategory: largeCategory),
      global: false,
      dispose: (state) {
        state.controller?.onClose();
      },
      builder: (controller) {
        return Obx(() {
          if (controller.isLoading.value) {
            return Container(
                child: Center(child: CupertinoActivityIndicator()));
          }
          return Container(
              child: CustomScrollView(slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 45.0.w,
                      height: 25.0.h,
                      child: Image.asset(
                        'assets/breadImage.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(controller.breadsResult[index]['price']),
                    Text(controller.breadsResult[index]['bakery']),
                    Text(controller.breadsResult[index]['description']),
                  ],
                );
              }, childCount: 5),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0.w,
                mainAxisExtent: 35.0.h,
              ),
            ),
          ]));
        });
      },
    );
  }
}

// class BreadSmallCategoryTest extends StatelessWidget {
//   BreadSmallCategoryTest({Key? key, required this.largeCategory})
//       : super(key: key);
//   final BreadLargeCategory largeCategory;

//   late final controller = Get.put(
//       BreadSmallCategoryTestController(largeCategory: largeCategory),
//       permanent: false);

//   @override
//   Widget build(BuildContext context) {
//     print('largeCategory: $largeCategory');
//     if (controller.isLoading.value) {
//       return Container(child: Center(child: CupertinoActivityIndicator()));
//     }
//     return Container(
//         child: CustomScrollView(slivers: [
//       SliverGrid(
//         delegate: SliverChildBuilderDelegate((context, index) {
//           return Column(
//             // mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 45.0.w,
//                 height: 25.0.h,
//                 child: Image.asset(
//                   'assets/breadImage.jpg',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Text(controller.breadsResult[index]['price']),
//               Text(controller.breadsResult[index]['bakery']),
//               Text(controller.breadsResult[index]['description']),
//             ],
//           );
//         }, childCount: 5),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 4.0.w,
//           mainAxisExtent: 35.0.h,
//         ),
//       ),
//     ]));
//   }
// }
