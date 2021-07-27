import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/query.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:time/time.dart';

class FindPageApi {
  static Future<dynamic> fetchBakeryFilter() async {
    print("하이브 GraphQL 캐시 테스트");
    print(Hive.box('graphqlCache').get('bakeryFilter'));
    return await client.query(
      QueryOptions(
        document: gql(FindBakeryQuery.getBakeryFilterQuery),
        fetchPolicy: useCacheWithExpiration(key: 'bakeryFilter'),
      ),
    );
  }

  static Future<dynamic> fetchMarketOrderFilter() async {
    print("하이브 GraphQL 캐시 테스트");
    print(Hive.box('graphqlCache').get('marketOrderFilter'));
    return await client.query(
      QueryOptions(
        document: gql(FindBakeryQuery.getMarketOrderFilterQuery),
        fetchPolicy: useCacheWithExpiration(key: 'marketOrderFilter'),
      ),
    );
  }

  static Future<dynamic> fetchBreadFilter() async {
    // print("하이브 GraphQL 캐시 테스트");
    // print(Hive.box('graphqlCache').get('bakeryFilter'));
    return await client.query(
      QueryOptions(
        document: gql(FindBakeryQuery.getBreadFilterQuery),
        fetchPolicy: useCacheWithExpiration(key: 'breadFilter'),
      ),
    );
  }

  static Future<dynamic> fetchSimpleBakeriesInfo({
    String sortFilterId: '1', // 최신순
    required List<String> filterIdList,
    int? cursorBakeryId,
    bool? fetchMore = false,
  }) async {
    return await client.query(
      QueryOptions(
          document: gql(FindBakeryQuery.getSimpleBakeriesInfoQuery),
          variables: {
            'sortFilterId': sortFilterId,
            'filterIdList': filterIdList,
            ...(cursorBakeryId != 0
                ? ({'cursorBakeryId': cursorBakeryId})
                : {}),
          },
          fetchPolicy: fetchMore!
              ? FetchPolicy.networkOnly
              : FetchPolicy.cacheAndNetwork),
    );
  }

  static Future<dynamic> fetchSimpleMarketOrdersInfo({
    String sortFilterId: '1', // 최신순
    required List<dynamic> filterIdList,
    int? cursorMarketOrderId,
    bool? fetchMore = false,
  }) async {
    return await client.query(
      QueryOptions(
          document: gql(FindBakeryQuery.getSimpleMarketOrdersInfoQuery),
          variables: {
            'sortFilterId': sortFilterId,
            'filterIdList': filterIdList,
            ...(cursorMarketOrderId != 0
                ? ({'cursorMarketOrderId': cursorMarketOrderId})
                : {}),
          },
          fetchPolicy: fetchMore!
              ? FetchPolicy.networkOnly
              : FetchPolicy.cacheAndNetwork),
    );
  }

// largeCategoryId
// smallCategoryId
// sortFilterId
// filterIdList
// cursorId
  static Future<dynamic> fetchSimpleBreadsInfo({
    int? bakeryId,
    String? largeCategoryId,
    String? smallCategoryId,
    String sortFilterId: '1', //최신순
    List<dynamic>? filterIdList,
    int? cursorBreadId,
    bool fetchMore: false,
  }) async {
    return await client.query(
      QueryOptions(
          document: gql(FindBakeryQuery.getSimpleBreadsInfoQuery),
          variables: {
            ...(bakeryId != null ? ({'bakeryId': bakeryId}) : {}),
            ...(largeCategoryId != null
                ? ({'largeCategoryId': largeCategoryId})
                : {}),
            ...(smallCategoryId != null
                ? ({'smallCategoryId': smallCategoryId})
                : {}),
            'sortFilterId': sortFilterId,
            'filterIdList': filterIdList,
            ...(cursorBreadId != 0 ? ({'cursorBreadId': cursorBreadId}) : {}),
          },
          fetchPolicy: fetchMore
              ? FetchPolicy.networkOnly
              : FetchPolicy.cacheAndNetwork),
    );
  }

  static Future<dynamic> fetchSearchedSimpleBreadsInfo({
    required String searchTerm,
    String sortFilterId: '1', //최신순
    List<dynamic>? filterIdList,
    int? cursorBreadId,
    bool fetchMore: false,
  }) async {
    return await client.query(
      QueryOptions(
          document: gql(FindBakeryQuery.searchBreadsQuery),
          variables: {
            'searchTerm': searchTerm,
            'sortFilterId': sortFilterId,
            'filterIdList': filterIdList,
            ...(cursorBreadId != 0 ? ({'cursorBreadId': cursorBreadId}) : {}),
          },
          fetchPolicy: fetchMore
              ? FetchPolicy.networkOnly
              : FetchPolicy.cacheAndNetwork),
    );
  }

  static Future<dynamic> fetchSearchedSimpleBakeriesInfo({
    required String searchTerm,
    String sortFilterId: '1', //최신순
    required List<dynamic> filterIdList,
    int? cursorBakeryId,
    bool fetchMore: false,
  }) async {
    return await client.query(
      QueryOptions(
          document: gql(FindBakeryQuery.searchBakeriesQuery),
          variables: {
            'searchTerm': searchTerm,
            'sortFilterId': sortFilterId,
            'filterIdList': filterIdList,
            ...(cursorBakeryId != 0
                ? ({'cursorBakeryId': cursorBakeryId})
                : {}),
          },
          fetchPolicy: fetchMore
              ? FetchPolicy.networkOnly
              : FetchPolicy.cacheAndNetwork),
    );
  }

  static Future<dynamic> fetchSearchedSimpleMarketOrdersInfo({
    required String searchTerm,
    String sortFilterId: '1', //최신순
    required List<dynamic> filterIdList,
    int? cursorMarketOrderId,
    bool fetchMore: false,
  }) async {
    return await client.query(
      QueryOptions(
          document: gql(FindBakeryQuery.searchMarketOrdersQuery),
          variables: {
            'searchTerm': searchTerm,
            'sortFilterId': sortFilterId,
            'filterIdList': filterIdList,
            ...(cursorMarketOrderId != 0
                ? ({'cursorMarketOrderId': cursorMarketOrderId})
                : {}),
          },
          fetchPolicy: fetchMore
              ? FetchPolicy.networkOnly
              : FetchPolicy.cacheAndNetwork),
    );
  }

  static Future<dynamic> fetchBreadSmallCategories(
      {required String largeCategoryId}) async {
    print('여기봅싱: $largeCategoryId');
    return await client.query(
      QueryOptions(
          document: gql(FindBakeryQuery.getBreadSmallCategoriesQuery),
          variables: {'largeCategoryId': largeCategoryId},
          fetchPolicy: useCacheWithExpiration(
              key: 'breadSmallCategory$largeCategoryId', expiration: 12.hours)),
    );
  }

  // Fetch Bakery Detail
  static Future<dynamic> fetchBakeryDetail({
    required int bakeryId,
  }) async {
    return await client.query(
      QueryOptions(
          document: gql(FindBakeryQuery.getBakeryDetailQuery),
          variables: {
            'bakeryId': bakeryId,
          }),
    );
  }

  static Future<dynamic> toggleGetDibsBakery({
    required int bakeryId,
  }) async {
    return client.mutate(
      MutationOptions(
          document: gql(FindBakeryQuery.toggleDibsBakeryMutation),
          variables: {'bakeryId': bakeryId}),
    );
  }

  static Future<dynamic> toggleGetDibsBread({
    required int breadId,
  }) async {
    return client.mutate(
      MutationOptions(
          document: gql(FindBakeryQuery.toggleDibsBreadMutation),
          variables: {'breadId': breadId}),
    );
  }
}
