import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';

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

class NearBakery extends StatefulWidget {
  @override
  _NearBakeryState createState() => _NearBakeryState();
}

class _NearBakeryState extends State<NearBakery> {
  @override
  Widget build(BuildContext context) {
    // LocalStorage('newUser').setItem('token', 'Cool token');
    // print(GraphQLConfiguration.httpLink.defaultHeaders);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 20),
        child: AppBar(
          actions: [IconButton(icon: Icon(Icons.ac_unit), onPressed: () {})],
          //AppBar Shadow를 사라져보이게 하기 !
          shadowColor: Colors.transparent,
          centerTitle: true,
          // backgroundColor: Colors.red,
          title: ValueListenableBuilder(
            valueListenable: p_appBarTitleValueNotifier,
            builder: (context, String title, _) {
              return Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: Mutation(
        options: MutationOptions(
          document: gql(EditProfileMutation),
          onCompleted: (dynamic resultData) async {
            print("on Complete");
            print(resultData);
            if (resultData == null) {
              return;
            }
          },
        ),
        builder: (runMutation, result) {
          if (result == null) {
            return Text("Hi");
          }
          if (result.isLoading) {
            return Text("Loading");
          }
          return Container(
              child: FloatingActionButton(
            onPressed: () async {
              final ok = await tokenCheck();
              if (!ok) {
                print("리턴");
                return;
              }
              runMutation({'address': '오송임돵ㅋㅋss'});
            },
            child: Icon(Icons.star),
          ));
        },
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
              // print(result);
              // await Hive.box('auth').put('token', reissueTokenResult['token']);
              // await Hive.box('auth')
              //     .put('expiredTime', reissueTokenResult['expiredTime']);
              print("현재");

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
