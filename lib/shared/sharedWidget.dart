import 'package:bbangnarae_frontend/shared/sharedValues.dart';
import 'package:bbangnarae_frontend/theme/textFieldTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
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
    preferredSize: Size.fromHeight(5.0.h),
    child: AppBar(
      actions: [IconButton(icon: Icon(Icons.ac_unit), onPressed: () {})],
      //AppBar Shadow를 사라져보이게 하기 !
      // shadowColor: Colors.transparent,
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

PreferredSizeWidget MainAppBar({
  required RxBool isShowAppBar,
  String? title,
  Widget? leading,
  List<Widget>? actions,
}) =>
    PreferredSize(
      preferredSize: Size.fromHeight(5.0.h),
      child: Obx(
        () => AnimatedContainer(
          height: isShowAppBar.value ? 5.0.h : 0.0,
          duration: Duration(milliseconds: 200),
          child: AppBar(
            title: title != null ? Text(title) : null,
            centerTitle: true,
            leading: leading ?? backArrowButtton(),
            actions: actions ??
                [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/search');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20.0.sp,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("TAB");
                      Get.toNamed('/cart');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.grey,
                        size: 20.0.sp,
                      ),
                    ),
                  ),
                ],
          ),
        ),
      ),
    );

Widget backArrowButtton({
  double? size,
  void Function()? onPressed,
  Color? color: Colors.black,
}) {
  if (size == null) {
    size = 18.0.sp;
  }
  return GestureDetector(
    onTap: onPressed != null
        ? onPressed
        : () {
            Get.back();
          },
    child: Container(
      child: Icon(
        Icons.arrow_back_ios_sharp,
        color: color,
        size: size,
      ),
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
              height: 8.0.h,
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
                        padding: EdgeInsets.only(left: 3.0.w),
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

Widget MakeGap({double? height = 0.0}) => Column(
      children: [
        Divider(
          indent: 0.0,
          thickness: 1.0,
          height: height,
        ),
        SizedBox(
          height: 2.0.h,
        )
      ],
    );
Widget SliverIndicator() => SliverToBoxAdapter(
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
Widget removeTextFieldIcon(TextEditingController controller,
    {double? size, RxBool? hasText}) {
  size ??= 20.0.sp;
  return Visibility(
    visible: hasText?.value ?? true,
    child: GestureDetector(
      onTap: () {
        controller.clear();
        hasText?.value = false;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade600,
              border: Border.all(width: 0),
              borderRadius: BorderRadius.circular(12.0)),
          child: Icon(Icons.clear, size: size, color: Colors.white),
        ),
      ),
    ),
  );
}

Widget secureTextFieldIcon(Rx<bool?> isSecureObs, {double? size}) {
  size ??= 20.0.sp;
  return GestureDetector(
    onTap: () {
      isSecureObs.value = !isSecureObs.value!;
    },
    child: Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade600,
              border: Border.all(width: 0),
              borderRadius: BorderRadius.circular(12.0)),
          child: Icon(
            isSecureObs.value! ? Icons.lock_rounded : Icons.lock_open_rounded,
            size: size,
            color: Colors.white,
          ),
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
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
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

class DecoratedTabBar extends StatelessWidget implements PreferredSizeWidget {
  DecoratedTabBar({required this.tabBar, required this.decoration});

  final TabBar tabBar;
  final BoxDecoration decoration;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(decoration: decoration)),
        tabBar,
      ],
    );
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 1,
      );
}
