import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/Cart/cartScreen.dart';
import 'package:bbangnarae_frontend/screens/Error/errorScreen.dart';
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
import 'package:bbangnarae_frontend/screens/MyPage/myPageController.dart';
import 'package:bbangnarae_frontend/screens/MyPage/myPageScreen.dart';
import 'package:bbangnarae_frontend/screens/MyPage/smsAuthScreen/smsAuthController.dart';
import 'package:bbangnarae_frontend/screens/MyPage/smsAuthScreen/smsAuthScreen.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/loader.dart';
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

  await Hive.openBox('auth');
  await Hive.openBox('graphqlCache');
  Hive.box('graphqlCache').clear();
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
            // AuthBinding();
            Get.put(AuthController(), permanent: true);
            Get.lazyPut(() => MypageController());
            // Get.lazyPut(() => ShowBakeriesController());
            // Get.lazyPut(() => ShowBreadsController());
          }),

          getPages: [
            GetPage(
              name: '/init',
              page: () => AnimatedSplashScreen(
                animationDuration: Duration(milliseconds: 1000),
                splash: 'lib/images/splash.png',
                splashIconSize: 30.0.h,
                centered: true,
                backgroundColor: SharedValues.mainColor,
                nextScreen: App(),
                splashTransition: SplashTransition.fadeTransition,
                pageTransitionType: PageTransitionType.scale,
              ),
            ),
            GetPage(
              name: '/',
              page: () => App(),
              binding: BindingsBuilder(() {
                // Get.put(MypageController());
              }),
            ),
            GetPage(
              name: '/myPage',
              page: () => MyPageScreen(),
              binding: BindingsBuilder(() {
                // Get.put(MypageController());
                // Get.lazyPut(() => MypageController());
              }),
            ),
            GetPage(
              name: '/editProfile',
              page: () => EditProfileScreen(),
              binding: BindingsBuilder(() {
                Get.lazyPut(() => EditProfileController());
                // Get.put(MypageController());
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
              binding: BindingsBuilder(() {
                // Get.lazyPut(() => ShowBreadsController());
              }),
            ),
            GetPage(
              name: '/breadLargeCategory',
              page: () => BreadLargeCategoryScreen(),
              binding: BindingsBuilder(() {
                // Get.create(() => BreadLargeCategoryController());
                Get.lazyPut(() => BreadLargeCategoryController());
              }),
            )
          ],
        );
      }),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return ErrorScreen();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MainPage();
        }
        return Loader();
      },
    );
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
    Home(),
    FindPageScreen(),
    Cart(),
    MyPageScreen(),
  ];
  final List<String> _pageNames = ["빵나래 홈", "빵집 찾기", "빵 비교", "장바구니", "마이페이지"];

  late PageController pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  _switchTap(int index) {
    // onPageChange와 _switchTap 중에 _switchTap이 먼저 실행 된다
    // 그래서 onPageChange에서 setState를 한 번만 실행한다.
    // if (_selectedIndex != index)
    //   setState(() {
    //     _selectedIndex = index;
    //   });
    pageController.jumpToPage(index);
    // Get.toNamed(_pageRoutes[index]);
  }

  void onPageChanged(int index) {
    SharedValues.p_appBarTitleValueNotifier.value = _pageNames[index];
    print("페이지 체인지");
    if (_selectedIndex != index)
      setState(() {
        _selectedIndex = index;
      });
  }

  @override
  Widget build(BuildContext context) {
    print("실행완료!");
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        body: PageView(
          //슬라이드 금지
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
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
          // elevation: 2.0,
          onTap: _switchTap,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: _pageNames[0],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront),
              label: _pageNames[1],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: _pageNames[2],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: _pageNames[3],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_searching),
              label: _pageNames[4],
            ),
          ],
        ),
      ),
    );
  }
}
