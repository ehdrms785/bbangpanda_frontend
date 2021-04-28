import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var name, password, token;
  @override
  Widget build(BuildContext? context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Phonenumber'),
          onChanged: (val) {
            name = val;
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
          onPressed: () => null,
          child: Text("Authenticated"),
        ),
      ],
    ));
  }
}
