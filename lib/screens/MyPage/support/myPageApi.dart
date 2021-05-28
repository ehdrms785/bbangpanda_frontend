import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/MyPage/support/query.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class MyPageApi {
  static Future<dynamic> fetchUserDetail() async {
    return client.query(QueryOptions(
      document: gql(MyPageQuery.userDetailQuery),
    ));
  }

  static Future<dynamic> fetchEditUserDetail() async {
    return client.query(QueryOptions(
      document: gql(MyPageQuery.editUserDetailQuery),
    ));
  }
}
