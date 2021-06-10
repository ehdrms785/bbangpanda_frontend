import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 2.0.h),
        child: CustomScrollView(
          slivers: [
            MySliverAppBar(
              title: "설정",
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Column(
                children: [
                  ListTile(
                    leading: null,
                    onTap: () {
                      Get.toNamed('/editProfile');
                    },
                    title: Text("회원 정보 수정"),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: null,
                    onTap: logout,
                    title: Text("로그아웃"),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ])),
          ],
        ),
      ),
    );
  }
}
