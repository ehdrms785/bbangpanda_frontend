import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/BreadSmallCategoryScreen/breadSmallCategoryController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadShareWidget.dart';

import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/showBreadsController.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final isInit = false;

class BreadSmallCategoryTab extends StatefulWidget {
  const BreadSmallCategoryTab(
      {Key? key, required this.isShowAppBar, required this.largeCategory})
      : super(key: key);
  final BreadLargeCategory largeCategory;
  final RxBool isShowAppBar;
  @override
  _BreadSmallCategoryTabState createState() => _BreadSmallCategoryTabState();
}

class _BreadSmallCategoryTabState extends State<BreadSmallCategoryTab>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  late final ShowBreadsController controller;
  @override
  void initState() {
    print("ShowBreads Init!");
    Get.create(() => ShowBreadsController(
          isShowAppBar: widget.isShowAppBar,
        ));
    // tag: 'showBreadTab');
    controller = Get.find(tag: 'showBreadTab');
    _scrollController = controller.scrollController;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("BreadSmallCateogryScreen 빌드!");
    return Scaffold(
      body: Obx(() => ModalProgressScreen(
            isAsyncCall: controller.isLoading.value,
            child: controller.firstInitLoading.value
                ? Center(child: CupertinoActivityIndicator())
                : CustomScrollView(
                    key: ValueKey(widget.largeCategory),
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                        parent: const AlwaysScrollableScrollPhysics()),
                    slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () => Future(() => null),
                        ),
                        // FilterBar(),
                        CategoryBar(),
                        BreadList(controller: controller),
                        // SliverGrid(
                        //   delegate:
                        //       SliverChildBuilderDelegate((context, index) {
                        //     return Column(
                        //       // mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         Container(
                        //           width: 45.0.w,
                        //           height: 25.0.h,
                        //           child: Image.asset(
                        //             'assets/breadImage.jpg',
                        //             fit: BoxFit.cover,
                        //           ),
                        //         ),
                        //         Text(controller.breadsResult[index]['price']),
                        //         Text(controller.breadsResult[index]['bakery']),
                        //         Text(controller.breadsResult[index]
                        //             ['description']),
                        //       ],
                        //     );
                        //   }, childCount: 5),
                        //   gridDelegate:
                        //       SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 2,
                        //     crossAxisSpacing: 4.0.w,
                        //     mainAxisExtent: 38.0.h,
                        //   ),
                        // ),
                      ]),
          )),
    );
  }
}
