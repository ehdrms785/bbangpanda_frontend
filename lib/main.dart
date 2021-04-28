import 'package:bbangnarae_frontend/auth/localState.dart';
import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/model/filterListModel.dart';
import 'package:bbangnarae_frontend/screens/Cart/cartScreen.dart';
import 'package:bbangnarae_frontend/screens/FindBakery/findBakeryScreen.dart';
import 'package:bbangnarae_frontend/screens/FindBread/findBreadScreen.dart';
import 'package:bbangnarae_frontend/screens/Home/homeScreen.dart';
import 'package:bbangnarae_frontend/screens/Login/loginScreen.dart';
import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:bbangnarae_frontend/screens/NearBakery/nearBakeryScreen.dart';
import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:dotenv/dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // load();
  await Hive.initFlutter();
  await Hive.openBox('auth');

  // print("메인에서 테스트 ");
  // print(token);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // LocalStorage localStorage = new LocalStorage('newUser');
  // This widget is the root of your application.
  // final isLoggedin =
  final isLoggedin = loggedInCheck();

  @override
  Widget build(BuildContext context) {
    // print(token);
    print("현재 저장된 토큰 ${GraphQLConfiguration.httpLink.defaultHeaders}");

    // Hive Store에 토큰 확인
    // 있다면, 로그인한걸로
    // 로그아웃 할때 Hive Store에서 token 제거
    // 스테이터스바 색 조정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return GraphQLProvider(
      client: GraphQLConfiguration().getClient,
      child: ResponsiveSizer(builder: (context, orientation, screenType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<FilteredList>(
              create: (context) => FilteredList(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '빵나래 프로젝트',
            themeMode: ThemeMode.light, // Change it as you want
            theme: ThemeData(
                primaryColor: Colors.white,
                primaryColorBrightness: Brightness.light,
                brightness: Brightness.light,
                primaryColorDark: Colors.black,
                canvasColor: Colors.white,
                //     // next line is important!
                appBarTheme: AppBarTheme(brightness: Brightness.light)),
            darkTheme: ThemeData(
              primaryColor: Colors.black,
              primaryColorBrightness: Brightness.dark,
              primaryColorLight: Colors.black,
              brightness: Brightness.dark,
              primaryColorDark: Colors.black,
              indicatorColor: Colors.white,
              canvasColor: Colors.black,
              // next line is important!
              appBarTheme: AppBarTheme(brightness: Brightness.dark),
            ),
            home: isLoggedin ? MainPage() : LoginScreen(),
          ),
        );
      }),
    );
  }
}

// final appBarTitleValueNotifier = ValueNotifier<String>('빵나래 홈');

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
    Home(),
    FindBakery(),
    FindBread(),
    Cart(),
    NearBakery(),
  ];
  final List<String> _appBarNames = ["빵나래 홈", "빵집 찾기", "빵 비교", "장바구니", "내주변빵집"];
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
  }

  void onPageChanged(int index) {
    p_appBarTitleValueNotifier.value = _appBarNames[index];
    print("페이지 체인지");
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
          selectedFontSize: 14,
          unselectedFontSize: 12,
          // elevation: 2.0,
          onTap: _switchTap,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "빵나래",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront),
              label: "빵상점",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "주변빵집",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "찜빵",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_searching),
              label: "나의공간",
            ),
          ],
        ),
      ),
    );
  }
}
