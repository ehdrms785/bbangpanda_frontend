import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "에러 발생 빵야~",
          style: TextStyle(fontSize: 30.0),
        ),
      ),
    );
  }
}
