import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/Home/homeScreen%20copy%202.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';

final String createUserMutation = """
  mutation createUser(\$username: String!, \$email: String!, \$phonenumber: String!, \$password: String!) {
    createUser(username: \$username, email: \$email, phonenumber: \$phonenumber, password: \$password) {
        ok
        error
        customToken
        customTokenExpired
        refreshToken
     }
  }
""";

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var username, email, phoneNumber, password, token;
  @override
  Widget build(BuildContext? context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("회원가입"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Username'),
              onChanged: (val) {
                username = val;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (val) {
                email = val;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'phoneNumber'),
              onChanged: (val) {
                phoneNumber = val;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'password'),
              onChanged: (val) {
                password = val;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () async {
                await signUpWithServer(username, email, phoneNumber, password);
              },
              child: Text("Authenticated"),
            ),
          ],
        ));
  }
}

Future<UserCredential?> signUpWithServer(
    String username, String email, String phoneNumber, String password,
    [String? address]) async {
  try {
    // client.mutate(MutationOptions(document: )(
    final result = await client.mutate(MutationOptions(
      document: gql(createUserMutation),
      variables: {
        'username': username,
        'email': email,
        'address': address ?? '',
        'phonenumber': phoneNumber,
        'password': password
      },
    ));
    print('result');
    if (result.hasException) {
      print(result.exception);
      return null;
    }
    final createUserData = result.data?['createUser'];
    if (createUserData['ok']) {
      // print(createUserData['refreshToken']);
      // print(DateTime.now())
      Hive.box('auth').putAll({
        'refreshToken': createUserData['refreshToken'],
        'customTokenExpired': createUserData['customTokenExpired']
      });
      print("refershToken: ${Hive.box('auth').get('refreshToken')}");
      await FirebaseAuth.instance
          .signInWithCustomToken(createUserData['customToken']);
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      Hive.box('auth').put('token', idToken);
      GraphQLConfiguration.setToken(idToken!);

      Get.offAll(Home());
      // print(firebaseLoginResult);
      // print(idToken);
    } else {
      print("계정 생성 실패");
    }
    // ))
    // var result = await FirebaseAuth.instance.signInWithCustomToken(
    //     "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTYxOTY1NzQyMCwiZXhwIjoxNjE5NjYxMDIwLCJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay00NHlhNEBiYmFuZ25hcmFlLTQ4ODk3LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwic3ViIjoiZmlyZWJhc2UtYWRtaW5zZGstNDR5YTRAYmJhbmduYXJhZS00ODg5Ny5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsInVpZCI6IjE3In0.Wd8lpc6rRdJxEr1BWu7C8qvyiL1h6KXCaByXSKFG7V2_INyVojNhx-ClkWmAls_1GHUmNCVSE5BJw8tbKKdm2WW13jL1KCfClYI8taZK1CCPyuh7qU3LTf-h7QViy1x6RCT5HQENy-TpxBHhzfLaXKmH0ihhM4tlyxhLQgQXZBcA4W78OD8KWu5ULn9GGuzZCcz-_AhNgeKMsKGZoSoorsFdR8ZVDWtE_rRFtbShbgRwxNNmV5FQMD6pq5WqxPGYpNHeV_CDlXRLn5-5yGQzutOBRHBDN_UXFpQncQ7GNnA6uHYkO43OnxLNotVG_EIQ82ahOMBU0_xrD9ddCydS1A");
    // print("헬로월드");
    // print(result);
    // FirebaseAuth.instance.signInWithCustomToken();
  } catch (e) {
    print(e);
  }
  return null;
}
