import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/FindBread/support/query.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FindPageApi {
  static Future<dynamic> fetchFilteredBakeries(
      {required List<String> filterIdList,
      int? cursorId,
      bool? fetchMore = false}) async {
    return await client.query(
      QueryOptions(
          document: gql(FindBakeryQuery.getFilteredBakeryListQuery),
          variables: {
            'filterIdList': filterIdList,
            ...(cursorId != 0 ? ({'cursorId': cursorId}) : {}),
          },
          fetchPolicy: fetchMore!
              ? FetchPolicy.networkOnly
              : FetchPolicy.cacheAndNetwork),
    );
  }

  static Future<dynamic> fetchBakeryFilter() async {
    return await client.query(
      QueryOptions(
          document: gql(FindBakeryQuery.getBakeryFilterQuery),
          fetchPolicy: FetchPolicy.cacheAndNetwork),
    );
  }

  static Future<dynamic> fetchBreadFilter() async {
    return await client.query(
      QueryOptions(
          document: gql(FindBakeryQuery.getBakeryFilterQuery),
          fetchPolicy: FetchPolicy.cacheAndNetwork),
    );
  }
}
