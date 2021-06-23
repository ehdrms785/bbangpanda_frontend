import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/query.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:time/time.dart';

class FindPageApi {
  static Future<dynamic> fetchSimpleBakeriesInfo({
    String sortFilterId: '1', // 최신순
    List<String>? filterIdList,
    int? cursorId,
    bool? fetchMore = false,
  }) async {
    return await client.query(
      QueryOptions(
          document: gql(FindBakeryQuery.getSimpleBakeriesInfoQuery),
          variables: {
            'sortFilterId': sortFilterId,
            'filterIdList': filterIdList,
            ...(cursorId != 0 ? ({'cursorId': cursorId}) : {}),
          },
          fetchPolicy: fetchMore!
              ? FetchPolicy.networkOnly
              : FetchPolicy.cacheAndNetwork),
    );
  }

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

// largeCategoryId
// smallCategoryId
// sortFilterId
// filterIdList
// cursorId
  static Future<dynamic> fetchSimpleBreadsInfo({
    String? largeCategoryId,
    String? smallCategoryId,
    String sortFilterId: '1', //최신순
    List<dynamic>? filterIdList,
    int? cursorId,
    bool fetchMore: false,
  }) async {
    return await client.query(
      QueryOptions(
          document: gql(FindBakeryQuery.getSimpleBreadsInfoQuery),
          variables: {
            ...(largeCategoryId != null
                ? ({'largeCategoryId': largeCategoryId})
                : {}),
            ...(smallCategoryId != null
                ? ({'smallCategoryId': smallCategoryId})
                : {}),
            'sortFilterId': sortFilterId,
            'filterIdList': filterIdList,
            ...(cursorId != 0 ? ({'cursorId': cursorId}) : {}),
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
}
