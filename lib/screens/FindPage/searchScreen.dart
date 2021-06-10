import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("term : ${widget.term}");

    return Scaffold(
      appBar: AppBar(),
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.5, end: 0.0),
        curve: Curves.easeOutCubic,
        duration: const Duration(milliseconds: 1200),
        onEnd: () {
          print("Animation End");
        },
        builder: (context, value, child) {
          return Transform.translate(
              offset: Offset(value * 150, 0.0), child: child);
        },
        child: Container(
          child: Text("검색 페이지"),
        ),
      ),
    );
  }
}
