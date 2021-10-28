import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerPageQuery.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DibsDrawerPageApi {
  /// Query
  ///
  static Future<dynamic> fetchDibsDrawerListApi({
    int? count,
  }) async {
    return await client.query(
      QueryOptions(
        document: gql(
          DibsDrawerPageQuery.getDibsDrawerListQuery(count: count),
        ),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  static Future<dynamic> fetchDibsDrawerItems({
    required int drawerId,
    int? cursorBreadId,
  }) async {
    return await client.query(
      QueryOptions(
        document: gql(
          DibsDrawerPageQuery.fetchDibsDrawerItemsQuery(),
        ),
        variables: {
          'drawerId': drawerId,
          ...(cursorBreadId == null ? {'cursorBreadId': cursorBreadId} : {}),
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  /// Mutation
  ///
  static Future<dynamic> createDibsDrawerApi({
    required String name,
  }) async {
    return await client.mutate(
      MutationOptions(
        document: gql(
          DibsDrawerPageQuery.createDibsDrawerMutation(),
        ),
        variables: {'name': name},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  static Future<dynamic> deleteDibsDrawerApi({
    required int id,
  }) async {
    return await client.mutate(
      MutationOptions(
        document: gql(
          DibsDrawerPageQuery.deleteDibsDrawerMutation(),
        ),
        variables: {'id': id},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  static Future<dynamic> changeDibsDrawerNameApi({
    required int id,
    required String name,
  }) async {
    return await client.mutate(
      MutationOptions(
        document: gql(
          DibsDrawerPageQuery.changeDibsDrawerNameMutation(),
        ),
        variables: {'id': id, 'name': name},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  static Future<dynamic> addItemToDrawerApi({
    required int drawerId,
    required int itemId,
  }) async {
    return await client.mutate(
      MutationOptions(
        document: gql(
          DibsDrawerPageQuery.addItemToDibsDrawerMutation(),
        ),
        variables: {'id': drawerId, 'itemId': itemId},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  static Future<dynamic> removeItemToDrawerApi({
    required int itemId,
  }) async {
    return await client.mutate(
      MutationOptions(
        document: gql(
          DibsDrawerPageQuery.removeItemToDibsDrawerMutation(),
        ),
        variables: {'itemId': itemId},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }
}
