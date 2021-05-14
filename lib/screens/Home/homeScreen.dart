import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/Login/loginScreen.dart';
import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Login/loginScreen copy.dart';

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
            ElevatedButton(
              onPressed: () {
                Get.to(
                  PhoneSignInSection(),
                );
              },
              child: Text("테스트 클릭"),
            ),
          ],
        ),
      ),
    );
  }
}
