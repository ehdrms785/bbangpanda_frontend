import 'package:bbangnarae_frontend/shared/sharedValues.dart';
import 'package:bbangnarae_frontend/theme/textFieldTheme.dart';
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
        valueListenable: SharedValues.p_appBarTitleValueNotifier,
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

Widget backArrowButtton({double? size, void Function()? onPressed}) {
  if (size == null) {
    size = 16.0.sp;
  }
  return SizedBox(
    child: IconButton(
      icon: Icon(Icons.arrow_back_ios_sharp),
      iconSize: size,
      color: Colors.grey.shade600,
      onPressed: onPressed != null
          ? onPressed
          : () {
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
    this.bottom,
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
  final PreferredSizeWidget? bottom;
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
      bottom: bottom,
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

Widget MyAppBar({required String title}) => Column(
      children: [
        Column(
          children: [
            Container(
              height: 6.0.h,
              padding: EdgeInsets.symmetric(vertical: 1.0.h),
              // color: Colors.blue.shade600,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 14.0.sp,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                      color: Colors.white12,
                      width: 10.0.w,
                      child: IconButton(
                        icon: Icon(Icons.clear),
                        color: Colors.grey.shade600,
                        onPressed: () {
                          Get.back();
                        },
                        padding: const EdgeInsets.all(0),
                      ))
                ],
              ),
            ),
            Divider(
              indent: 0.0,
              height: 0.0,
              thickness: 0.2.h,
            ),
            SizedBox(height: 2.0.h)
          ],
        ),
      ],
    );

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
Widget removeTextFieldIcon(TextEditingController controller) {
  return Container(
    width: 5.0.w,
    child: GestureDetector(
      onTap: () {
        controller.clear();
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Icon(Icons.clear),
      ),
    ),
  );
}

Widget secureTextFieldIcon(Rx<bool?> isSecureObs) {
  return Container(
    width: 5.0.w,
    child: GestureDetector(
      onTap: () {
        isSecureObs.value = !isSecureObs.value!;
      },
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.all(2.0),
          child: isSecureObs.value!
              ? Icon(Icons.lock_rounded)
              : Icon(Icons.lock_open_rounded),
        ),
      ),
    ),
  );
}

Widget commonTextField({
  required String label,
  required TextEditingController controller,
  String? originValue,
  bool enabled = true,
  bool readOnly = false,
  Widget? additional,
  void Function()? onTap,
  void Function(String)? onChanged,
}) {
  if (originValue != null) {
    controller.text = originValue;
  }
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: !enabled ? Colors.grey.shade400 : null,
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextFormField(
              onTap: onTap,
              controller: controller,
              onChanged: onChanged,
              readOnly: readOnly,
              style: textFieldTextStyle(enabled),
              decoration: textFieldInputDecoration,
            ),
          ),
          if (additional != null) additional,
        ],
      ),
      SizedBox(
        height: 3.0.h,
      ),
    ],
  );
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({Key? key, required this.child}) : super(key: key);

  @override
  __KeepAliveWrapperState createState() => __KeepAliveWrapperState();
}

class __KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
