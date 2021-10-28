import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerDetailScreen/DibsDrawerDetailController.dart';
import 'package:bbangnarae_frontend/shared/sharedValues.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DibsDrawerDetailScreen extends GetView<DibsDrawerDetailController> {
  const DibsDrawerDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Obx(
        () => ModalProgressScreen(
          isAsyncCall: controller.isLoading.value,
          child: CustomScrollView(
            key: ValueKey("DibsDrawerDetailScroll"),
            controller: controller.scrollController,
            physics: CupertinoScrollPhysics,
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () => Future(() => null),
              ),
              MySliverAppBar(title: '서랍'),
              Obx(() {
                if (controller.dibsDrawerItemList?.first == null) {
                  if (controller.hasMore.value == false) {
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 50.0.h,
                        child: Center(
                            child: Text("해당 조건의 빵이 없어요.",
                                style: TextStyle(fontSize: 20.0.sp))),
                      ),
                    );
                  }
                  return SliverToBoxAdapter(child: SizedBox.shrink());
                }

                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                  sliver: SliverFillRemaining(
                      child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 30.0.h,
                      crossAxisSpacing: 2.0.w,
                    ),
                    itemBuilder: (context, index) {
                      final itemData = controller.dibsDrawerItemList![index];
                      itemData!;
                      return GestureDetector(
                          onTap: () {},
                          child: Container(
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  Container(
                                    width: 32.0.w,
                                    height: 25.0.h,
                                    child: Image.asset(itemData.thumbnail,
                                        fit: BoxFit.cover),
                                  )
                                ],
                              )));
                    },
                    itemCount: controller.dibsDrawerItemList!.length,
                  )),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
