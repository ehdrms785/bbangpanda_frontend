import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:bbangnarae_frontend/theme/buttonTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final String EditProfileMutation = """
  mutation editProfile(\$username: String, \$phonenumber: String, \$address: String) {
    editProfile(username: \$username, phonenumber: \$phonenumber, address: \$address) {
        ok
        error
     }
  }
""";
final String ReissueTokenMutation = """
  mutation reissueToken(\$refreshToken: String!) {
    reissueToken(refreshToken: \$refreshToken) {
          ok
          refreshToken
          error
     }
  }
""";
late final QueryOptions options = QueryOptions(
  document: gql(EditProfileMutation),
  variables: {'username': '다로'},
  fetchPolicy: FetchPolicy.cacheFirst,
  cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,

  // pollInterval: Duration(seconds: 5),
);

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // final _auth = FirebaseAuth.instance;

  // @override
  // void initState() {
  //   _auth.userChanges().listen((User? user) {
  //     print("유저변경 체크중");
  //     print(user);
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
//     FirebaseAuth.instance.onAuthStateChanged(function(user) {
//   if (user) {
//     // User is signed in.
//   } else {
//     // No user is signed in.
//   }
// });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MySliverAppBar(title: "마이페이지", isLeading: false),
          SliverFillRemaining(
            child: Obx(
              () {
                if (Get.find<AuthController>().isLoggedIn.value == false) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.0.w, vertical: 1.0.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 10.0.h,
                          child: Row(
                            children: [
                              Container(
                                // color: Colors.blue.shade400,
                                width: 48.0.w,
                                height: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "빵판다 회원이 되시면",
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12.5.sp,
                                      ),
                                    ),
                                    SizedBox(height: 1.0.h),
                                    Text(
                                      "다양한 혜택이 기다려요!",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0.sp,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                // color: Colors.grey,
                                width: 48.0.w,
                                height: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed('/login');
                                      },
                                      child: Text("로그인"),
                                      style: textButtonRoundedBorder,
                                    ),
                                    SizedBox(width: 2.5.w),
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed('/signUp');
                                      },
                                      child: Text("회원가입"),
                                      style: textButtonRoundedBorder,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Get.find<AuthController>().isLoggedIn.value = true;
                          },
                          child: Text("로그인"),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Center(child: Text("로그인 해야함")),
                      ),
                      TextButton(
                        onPressed: logout,
                        child: Text("로그아웃"),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );

    // },
  }

  Future<bool> tokenCheck() {
    return Future(() async {
      // print('expiredTime:${Hive.box('auth').get('expiredTime')}');
      // Node 서버가 Flutter 클라이언트 서버 200초 느리다. 이유는 모르겠지만
      // 그래서 200초 마이너스
      var nowTime =
          ((DateTime.now().millisecondsSinceEpoch) / 1000).floor() - 200;

      // Refresh Token Expired 체크 (604800 1주일)
      if (nowTime + 600 > Hive.box('auth').get('customTokenExpired')) {
        var result = await client.mutate(
          MutationOptions(document: gql(ReissueTokenMutation), variables: {
            'refreshToken': Hive.box('auth').get('refreshToken')
          }),
        );
        print(result);
        if (result.data != null) {
          var reissueTokenResult = result.data?['reissueToken'];
          // print(ok);
          try {
            if (reissueTokenResult['ok']) {
              final newCustomToken =
                  await FirebaseAuth.instance.currentUser?.getIdToken(true);
              await Hive.box('auth').putAll({
                'token': newCustomToken,
                'customTokenExpired':
                    (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
              });
              GraphQLConfiguration.setToken(Hive.box('auth').get('token'));
              String? refToken = reissueTokenResult['refreshToken'];
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
}

class ModalSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new FlatButton(
        onPressed: () => Navigator.of(context).pushNamed('/test'),
        child: const Text('test'),
      ),
    );
  }
}

class TestModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: const Text('modal routing test'),
      ),
    );
  }
}
