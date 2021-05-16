import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/query.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';

Future<bool> internetCheck() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // data
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // wifi
    return true;
  }
  return false;
}

void logout() {
  Hive.box('auth').putAll({
    'token': null,
    'tokenExpired': null,
    'refreshToken': null,
    'refreshTokenExpired': null
  });
  GraphQLConfiguration.setToken(null);
  Get.find<AuthController>().isLoggedIn.value = false;
  FirebaseAuth.instance.signOut();
}

Future<bool> tokenCheck() async {
  return Future(() async {
    // print('expiredTime:${Hive.box('auth').get('expiredTime')}');
    // Node 서버가 Flutter 클라이언트 서버 200초 느리다. 이유는 모르겠지만
    // 그래서 200초 마이너스
    var nowTime =
        ((DateTime.now().millisecondsSinceEpoch) / 1000).floor() - 200;

    // Token 만료시간이 10분 이하로 남았을 때
    print('tokenExpired: ${Hive.box('auth').get('tokenExpired')}');
    print('nowTime: $nowTime');
    if (nowTime + 600 > Hive.box('auth').get('tokenExpired')) {
      final result = await client.mutate(
        MutationOptions(
            document: gql(Queries.reissueTokenMutation),
            variables: {'refreshToken': Hive.box('auth').get('refreshToken')}),
      );
      print(result);
      if (result.hasException) {
        return false;
      }
      if (result.data != null) {
        final reissueTokenResult = result.data?['reissueToken'];
        // print(ok);
        try {
          if (reissueTokenResult['ok']) {
            final newToken =
                await FirebaseAuth.instance.currentUser?.getIdToken(true);
            await Hive.box('auth').putAll({
              'token': newToken,
              'tokenExpired':
                  (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
            });
            GraphQLConfiguration.setToken(Hive.box('auth').get('token'));
            final String? refToken = reissueTokenResult['refreshToken'];
            if (refToken != null) {
              print("RefToken 커몬");
              await Hive.box('auth').putAll(
                {
                  'refreshToken': refToken,
                  'refreshTokenExpired':
                      reissueTokenResult['refreshTokenExpired']
                },
              );
            }
            return true;
          } else {
            return false;
            // 로그아웃 시키고 재 인증 받도록 !
          }
        } catch (err) {
          print(err);
          return false;
        }
      }
    }
    return true;
  });
}
