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

class MySliverAppBar extends StatelessWidget {
  const MySliverAppBar({
    Key? key,
    required this.title,
    this.centerTitle = true,
    this.automaticallyImplyLeading = false,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.stretch = false,
    this.elevation = 1.0,
    this.shadowColor = Colors.black,
    this.leading,
    this.actions,
    this.forceElevated = true,
    this.backgroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.shape,
    this.titleTextStyle,
    this.isLeading = true,
  }) : super(key: key);

  final Widget? leading;
  final bool automaticallyImplyLeading;
  final String title;
  final List<Widget>? actions;
  final double? elevation;
  final Color? shadowColor;
  final bool forceElevated;
  final Color? backgroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final TextTheme? textTheme;
  final bool? centerTitle;
  final bool floating;
  final bool pinned;
  final ShapeBorder? shape;
  final bool snap;
  final bool stretch;
  final TextStyle? titleTextStyle;
  final bool isLeading;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.0.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      floating: floating,
      pinned: pinned,
      snap: snap,
      stretch: stretch,
      elevation: elevation,
      shadowColor: shadowColor,
      leading: isLeading ? leading ?? defaultLeading() : null,
      actions: actions,
      forceElevated: forceElevated,
      backgroundColor: backgroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      textTheme: textTheme,
      shape: shape,
      titleTextStyle: titleTextStyle,
    );
  }

  Widget defaultLeading() => SizedBox(
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          iconSize: 16.0.sp,
          color: Colors.grey.shade600,
          onPressed: () {
            Get.back();
          },
        ),
      );
}

Widget FormContainer({required Widget child}) {
  return Column(
    children: [
      SizedBox(
        height: 4.0.h,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0.w),
        child: child,
      )
    ],
  );
}

Widget MakeGap() => Column(
      children: [
        Divider(
          indent: 0.0,
          thickness: 1.0,
          height: 0.0,
        ),
        SizedBox(
          height: 2.0.h,
        )
      ],
    );
