import 'dart:math';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BakeryDetailMainScreen extends StatefulWidget {
  @override
  _BakeryDetailMainScreenState createState() => _BakeryDetailMainScreenState();
}

class _BakeryDetailMainScreenState extends State<BakeryDetailMainScreen>
    with TickerProviderStateMixin {
  late AnimationController _ColorAnimationController;
  late AnimationController _TextAnimationController;
  late Animation _colorTween, _iconColorTween;
  late Animation<Offset> _transTween;

  @override
  void initState() {
    _ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Color(0xFFee4c4f))
        .animate(_ColorAnimationController);
    _iconColorTween = ColorTween(begin: Colors.grey, end: Colors.white)
        .animate(_ColorAnimationController);

    _TextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _transTween = Tween(begin: Offset(-10, 40), end: Offset(-10, 0))
        .animate(_TextAnimationController);

    super.initState();
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _ColorAnimationController.animateTo(scrollInfo.metrics.pixels / 350);

      _TextAnimationController.animateTo(
          (scrollInfo.metrics.pixels - 350) / 50);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: Container(
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50.0.h,
                      color:
                          Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                              .withOpacity(1),
                      width: 250,
                    ),
                    Container(
                      height: 50.0.h,
                      color: Colors.pink,
                      width: 250,
                    ),
                    Container(
                      height: 50.0.h,
                      color: Colors.deepOrange,
                      width: 250,
                    ),
                    Container(
                      height: 50.0.h,
                      color: Colors.red,
                      width: 250,
                    ),
                    Container(
                      height: 50.0.h,
                      color: Colors.white70,
                      width: 250,
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                child: AnimatedBuilder(
                  animation: _ColorAnimationController,
                  builder: (context, child) => AppBar(
                    backgroundColor: _colorTween.value,
                    elevation: 0,
                    titleSpacing: 0.0,
                    title: Transform.translate(
                      offset: _transTween.value,
                      child: Text(
                        "اسم کالا اینجا",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    iconTheme: IconThemeData(
                      color: _iconColorTween.value,
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.local_grocery_store,
                        ),
                        onPressed: () {
//                          Navigator.of(context).push(TutorialOverlay());
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_vert,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
