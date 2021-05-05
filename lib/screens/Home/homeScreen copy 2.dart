import 'package:bbangnarae_frontend/SignUp/signUpScreen.dart';
import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/Login/loginScreen.dart';
import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height / 20),
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
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (!snapshot.hasData) {
              return LoginScreen();
            } else {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${snapshot.data?.phoneNumber}님 안녕하세요"),
                  TextButton(
                    onPressed: FirebaseAuth.instance.signOut,
                    child: Text("로그아웃"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final getIdToken = await FirebaseAuth.instance.currentUser
                          ?.getIdToken(true);
                      print(getIdToken);
                    },
                    child: Text("체크베이비"),
                  ),
                ],
              ));
            }
          },
        ));
  }
}
