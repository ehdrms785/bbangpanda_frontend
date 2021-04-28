import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final String loginMutation = """
  mutation login(\$email: String, \$phonenumber: String, \$password: String!) {
    login(email: \$email, phonenumber: \$phonenumber, password: \$password) {
        ok
        error
        token
        expiredTime
        refreshToken
     }
  }
""";

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
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
            document: gql(loginMutation),
            onCompleted: (dynamic resultData) {
              print("on Complete");
              print(resultData);
              if (resultData == null) {
                print("무선일이고");
                return;
              }
              var ok = resultData['login']['ok'];
              print(ok);
              if (ok) {
                String token = resultData['login']['token'];
                int expiredTime = resultData['login']['expiredTime'];
                String refreshToken = resultData['login']['refreshToken'];
                print(token);
                print(expiredTime);
                print(refreshToken);
                GraphQLConfiguration.setToken(token);
                Hive.box('auth').put('token', token);
                Hive.box('auth').put('expiredTime', expiredTime);
                Hive.box('auth').put('refreshToken', refreshToken);
                // print(Hive.box('auth').get('token'));
              }
            }),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          // print(runMutation);
          // runMutation({'username': 'daro', 'password': 'daro1234'});
          if (result == null) {
            return Text("Hi");
          }
          if (result.isLoading) {
            return Text("Loading");
          }
          // if (result.data == null) {
          //   return Text("No Data Found");
          // }

          // print(result.data);
          // print(runMutation);
          return Container(
              child: FloatingActionButton(
            onPressed: () => runMutation(
                {'phonenumber': '01048880560', 'password': 'daro1234'}),
            child: Icon(Icons.star),
          ));
        },
      ),
    );
  }
}
