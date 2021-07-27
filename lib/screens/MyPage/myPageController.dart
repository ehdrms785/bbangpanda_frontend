import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/MyPage/support/myPageApi.dart';
import 'package:bbangnarae_frontend/screens/MyPage/support/query.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MypageController extends GetxController {
  var isLoading = true.obs;
  // ignore: deprecated_member_use
  var userResult = Map<String, dynamic>().obs;
  @override
  void onInit() {
    print("체크4");
    if (Get.find<AuthController>().isLoggedIn.value == true) {
      fetchUserDetail();
    }
    super.onInit();
  }

  void fetchUserDetail() async {
    try {
      isLoading(true);
      var QueryRequest = Request(
          operation: Operation(
        document: gql(MyPageQuery.userDetailQuery),
      ));
      var cache = client.cache.readQuery(QueryRequest);
      print('cache');
      print(cache);
      var fetchNetwork = false;
      if (cache == null) {
        print('cache : null');
        fetchNetwork = true;
      } else {
        if (cache['userDetail'] == null) {
          print('UserDetail : null');
          fetchNetwork = true;
        }
      }

      print('fetchNetwork: $fetchNetwork');
      // cache!.update('userDetail', (value) => null);
      // client.writeQuery(QueryRequest, data: cache);

      // final cache2 = client.cache.readQuery(QueryRequest);
      // print('cache');
      // print(cache2);
      final result =
          await MyPageApi.fetchUserDetail(fetchNetwork: fetchNetwork);
      if (result != null) {
        print(result);
        print(result.runtimeType);
        print(result.data);
        userResult.value = result.data['userDetail'];
        print(userResult);
      } else {
        print("Result 없습니다");
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
