import 'package:flutter/material.dart';
import 'package:get/get.dart';

final SimpleBakeryFetchMinimum = 2;

abstract class BakeryModel extends GetxController {
  var firstInitLoading;
  var isLoading;
  var filterLoading;
  var hasMore;
  var isFetchMoreLoading;

  late RxList<dynamic> bakeryFilterResult;
  late RxInt cursorBakeryId;
  late RxString sortFilterId; // 최신순
  late RxList<String> filterIdList; // 제일 기본은 택배가능만 체크 된 상태
  late RxList<String> tempFilterIdList;

  late final ScrollController scrollController;

  var simpleBakeriesListResult;

  get applyFilterChanged;
  get initFilterSelected;
  get refreshBakeryInfoData;
  // late Future<void> Function() refreshMarketOrderInfoData;
}

class BakerySortFilter {
  final String id;
  final String filter;
  BakerySortFilter({required this.id, required this.filter});
}

final List<BakerySortFilter> BakerySortFilters = [
  BakerySortFilter(id: '1', filter: '최신순'),
  BakerySortFilter(id: '2', filter: '인기순'),
  BakerySortFilter(id: '3', filter: '리뷰많은순'),
];

class BakeryDetailInfo {
  final String thumbnail;
  final String name;
  final List<dynamic> bakeryFeature;
  final String? description;
  final List<dynamic>? signitureBreads;
  final List<dynamic> breadLargeCategories;
  final List<dynamic> breadSmallCategories;
  final int gotDibsUserCount;
  bool isGotDibs;

  BakeryDetailInfo({
    required this.thumbnail,
    required this.name,
    required this.bakeryFeature,
    this.description,
    this.signitureBreads,
    required this.breadLargeCategories,
    required this.breadSmallCategories,
    required this.gotDibsUserCount,
    required this.isGotDibs,
  });

  BakeryDetailInfo.fromJson(
      Map<String, dynamic> bakeryJson, int gotDibsUserCount)
      : thumbnail = 'assets/bakeryImage.jpg',
        name = bakeryJson['name'],
        bakeryFeature = bakeryJson['bakeryFeatures'],
        description = bakeryJson['description'],
        signitureBreads = bakeryJson['signitureBreads'],
        breadLargeCategories = bakeryJson['breadLargeCategories'],
        breadSmallCategories = bakeryJson['breadSmallCategories'],
        gotDibsUserCount = gotDibsUserCount,
        isGotDibs = bakeryJson['isGotDibs'];

  @override
  String toString() {
    return 'name: $name,  description: $description, bakeryFeature: $bakeryFeature,  signitureBreads: $signitureBreads \n breadLargeCategories $breadLargeCategories \n breadSmallCateogries: $breadSmallCategories \n gotDibsUserCount: $gotDibsUserCount';
  }
}

class BakerySimpleInfo {
  final int id;
  final String thumbnail;
  final String name;
  final String? description;
  final List<dynamic> bakeryFeature;
  final List<dynamic>? signitureBreads;
  BakerySimpleInfo({
    required this.id,
    required this.thumbnail,
    required this.name,
    required this.bakeryFeature,
    this.signitureBreads,
    this.description,
  });
  BakerySimpleInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        // thumbnail: json['thumbnail'],
        thumbnail = 'assets/breadImage.jpg',
        name = json['name'],
        description = json['description'],
        bakeryFeature = json['bakeryFeatures']
            .map((bakeryFeature) => bakeryFeature)
            .toList(),
        signitureBreads =
            json['signitureBreads']?.map((bread) => bread['name']).toList();

  @override
  String toString() {
    return 'name: $name,  description: $description, bakeryFeature: $bakeryFeature,  signitureBreads: $signitureBreads';
  }
}
