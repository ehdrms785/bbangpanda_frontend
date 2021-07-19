import 'dart:ui';

import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// title은 Get 에서 args 로 넘기는 베이커리이름을 받자
class BakeryDetailMainScreen extends StatelessWidget {
  const BakeryDetailMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(4.0.h),
          child: AppBar(
            title: Text("헬로"),
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            // toolbarHeight: 4.0.h,
            // backgroundColor: Colors.transparent,
          ),
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: const AlwaysScrollableScrollPhysics()),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () => Future(() => null),
            ),

            // 베이커리 메인 프로필
            SliverToBoxAdapter(
              child: Container(
                color: Colors.grey,
                width: double.infinity,
                height: 30.0.h,
                child: Stack(
                  children: [
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.5),
                      child: Container(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/bakeryImage.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    Positioned.fill(
                      child: Text("베이커리 아이디: ${Get.arguments['bakeryId']}",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: Text("하이헬로")),
            SliverToBoxAdapter(child: Text("하이헬로")),
            SliverToBoxAdapter(child: Text("하이헬로")),
            SliverToBoxAdapter(child: Text("하이헬로")),
            SliverToBoxAdapter(child: Text("하이헬로")),
            SliverToBoxAdapter(child: Text("하이헬로")),
            // 라지 카테고리 && 세부카테고리(접이식)
            // 필터 & 세부옵션
            // 상품목록
          ],
        ),
      ),
    );
  }
}
