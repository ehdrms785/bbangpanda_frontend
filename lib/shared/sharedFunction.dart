import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/query.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:time/time.dart';

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
    'token': '',
    'tokenExpired': '',
    'refreshToken': '',
    'refreshTokenExpired': ''
  });
  GraphQLConfiguration.setToken(null);
  Get.find<AuthController>().isLoggedIn.value = false;
  FirebaseAuth.instance.signOut();
  Get.until((route) => route.isFirst);
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
    final tokenExpiredTime = Hive.box('auth').get('tokenExpired');
    if (tokenExpiredTime == null) return false;
    if (nowTime + 600 > tokenExpiredTime) {
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
            print("들어왔나?");
            final newToken =
                await FirebaseAuth.instance.currentUser?.getIdToken(true);
            print('newToken: $newToken');
            await Hive.box('auth').putAll({
              'token': newToken,
              'tokenExpired':
                  (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
            });
            Get.find<AuthController>().isLoggedInStateChange(true);
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

int signCodeResendTimeCheck(int resendPossibleTime) {
  int _remainSeconds =
      ((resendPossibleTime - (new DateTime.now().millisecondsSinceEpoch)) /
              1000)
          .round();
  print('_reaminSeconds: $_remainSeconds');
  if (_remainSeconds > 0 && Get.isSnackbarOpen == false) {
    showSnackBar(
        message: "인증번호 재발송은 자주 할 수 없습니다.\n$_remainSeconds 초 후에 시도 해 주세요.");
  }
  return _remainSeconds;
}

String priceToString(int price) =>
    price.toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');

FetchPolicy useCacheWithExpiration(
    {Duration? expiration, required String key, bool isRefresh: false}) {
  if (expiration == null) expiration = 30.minutes;

  var fetchPolicy = FetchPolicy.cacheOnly.obs;

  void cachingLastFetchTime() {
    Hive.box('graphqlCache')
        .put(key, (expiration!.fromNow).millisecondsSinceEpoch);
    fetchPolicy(FetchPolicy.networkOnly);
  }

  if (isRefresh) {
    cachingLastFetchTime();
  } else {
    try {
      var lastFetchTime = Hive.box('graphqlCache').get(key);

      if (lastFetchTime == null ||
          lastFetchTime < DateTime.now().millisecondsSinceEpoch) {
        cachingLastFetchTime();
      } else {
        fetchPolicy(FetchPolicy.cacheFirst);
      }
    } catch (e) {
      fetchPolicy(FetchPolicy.networkOnly);
    }
  }
  print("FetchPolicy: ${fetchPolicy.value}");
  return fetchPolicy.value;
}

int calcEntirePeriod(DateTime startDate, DateTime endDate) {
  int calcResult =
      (endDate.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch) ~/
          3600000; // 3600초 (시간)
  if (calcResult <= 0) return 0;
  return calcResult;
}

int calcRemainedHours(DateTime endDate) {
  int calcResult = (endDate.millisecondsSinceEpoch -
          DateTime.now().millisecondsSinceEpoch) ~/
      3600000;
  if (calcResult <= 0) return 0;
  return calcResult;
}
