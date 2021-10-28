// ignore_for_file: invalid_use_of_protected_member

import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerMainScreen/DibsDrawerMainController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/showBakeriesTab.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/showBreadsTab.dart';
import 'package:bbangnarae_frontend/screens/FindPage/findpageScreenController.dart';
import 'package:bbangnarae_frontend/screens/MyPage/myPageController.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/query.dart';
import 'package:bbangnarae_frontend/shared/sharedClass.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:time/time.dart';

Future<bool> internetCheck() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // data(3G 4G)
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // wifi
    return true;
  }
  showError(title: "XE00000", message: "인터넷 연결을 확인 해 주세요.");
  return false;
}

void logout() async {
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
  HiveStore().reset();

  initEntireSetting();
}

// 로그인 or 로그아웃을 했을때 Get.reloadAll이나 reset을 하더라도
// AutomaticKeepAlive State 는 그대로 유지 된다(스크롤 포함)
// 그래서 그 때, keepAlive 값을 바꿔 줌으로써 다시 Page가 빌드 되도록 하는 로직
void initEntireSetting() {
  Get.reloadAll();

  final ShowBakeriesTabState? _showBakeriesTab = ShowBakeriesTabState.globalKey;
  if (_showBakeriesTab != null) {
    _showBakeriesTab.controller.isLogStateChange = true;
    _showBakeriesTab.updateKeepAlive();
  }

  final ShowBreadsTabState? _showBreadsTab = ShowBreadsTabState.globalKey;
  if (_showBreadsTab != null) {
    _showBreadsTab.controller.isLogStateChange = true;
    _showBreadsTab.updateKeepAlive();
  }
}

Future<bool> tokenCheck() async {
  return Future(() async {
    // print('expiredTime:${Hive.box('auth').get('expiredTime')}');
    // Node 서버가 Flutter 클라이언트 서버 200초 느리다. 이유는 모르겠지만
    // 그래서 200초 마이너스
    // ==> 맥북에서 했는데 문제 없었음 취소
    var nowTime = ((DateTime.now().millisecondsSinceEpoch) / 1000).floor();
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
      print("여기까지오나?");
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

void initBinding() {
  Get.put(AuthController(), permanent: true);
  // Get.put(DibsDrawerMainController());
  Get.lazyPut(() => DibsDrawerMainController());
  Get.lazyPut(() => MypageController());
  Get.lazyPut(() => FindPageScreenController());
  // Get.lazyPut(() => DibsDrawerMainController());
}

void makeErrorBoxAndShow({required String error}) {
  final _splitedError = error.split('\n');
  final ErrorBox _errorBox =
      ErrorBox(errorCode: _splitedError[0], errorMessage: _splitedError[1]);
  showError(title: _errorBox.errorCode, message: _errorBox.errorMessage);
}
