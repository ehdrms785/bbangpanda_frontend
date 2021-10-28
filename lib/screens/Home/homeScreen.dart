import 'package:bbangnarae_frontend/main.dart';
import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerMainScreen/DibsDrawerMainController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/showBakeriesTab.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/showBreadsTab.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final String login = """
  mutation login(\$email: String, \$phonenumber: String, \$password: String!) {
    login(email: \$email, phonenumber: \$phonenumber, password: \$password) {
      ok
      error
      customToken
      customTokenExpired
      refreshToken
      refreshTokenExpired
     }
  }
""";

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    print("빌드 리빌드 테스트");
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: PrefferedAppBar(title: "홈"),
      body: Container(
          width: 100.0.w,
          height: 100.0.h,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // CarouselSlider(
              //   items: [1, 2, 3, 4, 5].map((i) {
              //     return Builder(
              //       builder: (BuildContext context) {
              //         return Container(
              //             width: double.infinity,
              //             decoration: BoxDecoration(
              //               color: Colors.green.shade300,
              //             ),
              //             child: Center(
              //               child: Text(
              //                 '$i번 이벤트 배너',
              //                 style: TextStyle(fontSize: 16.0),
              //               ),
              //             ));
              //       },
              //     );
              //   }).toList(),
              //   options: CarouselOptions(
              //     autoPlay: true,
              //     autoPlayInterval: Duration(seconds: 4),
              //     enlargeCenterPage: true,
              //     viewportFraction: 1.0,
              //     aspectRatio: 2.0,
              //     initialPage: 0,
              //   ),
              // ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.green.shade900.withOpacity(0.5),
                  child: Center(
                    child:
                        Image.asset('assets/splash1000.png', fit: BoxFit.cover),
                  ),
                ),
              ),

              TextButton(
                  onPressed: () {
                    // Get.reload(tag: 'showBakeryTab', force: true);
                    DibsDrawerMainController.to.someDibsDrawerChanged = true;
                  },
                  child: Text("버튼을 눌러봅시다"))
            ],
          )),
    );
  }
}
