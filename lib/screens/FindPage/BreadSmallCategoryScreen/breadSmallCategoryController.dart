import 'package:bbangnarae_frontend/screens/FindPage/BreadLargeCategoryScreen/breadLargeCategoryController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/BreadSmallCategoryScreen/breadCategory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
/*
BreadSortFilter
  1: 최신순
  2: 인기순
  3: 저가순
  4: 리뷰많은순

BreadOptionFilter
  1: 글루텐프리
  2: 쌀빵
  3: 무가당
*/

class BreadSmallCategoryController extends GetxController {
  BreadSmallCategoryController({required this.largeCategory});

  var isLoading = true.obs;
  final BreadLargeCategory largeCategory;
  RxList<dynamic> breadsResult = [].obs;
  // final BreadLargeCategoryController largeCategoryController = Get.find();
  void onInit() async {
    print('${describeEnum(largeCategory)} OnInit!');
    switch (largeCategory) {
      case BreadLargeCategory.all:
        {
          var allTest = [
            {'price': '1000', 'bakery': '전체', 'description': "전체 입니다"},
            {'price': '1100', 'bakery': '전체1', 'description': "전체1 입니다"},
            {'price': '1200', 'bakery': '전체2', 'description': "전체2 입니다"},
            {'price': '1300', 'bakery': '전체3', 'description': "전체3 입니다"},
            {'price': '1400', 'bakery': '전체4', 'description': "전체4 입니다"},
          ];
          breadsResult.addAll(allTest);
          // await Future.delayed(Duration(seconds: 3));
          isLoading(false);
        }
        break;
      case BreadLargeCategory.softBread:
        {
          var allTest = [
            {
              'price': '2000',
              'bakery': '소프트베이커리',
              'description': "소프트베이커리 입니다"
            },
            {
              'price': '2100',
              'bakery': '소프트베이커리1',
              'description': "소프트베이커리1 입니다"
            },
            {
              'price': '2200',
              'bakery': '소프트베이커리2',
              'description': "소프트베이커리2 입니다"
            },
            {
              'price': '2300',
              'bakery': '소프트베이커리3',
              'description': "소프트베이커리3 입니다"
            },
            {
              'price': '2400',
              'bakery': '소프트베이커리4',
              'description': "소프트베이커리4 입니다"
            },
          ];
          breadsResult.addAll(allTest);
          isLoading(false);
        }
        break;
      case BreadLargeCategory.hardBread:
        {}
        break;
      case BreadLargeCategory.dessert:
        {}
        break;
    }
    super.onInit();
  }

  @override
  void onClose() {
    print("dispose!");
    print('${describeEnum(largeCategory)} Dispose!');
    super.onClose();
  }
}

// class BreadSmallCategoryTestController extends GetxController {
//   BreadSmallCategoryTestController({required this.largeCategory});

//   var isLoading = true.obs;
//   final BreadLargeCategory largeCategory;
//   RxList<dynamic> breadsResult = [].obs;
//   // final BreadLargeCategoryController largeCategoryController = Get.find();
//   void onInit() async {
//     print('${describeEnum(largeCategory)} OnInit!');
//     switch (largeCategory) {
//       case BreadLargeCategory.all:
//         {
//           var allTest = [
//             {'price': '1000', 'bakery': '전체', 'description': "전체 입니다"},
//             {'price': '1100', 'bakery': '전체1', 'description': "전체1 입니다"},
//             {'price': '1200', 'bakery': '전체2', 'description': "전체2 입니다"},
//             {'price': '1300', 'bakery': '전체3', 'description': "전체3 입니다"},
//             {'price': '1400', 'bakery': '전체4', 'description': "전체4 입니다"},
//           ];
//           breadsResult.addAll(allTest);
//           print("하이..?");
//           await Future.delayed(Duration(seconds: 3));
//           print("하이..?22");
//           isLoading(false);
//         }
//         break;
//       case BreadLargeCategory.softBread:
//         {
//           var allTest = [
//             {
//               'price': '2000',
//               'bakery': '소프트베이커리',
//               'description': "소프트베이커리 입니다"
//             },
//             {
//               'price': '2100',
//               'bakery': '소프트베이커리1',
//               'description': "소프트베이커리1 입니다"
//             },
//             {
//               'price': '2200',
//               'bakery': '소프트베이커리2',
//               'description': "소프트베이커리2 입니다"
//             },
//             {
//               'price': '2300',
//               'bakery': '소프트베이커리3',
//               'description': "소프트베이커리3 입니다"
//             },
//             {
//               'price': '2400',
//               'bakery': '소프트베이커리4',
//               'description': "소프트베이커리4 입니다"
//             },
//           ];
//           breadsResult.addAll(allTest);
//           isLoading(false);
//         }
//         break;
//       case BreadLargeCategory.hardBread:
//         {}
//         break;
//       case BreadLargeCategory.dessert:
//         {}
//         break;
//     }
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     print("dispose!");
//     print('${describeEnum(largeCategory)} Dispose!');
//     super.onClose();
//   }
// }
