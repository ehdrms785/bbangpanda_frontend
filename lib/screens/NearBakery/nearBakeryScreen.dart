import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/shared/publicValues.dart';
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
          token
          expiredTime
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
    // print(LocalStorage('newUser').getItem('token'));
    // GraphQLConfiguration.setToken(LocalStorage('newUser').getItem('token'));
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
              await tokenCheck();
              runMutation({'address': '오송임돵ㅋㅋss'});
            },
            child: Icon(Icons.star),
          ));
        },
      ),
    );
  }

  Future tokenCheck() {
    return Future(() async {
      // print('expiredTime:${Hive.box('auth').get('expiredTime')}');
      var nowTime = ((DateTime.now().millisecondsSinceEpoch) / 1000).floor();
      // print('nowTime:$nowTime');
      // print(
      //     'expire Time - nowTime = ${Hive.box('auth').get('expiredTime') - nowTime}');
      if (Hive.box('auth').get('expiredTime') - 1800 < nowTime) {
        var result = await client.mutate(
          MutationOptions(document: gql(ReissueTokenMutation), variables: {
            'refreshToken': Hive.box('auth').get('refreshToken')
          }),
        );
        //         var ok = resultData['login']['ok'];
        // print(ok);
        // if (ok) {
        //   String token = resultData['login']['token'];
        //   int expiredTime = resultData['login']['expiredTime'];
        //   String refreshToken = resultData['login']['refreshToken'];

        if (result.data != null) {
          var reissueTokenResult = result.data?['reissueToken'];
          var ok = reissueTokenResult['ok'];
          // print(ok);
          if (ok) {
            // print(result);
            await Hive.box('auth').put('token', reissueTokenResult['token']);
            await Hive.box('auth')
                .put('expiredTime', reissueTokenResult['expiredTime']);
            String refToken = reissueTokenResult['refreshToken'];
            if (refToken.isNotEmpty) {
              // print("RefToken 커몬");
              await Hive.box('auth').put('RefreshToken', refToken);
            }
            // print(((DateTime.now().millisecondsSinceEpoch) / 1000).floor());
            // print(Hive.box('auth').get('expiredTime'));
            // print(((DateTime.now().millisecondsSinceEpoch) / 1000).floor() -
            //     Hive.box('auth').get('expiredTime'));
          }
        }
      }
    });
    // client.mutate(
    //   MutationOptions(document: gql(Reis))
    // )
    // JWT.verify(token,);

    // var result = await GraphQLConfiguration().clientToQuery().mutate(
    //       MutationOptions(document: gql(ReissueTokenMutation), variables: {
    //         'token': Hive.box('auth').get('token'),
    //         'refreshToken': Hive.box('auth').get('refreshToken')
    //       }),
    //     );

    // print(result);
    // return queryFunc;
  }
}
