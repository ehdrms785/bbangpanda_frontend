import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/MyPage/support/query.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class MyPageApi {
  static Future<dynamic> fetchUserDetail({bool fetchNetwork: false}) async {
    return client.query(
      QueryOptions(
        document: gql(MyPageQuery.userDetailQuery),
        // fetchPolicy: FetchPolicy.cacheAndNetwork
        fetchPolicy:
            fetchNetwork ? FetchPolicy.networkOnly : FetchPolicy.cacheFirst,
      ),
    );
  }

  static Future<dynamic> fetchEditUserDetail() async {
    return client.query(QueryOptions(
      document: gql(MyPageQuery.editUserDetailQuery),
    ));
  }
}
