import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrefferedAppBar(title: '장바구니'),
        body: Container(
          child: Center(
              child: Text("여기는 장바구니",
                  style: Theme.of(context).textTheme.headline2)),
          color: Colors.cyan,
        ));
  }
}
