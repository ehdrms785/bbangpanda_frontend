import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ModalProgressScreen extends StatelessWidget {
  late final bool isAsyncCall;
  late final double opacity;
  late final Color color;
  late final Widget progressIndicator;
  late final Offset? offset;
  late final bool dismissible;
  late final Widget child;

  ModalProgressScreen({
    Key? key,
    required this.isAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.progressIndicator = const CircularProgressIndicator(),
    this.offset,
    this.dismissible = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext conteext) {
    if (!isAsyncCall) return child;
    Widget layoutProgressIndicator;
    if (offset == null) {
      layoutProgressIndicator = Center(child: progressIndicator);
    } else {
      layoutProgressIndicator = Positioned(
        child: progressIndicator,
        left: offset!.dx,
        top: offset!.dy,
      );
    }
    return new Stack(
      children: [
        child,
        Opacity(
          opacity: opacity,
          child: new ModalBarrier(
            dismissible: dismissible,
            color: color,
          ),
        ),
        Container(
          child: Center(child: layoutProgressIndicator),
        ),
      ],
    );
  }
}

PreferredSizeWidget PrefferedAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 20),
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
  );
}

Widget backArrowButtton({double? size}) {
  if (size == null) {
    size = 16.0.sp;
  }
  return SizedBox(
    child: IconButton(
      icon: Icon(Icons.arrow_back_ios_sharp),
      iconSize: size,
      color: Colors.grey.shade600,
      onPressed: () {
        Get.back();
      },
    ),
  );
}

Widget modalHeader({required String title}) {
  return Container(
    height: 5.0.h,
    child: Row(
      children: [
        backArrowButtton(),
        Container(
          width: 75.0.w,
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    ),
  );
}
