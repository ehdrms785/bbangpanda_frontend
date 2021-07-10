import 'package:flutter/material.dart';
import 'package:get/get.dart';

final SimpleMarketOrderFetchMinimum = 2;

abstract class MarketOrderModel extends GetxController {
  var firstInitLoading;
  var isLoading;
  var filterLoading;
  var hasMore;
  var isFetchMoreLoading;

  late RxList<dynamic> marketOrderFilterResult;
  late RxInt cursorMarketOrderId;
  late RxString sortFilterId; // 최신순
  late RxList<dynamic> filterIdList; // 제일 기본은 택배가능만 체크 된 상태
  late RxList<dynamic> tempFilterIdList;

  late final ScrollController scrollController;

  var simpleMarketOrdersListResult;

  get initFilterSelected;
  get applyFilterChanged;
  get refreshMarketOrderInfoData;
}

class MarketOrderSortFilter {
  final String id;
  final String filter;
  MarketOrderSortFilter({required this.id, required this.filter});
}

final List<MarketOrderSortFilter> MarketOrderSortFilters = [
  MarketOrderSortFilter(id: '1', filter: '최신순'),
  MarketOrderSortFilter(id: '2', filter: '인기순'),
  MarketOrderSortFilter(id: '3', filter: '마감임박순'),
];

class MarketOrderSimpleInfo {
  MarketOrderSimpleInfo({
    required this.id,
    required this.bakeryInfo,
    required this.orderName,
    required this.signitureBreadList,
    required this.lineUpBreads,
    required this.marketOrderFeatures,
    required this.orderStartDate,
    required this.orderEndDate,
  });
  // 여기에 ThunmbNail도 넣을지 말지는 고민 좀 해보자
  final int id;
  final SimpleBakeryInfo bakeryInfo;
  final String orderName;
  final List<SignitureBreadSimpleInfo> signitureBreadList;
  final List<LineUpBreadSimpleInfo> lineUpBreads;
  final List<MarketOrderFeature> marketOrderFeatures;
  final String orderStartDate;
  final String orderEndDate;

  MarketOrderSimpleInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bakeryInfo = SimpleBakeryInfo.fromJson(json['bakery']),
        orderName = json['orderName'],
        signitureBreadList = List<SignitureBreadSimpleInfo>.from(
            json['signitureBreads']
                .map((bread) => SignitureBreadSimpleInfo.fromJson(bread))),
        lineUpBreads = List<LineUpBreadSimpleInfo>.from(json['lineUpBreads']
            .map((bread) => LineUpBreadSimpleInfo.fromJson(bread))),
        marketOrderFeatures = List<MarketOrderFeature>.from(
            json['marketOrderFeatures'].map((marketOrderFeatureJson) =>
                MarketOrderFeature.fromJson(marketOrderFeatureJson))),
        orderStartDate = json['orderStartDate'],
        orderEndDate = json['orderEndDate'];
  // 여기             .map((bakeryFeature) => bakeryFeature).toList(),
  // 이렇게 해야 할 수도 있음 showBakeries에서는 이렇게 함
}

class MarketOrderFeature {
  MarketOrderFeature({required this.id, required this.filter});
  final String id;
  final String filter;

  MarketOrderFeature.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        filter = json['filter'];
}

class SimpleBakeryInfo {
  SimpleBakeryInfo({required this.id, required this.name});
  final int id;
  final String name;

  SimpleBakeryInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class LineUpBreadSimpleInfo {
  LineUpBreadSimpleInfo({required this.id, required this.name, this.thumbnail});
  final int id;
  final String name;
  final String? thumbnail;

  LineUpBreadSimpleInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        thumbnail = json['thumbnail'] ?? 'assets/breadImage.jpg';
}

class SignitureBreadSimpleInfo {
  SignitureBreadSimpleInfo(
      {required this.id, required this.name, this.thumbnail});
  final int id;
  final String name;
  final String? thumbnail;
  SignitureBreadSimpleInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        thumbnail = json['thumbnail'] ?? 'assets/breadImage.jpg';
}
