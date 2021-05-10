import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrefferedAppBar(context),
        body: Container(
          child: Center(
              child: Text("여기는 장바구니",
                  style: Theme.of(context).textTheme.headline2)),
          color: Colors.cyan,
        ));
  }
}
