import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
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
      appBar: PrefferedAppBar(context),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),

        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (!snapshot.hasData) {
            // 로그인 하지 않은 기본 화면 제공
            // return
            // Queries.loginQuery
          }
          return SingleChildScrollView(
            child: Container(
              height: 90.0.h,
              color: Colors.red.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Text("${snapshot.data?.phoneNumber}님 안녕하세요")),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/login');
                    },
                    child: Text("로그인"),
                  ),
                  TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: Text("로그아웃"))
                ],
              ),
            ),
          );
        },
        // },
      ),
    );
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
