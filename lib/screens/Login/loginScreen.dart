import 'package:bbangnarae_frontend/SignUp/signUpScreen.dart';
import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;

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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var phoneNumber, password, token;
  @override
  Widget build(BuildContext? context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'PhoneNumber'),
          onChanged: (val) {
            phoneNumber = val;
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Password'),
          onChanged: (val) {
            password = val;
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        ElevatedButton(
          onPressed: () => {signInWithServer(phoneNumber, password)},
          child: Text("Authenticated"),
        ),
        ElevatedButton(
          onPressed: () {
            Get.to(SignUpScreen());
          },
          child: Text("SignUp"),
        ),
      ],
    ));
  }
}

Future<UserCredential?> signInWithServer(
    String phoneNumber, String password) async {
  try {
    final result =
        await client.mutate(MutationOptions(document: gql(login), variables: {
      // 'email':
      'phonenumber': phoneNumber,
      'password': password
    }));
    if (result.hasException) {
      print("에러발생");
      return null;
    }
    if (result.data != null) {
      final loginResult = result.data?['login'];
      if (loginResult['ok']) {
        try {
          await FirebaseAuth.instance
              .signInWithCustomToken(loginResult['customToken']);
          final token = await FirebaseAuth.instance.currentUser?.getIdToken();
          Hive.box('auth').putAll({
            'token': token,
            'tokenExpired': loginResult['customTokenExpired'],
            'refreshToken': loginResult['refreshToken'],
            'refreshTokenExpired': loginResult['refreshTokenExpired']
          });
          GraphQLConfiguration.setToken(token!);
        } catch (err) {
          print("에러발생");
          print(err);
          return null;
        }
      } else {
        print(loginResult['error']);
      }
    }
    // FirebaseAuth.instance.signInWithCustomToken();
  } catch (e) {
    print(e);
  }
  return null;
}
