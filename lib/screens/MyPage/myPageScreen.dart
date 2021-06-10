import 'package:bbangnarae_frontend/screens/MyPage/myPageController.dart';
import 'package:bbangnarae_frontend/screens/MyPage/settingScreen/settingScreen.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/sharedValues.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:bbangnarae_frontend/theme/buttonTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// late final QueryOptions options = QueryOptions(
//   document: gql(EditProfileMutation),
//   variables: {'username': '다로'},
//   fetchPolicy: FetchPolicy.cacheFirst,
//   cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,

//   // pollInterval: Duration(seconds: 5),
// );

class MyPageScreen extends StatelessWidget {
  late final MypageController myPageCtr = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MySliverAppBar(title: "마이페이지", isLeading: false),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
                child: Obx(() {
                  if (Get.find<AuthController>().isLoggedIn.value == false) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NotLoginedHeader(),
                        Divider(),
                        InformationSection(),
                      ],
                    );
                  } else {
                    return Obx(() {
                      if (myPageCtr.isLoading.value == true) {
                        return Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LoginHeader(),
                          InformationSection(),
                        ],
                      );
                    });
                  }
                }),
              ),
            ]),
          )
        ],
      ),
    );

    // },
  }

  Widget InformationSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 2.0.h),
          child: Text(
            "정보",
            style: TextStyle(
              fontSize: 15.0.sp,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.sticky_note_2_outlined),
          minLeadingWidth: double.minPositive,
          onTap: () {
            print("tab");
          },
          title: Text("공지사항"),
          contentPadding: EdgeInsets.zero,
        ),
        ListTile(
          leading: Icon(Icons.headset_mic_outlined),
          minLeadingWidth: double.minPositive,
          onTap: () {
            print("tab");
          },
          title: Text("고객센터"),
          contentPadding: EdgeInsets.zero,
        ),
        ListTile(
          leading: Icon(Icons.question_answer),
          minLeadingWidth: double.minPositive,
          onTap: () {
            print("tab");
          },
          title: Text("문의 · 건의하기"),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget NotLoginedHeader() {
    return Container(
      height: 10.0.h,
      child: Row(
        children: [
          Container(
            // color: Colors.blue.shade400,
            width: 47.0.w,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "빵판다 회원이 되시면",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12.5.sp,
                    ),
                  ),
                ),
                SizedBox(height: 1.0.h),
                Text(
                  "다양한 혜택이 기다려요!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0.sp,
                  ),
                )
              ],
            ),
          ),
          Container(
            // color: Colors.grey,
            width: 45.0.w,
            height: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Get.toNamed('/login');
                  },
                  child: Text("로그인"),
                  style: textButtonRoundedBorder,
                ),
                // SizedBox(width: 2.5.w),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/signUp');
                  },
                  child: Text("회원가입"),
                  style: textButtonRoundedBorder,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget LoginHeader() {
    return Container(
      height: 10.0.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            // color: Colors.blue.shade400,
            width: 60.0.w,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  myPageCtr.userResult['username'] ?? "빵판다인",
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.0.h),
                Text(
                  "등급 혜택보기 구현 예정",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0.sp,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 13.0.w,
                padding: EdgeInsets.all(2.0.w),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(25)),
                margin: EdgeInsets.only(right: 5.0.w),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Get.to(SettingScreen(),
                          transition: Transition.rightToLeft);
                    },
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.zero,
                    splashColor: Colors.blue.shade200,
                    splashRadius: 7.0.w,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ModalSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new FlatButton(
        onPressed: () => Navigator.of(context).pushNamed('/test'),
        child: const Text('test'),
      ),
    );
  }
}

class TestModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: const Text('modal routing test'),
      ),
    );
  }
}
