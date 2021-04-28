import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
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
        body: Container(
          child: Center(
              child: Text("여기는 장바구니",
                  style: Theme.of(context).textTheme.headline2)),
          color: Colors.cyan,
        ));
  }
}
