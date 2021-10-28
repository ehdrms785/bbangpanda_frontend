// ignore_for_file: non_constant_identifier_names

import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/Cart/cartScreen.dart';
import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerMainScreen/DibsDrawerMainScreen.dart';
import 'package:bbangnarae_frontend/screens/FindPage/BreadLargeCategoryScreen/breadLargeCategoryController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/BreadLargeCategoryScreen/breadLargeCategoryScreen.dart';
import 'package:bbangnarae_frontend/screens/FindPage/findPageScreen.dart';
import 'package:bbangnarae_frontend/screens/Home/homeScreen.dart';
import 'package:bbangnarae_frontend/screens/MyPage/Login/loginController.dart';
import 'package:bbangnarae_frontend/screens/MyPage/Login/loginScreen.dart';
import 'package:bbangnarae_frontend/screens/MyPage/SignUp/signUpController.dart';
import 'package:bbangnarae_frontend/screens/MyPage/SignUp/signUpScreen.dart';
import 'package:bbangnarae_frontend/screens/MyPage/editProfileScreen/editProfileController.dart';
import 'package:bbangnarae_frontend/screens/MyPage/editProfileScreen/editProfileScreen.dart';
import 'package:bbangnarae_frontend/screens/MyPage/myPageScreen.dart';
import 'package:bbangnarae_frontend/screens/MyPage/smsAuthScreen/smsAuthController.dart';
import 'package:bbangnarae_frontend/screens/MyPage/smsAuthScreen/smsAuthScreen.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchDetailScreen/searchDetailScreen.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchScreen.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchScreenController.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedValues.dart';
import 'package:bbangnarae_frontend/theme/mainTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  await Firebase.initializeApp();
  await Hive.openBox('auth');
  await Hive.openBox('graphqlCache');
  Hive.box('graphqlCache').clear();
  await Hive.openBox('cache');
  //천지인에서 .. 한글 인식 못 한다는 얘기가 있어서 넣어봄
  FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|가-힣|ㆍ|ᆢ]'));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("현재 저장된 토큰 ${GraphQLConfiguration.token}");
    // 화면방향 세로 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // 스테이터스바 색 조정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));

    return GraphQLProvider(
      client: GraphQLConfiguration.graphqlInit(),
      child: ResponsiveSizer(builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: '빵나래 프로젝트',
          themeMode: ThemeMode.light, // Change it as you want
          theme: getMainTheme(),
          darkTheme: getMainDarkTheme(),
          initialRoute: '/init',
          initialBinding: BindingsBuilder(() async {
            initBinding();
          }),

          getPages: [
            GetPage(
              name: '/init',
              page: () {
                // return App();
                return AnimatedSplashScreen(
                  animationDuration: Duration(milliseconds: 1000),
                  splash: 'lib/images/splash.png',
                  splashIconSize: 30.0.h,
                  centered: true,
                  backgroundColor: SharedValues.mainColor,
                  nextScreen: App(),
                  splashTransition: SplashTransition.fadeTransition,
                  pageTransitionType: PageTransitionType.scale,
                );
              },
            ),
            GetPage(
              name: '/',
              page: () {
                return App();
              },
            ),
            GetPage(
              name: '/myPage',
              page: () => MyPageScreen(),
            ),
            GetPage(
              name: '/editProfile',
              page: () => EditProfileScreen(),
              binding: BindingsBuilder(() {
                Get.lazyPut(() => EditProfileController());
              }),
            ),
            GetPage(
              name: '/login',
              page: () => LoginScreen(),
              transition: Transition.downToUp,
              binding: BindingsBuilder(() {
                Get.put(LoginController());
                Get.lazyPut(() => SignUpController());
              }),
            ),
            GetPage(
              name: '/signUp',
              page: () => SignUpScreen(),
              transition: Transition.downToUp,
              binding: BindingsBuilder(() {
                Get.lazyPut(() => SignUpController());
              }),
            ),
            GetPage(
              name: '/smsAuth',
              page: () => SmsAuthScreen(),
              binding: BindingsBuilder(() {
                Get.lazyPut(() => SmsAuthController());
              }),
            ),
            GetPage(
              name: '/filteredContent',
              page: () => FindPageScreen(),
            ),
            GetPage(
              name: '/breadLargeCategory',
              page: () => BreadLargeCategoryScreen(),
              binding: BindingsBuilder(() {
                Get.lazyPut(() => BreadLargeCategoryController());
              }),
            ),
            GetPage(
              name: '/search',
              page: () => SearchPage(),
              binding: BindingsBuilder(() {
                Get.lazyPut(
                  () => SearchScreenController(),
                );
              }),
            ),
            GetPage(
              name: '/searchDetail',
              page: () => SearchDetailScreen(),
            ),
            GetPage(
              name: '/cart',
              page: () {
                return CartScreen();
              },
            ),
          ],
        );
      }),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainPage();
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
    Home(),
    DibsDrawerMainScreen(),
    FindPageScreen(),
    CartScreen(),
    MyPageScreen(),
  ];
  final List<String> _pageNames = ["홈", "찜", "빵쇼핑", "장바구니", "마이페이지"];

  int _selectedIndex = 0;
  late PageController _mainPageController;
  @override
  void initState() {
    super.initState();
    _mainPageController = AuthController.to.mainPageController;
  }

  @override
  void dispose() {
    _mainPageController.dispose();
    super.dispose();
  }

  _switchTap(int index) {
    // case of Cart Screen,
    if (index == 3) {
      Get.toNamed("/cart");
      return;
    }
    _mainPageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    SharedValues.p_appBarTitleValueNotifier.value = _pageNames[index];
    if (_selectedIndex != index)
      setState(() {
        _selectedIndex = index;
      });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _mainPageController,
          children: _pages,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: colorScheme.surface,
          selectedItemColor: colorScheme.onSurface,
          unselectedItemColor: colorScheme.onSurface.withOpacity(0.60),
          selectedFontSize: 12.0.sp,
          unselectedFontSize: 11.0.sp,
          onTap: _switchTap,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: _pageNames[0],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_sharp),
              activeIcon: Icon(Icons.favorite),
              label: _pageNames[1],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.breakfast_dining),
              label: _pageNames[2],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: _pageNames[3],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: _pageNames[4],
            ),
          ],
        ),
      ),
    );
  }
}
