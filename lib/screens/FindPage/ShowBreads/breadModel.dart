// List<String> SoftBreadCategory = ['식빵', '치아바타', '크림빵'];
// List<String> HardBreadCategory = ['깜빠뉴'];
// List<String> DessertBreadCategory = ['파운드,크럼블', '브라우니', '스콘', '쿠키', '케이크'];
import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final SimpleBreadFetchMinimum = 2;

abstract class BreadModel extends GetxController {
  late RxBool isLoading;
  late RxBool firstInitLoading;
  late RxBool isFetchMoreLoading;
  late RxBool hasMore;
  late RxBool filterLoading;

  late RxString sortFilterId; // 최신순
  late ScrollController scrollController;
  late RxList<String> breadSortFilterIdList;
  late RxList<dynamic> breadFilterResult;
  late RxList<String> breadOptionFilterIdList;
  late RxList<dynamic> filterWidget;

  late RxInt cursorBreadId;

  late RxList<dynamic> filterIdList;
  late RxList<dynamic> tempFilterIdList;
  var simpleBreadListResult;

  get refreshBakeryInfoData;
  get initFilterSelected;
  get applyFilterChanged;
}

enum BreadLargeCategory {
  all,
  softBread,
  hardBread,
  dessert,
}

class BreadCategory {
  final String id;
  final String category;
  BreadCategory({required this.id, required this.category});

  BreadCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        category = json['category'];
}

final BreadLargeCategories = [
  BreadCategory(id: '0', category: '전체'),
  BreadCategory(id: '1', category: '소프트브레드'),
  BreadCategory(id: '2', category: '하드브레드'),
  BreadCategory(id: '3', category: '디저트'),
];
enum BreadOptionFilterType { gf, rice, sf }

class BreadSortFilter {
  final String id;
  final String filter;
  BreadSortFilter({required this.id, required this.filter});
}

final List<BreadSortFilter> BreadSortFilters = [
  BreadSortFilter(id: '1', filter: '최신순'),
  BreadSortFilter(id: '2', filter: '인기순'),
  BreadSortFilter(id: '3', filter: '저가순'),
  BreadSortFilter(id: '4', filter: '리뷰많은순'),
];

class BreadDetailInfo {
  final int id;
  final String thumbnail;
  final String name;
  final int costPrice;
  final int price;
  final int discount;
  final String? description;
  final String? detailDescription;
  final int gotDibsUserCount;
  bool isGotDibs;
  final int bakeryId;
  final String bakeryName;
  final String? bakeryThumbnail;
  final List<BakeryFilterInfo> bakeryFeatures;
  final int bakeryGotDibsUserCount;
  bool bakeryIsGotDibs;

  BreadDetailInfo(
      {required this.id,
      required this.thumbnail,
      required this.name,
      required this.costPrice,
      required this.price,
      required this.discount,
      this.description,
      required this.detailDescription,
      required this.gotDibsUserCount,
      required this.isGotDibs,
      required this.bakeryId,
      required this.bakeryName,
      required this.bakeryThumbnail,
      required this.bakeryFeatures,
      required this.bakeryIsGotDibs,
      required this.bakeryGotDibsUserCount});

  BreadDetailInfo.fromJson(
    Map<String, dynamic> breadJson,
    Map<String, dynamic> bakeryJson,
  )   : id = breadJson['id'],
        thumbnail = 'assets/breadImage.jpg',
        name = breadJson['name'],
        costPrice = breadJson['costPrice'],
        price = breadJson['price'],
        discount = breadJson['discount'],
        description = breadJson['description'],
        detailDescription =
            breadJson['detailDescription'] ?? 'Detail Description',
        gotDibsUserCount = breadJson['gotDibsUserCount'],
        isGotDibs = breadJson['isGotDibs'],
        bakeryId = bakeryJson['id'],
        bakeryName = bakeryJson['name'],
        bakeryThumbnail = bakeryJson['thumbnail'] ?? 'assets/bakeryImage.jpg',
        bakeryFeatures = bakeryJson['bakeryFeatures']
            .map<BakeryFilterInfo>((bakeryFeatureJson) =>
                BakeryFilterInfo.fromJson(bakeryFeatureJson))
            .toList(),
        bakeryIsGotDibs = bakeryJson['isGotDibs'],
        bakeryGotDibsUserCount = bakeryJson['gotDibsUserCount'];

  @override
  String toString() {
    return 'name: $name,  description: $description, \n gotDibsUserCount: $gotDibsUserCount';
  }
}

class BreadOptionFilter {
  final String id;
  final String filter;
  BreadOptionFilter({required this.id, required this.filter});
}

final List<BreadOptionFilter> BreadOptionFilters = [
  BreadOptionFilter(id: '1', filter: '최신순'),
  BreadOptionFilter(id: '2', filter: '인기순'),
  BreadOptionFilter(id: '3', filter: '리뷰많은순'),
  BreadOptionFilter(id: '3', filter: '저가순'),
];

class BreadSimpleInfo {
  final int id;
  final String thumbnail;
  final String name;
  final String bakeryName;
  final int price;
  final String? description;
  final int discount;
  final bool isSigniture;
  final List<BakeryFilterInfo>? breadFeatures;
  bool? isGotDibs;
  BreadSimpleInfo(
      {required this.id,
      required this.thumbnail,
      required this.name,
      required this.bakeryName,
      this.breadFeatures,
      this.description,
      this.price: 0,
      this.discount: 0,
      this.isSigniture: false,
      this.isGotDibs});
  BreadSimpleInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        thumbnail = json['thumbnail'] ?? 'assets/breadImage.jpg',
        name = json['name'],
        bakeryName = json['bakeryName'],
        description = json['description'],
        price = json['price'],
        discount = json['discount'],
        breadFeatures = json['breadFeatures']
            ?.map<BakeryFilterInfo>((breadFeatureJson) =>
                BakeryFilterInfo.fromJson(breadFeatureJson))
            .toList(),
        isSigniture = json['isSigniture'],
        isGotDibs = json['isGotDibs'];

  @override
  String toString() {
    return 'name: $name, bakeryName: $bakeryName, price: $price, description: $description, discount: $discount, isSigniture: $isSigniture breadFeature: $breadFeatures';
  }
}

class DrawerItemInfo {
  final int id;
  final String thumbnail;
  final String name;
  final String bakeryName;
  final int price;
  final String? description;
  final int discount;
  DrawerItemInfo({
    required this.id,
    required this.thumbnail,
    required this.name,
    required this.bakeryName,
    this.description,
    this.price: 0,
    this.discount: 0,
  });
  DrawerItemInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        thumbnail = json['thumbnail'] ?? 'assets/breadImage.jpg',
        name = json['name'],
        bakeryName = json['bakeryName'],
        description = json['description'],
        price = json['price'],
        discount = json['discount'];

  @override
  String toString() {
    return 'name: $name, bakeryName: $bakeryName, price: $price, description: $description, discount: $discount';
  }
}
