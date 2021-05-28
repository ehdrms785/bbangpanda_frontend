import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final String login = """
  mutation login(\$email: String, \$phonenumber: String, \$password: String!) {
    login(email: \$email, phonenumber: \$phonenumber, password: \$password) {
      ok
      error
      customToken
      customTokenExpired
      refreshToken
      refreshTokenExpired
     }
  }
""";

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    print("빌드 리빌드 테스트");
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: PrefferedAppBar(context),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Text("홈 화면"),
            ),
          ],
        ),
      ),
    );
  }
}
