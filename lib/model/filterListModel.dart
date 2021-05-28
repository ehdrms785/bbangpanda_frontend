import 'package:bbangnarae_frontend/screens/FindBakery/findBakeryScreen.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/sharedValues.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// IsOptionIntersection이 필요 없을 것 같아져서 교체
// 합집합으로 해 버리면 글루텐프리와 같은 옵션을 추가하는 의미가 없어진다;;

class CustomChip {
  CustomChip(
      {required this.keyword,
      required this.name,
      required this.value,
      this.isInputChip = false});
  final String keyword;
  final String name;
  bool value;
  final isInputChip;
}

class BakeryData {
  BakeryData({required this.name, required this.features});
  final String name;
  final List<Map<String, bool>> features;
}

List<BakeryData> backendData = [
  new BakeryData(name: "1번 빵집", features: [
    {'delivery': true},
    {'inStore': true},
    {'koreaMeal': true},
    {'whole': false},
    {'organic': true},
    {'gf': true},
    {'sf': true},
  ]),
  new BakeryData(name: "2번 빵집", features: [
    {'delivery': true},
    {'inStore': true},
    {'koreaMeal': true},
    {'whole': false},
    {'organic': false},
    {'gf': true},
    {'sf': false},
  ]),
  new BakeryData(name: "3번 빵집", features: [
    {'delivery': false},
    {'inStore': true},
    {'koreaMeal': false},
    {'whole': true},
    {'organic': false},
    {'gf': true},
    {'sf': false},
  ]),
  new BakeryData(name: "4번 빵집", features: [
    {'delivery': true},
    {'inStore': false},
    {'koreaMeal': true},
    {'whole': true},
    {'organic': false},
    {'gf': true},
    {'sf': false},
  ]),
  new BakeryData(name: "5번 빵집", features: [
    {'delivery': true},
    {'inStore': true},
    {'koreaMeal': true},
    {'whole': false},
    {'organic': false},
    {'gf': true},
    {'sf': true},
  ]),
  new BakeryData(name: "6번 빵집", features: [
    {'delivery': true},
    {'inStore': true},
    {'koreaMeal': false},
    {'whole': false},
    {'organic': false},
    {'gf': false},
    {'sf': false},
  ]),
  new BakeryData(name: "7번 빵집", features: [
    {'delivery': true},
    {'inStore': true},
    {'koreaMeal': false},
    {'whole': false},
    {'organic': false},
    {'gf': true},
    {'sf': false},
  ]),
  new BakeryData(name: "8번 빵집", features: [
    {'delivery': false},
    {'inStore': true},
    {'koreaMeal': true},
    {'whole': true},
    {'organic': true},
    {'gf': false},
    {'sf': false},
  ]),
  new BakeryData(name: "9번 빵집", features: [
    {'delivery': true},
    {'inStore': false},
    {'koreaMeal': false},
    {'whole': true},
    {'organic': false},
    {'gf': false},
    {'sf': false},
  ]),
  new BakeryData(name: "10번 빵집", features: [
    {'delivery': true},
    {'inStore': false},
    {'koreaMeal': false},
    {'whole': true},
    {'organic': false},
    {'gf': true},
    {'sf': false},
  ]),
  new BakeryData(name: "11번 빵집", features: [
    {'delivery': true},
    {'inStore': true},
    {'koreaMeal': false},
    {'whole': false},
    {'organic': false},
    {'gf': true},
    {'sf': false},
  ]),
  new BakeryData(name: "12번 빵집", features: [
    {'delivery': true},
    {'inStore': true},
    {'koreaMeal': false},
    {'whole': true},
    {'organic': true},
    {'gf': false},
    {'sf': true},
  ]),
  new BakeryData(name: "13번 빵집", features: [
    {'delivery': false},
    {'inStore': true},
    {'koreaMeal': true},
    {'whole': true},
    {'organic': true},
    {'gf': true},
    {'sf': true},
  ]),
  new BakeryData(name: "14번 빵집", features: [
    {'delivery': true},
    {'inStore': false},
    {'koreaMeal': false},
    {'whole': true},
    {'organic': false},
    {'gf': false},
    {'sf': true},
  ]),
  new BakeryData(name: "15번 빵집", features: [
    {'delivery': true},
    {'inStore': false},
    {'koreaMeal': true},
    {'whole': true},
    {'organic': true},
    {'gf': false},
    {'sf': false},
  ]),
  new BakeryData(name: "16번 빵집", features: [
    {'delivery': true},
    {'inStore': true},
    {'koreaMeal': true},
    {'whole': true},
    {'organic': false},
    {'gf': true},
    {'sf': false},
  ]),
  new BakeryData(name: "17번 빵집", features: [
    {'delivery': true},
    {'inStore': false},
    {'koreaMeal': false},
    {'whole': true},
    {'organic': false},
    {'gf': false},
    {'sf': true},
  ]),
];

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print("로딩 스크린 떴습니다");
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.0),
      body: Center(
          child: CupertinoActivityIndicator(
        radius: MediaQuery.of(context).size.height * 0.01 * 5,
      )),
    );
  }
}

const int GET_COUNTS = 8;

class FilteredList extends ChangeNotifier {
  Set<dynamic> _filteredList = new Set();
  late List<CustomChip> _filterList;
  late List<CustomChip> _dynamicFilterList;
  late Set<String> _beforeSelectedFilter;
  late Set<String> _nowSelectedFilter;
  bool hasMore = true;
  late int _current;
  late bool _breadOptionSelected;
  late bool _isOptionIntersection;

  initChips() async {
    return await Future(() {
      _filterList = [
        new CustomChip(keyword: 'delivery', name: '택배가능', value: true),
        new CustomChip(keyword: 'onStore', name: '매장취식', value: false),
      ];
      _dynamicFilterList = [
        new CustomChip(keyword: 'koreaMeal', name: '우리밀', value: false),
        new CustomChip(keyword: 'whole', name: '통밀가루', value: false),
        new CustomChip(keyword: 'organic', name: '유기농밀가루', value: false),
        new CustomChip(keyword: 'gf', name: '글루텐프리', value: false),
        new CustomChip(keyword: 'sf', name: '무가당', value: false),
      ];
      _filteredList = new Set();
      _beforeSelectedFilter = new Set();
      _nowSelectedFilter = new Set();
      hasMore = true;
      _current = 0;
      _breadOptionSelected = false;
      _isOptionIntersection = false;
      return;
    });
    // if (context != null) setFilterList(context, _filterList);
  }

  void notify() async {
    print("알리자~");
    await makeListInit(anotherFilter: _dynamicFilterList);
    notifyListeners();
  }

  bool getIsOptionSameBefore() {
    return setEq(_beforeSelectedFilter, _nowSelectedFilter);
  }

  bool getIsIntersection() => _isOptionIntersection;
  // set isIntersection(bool value) => _isOptionIntersection = value;

  void setIsItersection(bool value) {
    _isOptionIntersection = value;
    notifyListeners();
  }

  List<CustomChip> get dynamicFilterList => _dynamicFilterList;

  void setDynamicFilter(List<CustomChip> newFilter) {
    _dynamicFilterList = [...newFilter];
    // notifyListeners();
  }

  void showLoadingPage(
      {required BuildContext context, required Function function}) async {
    Navigator.of(context).push(
      PageRouteBuilder(
        // 뒤에 가릴건지 여부
        opaque: false,

        pageBuilder: (BuildContext context, _, __) => LoadingScreen(),
      ),
    );
    await function();
    Navigator.of(context).pop();
    return;
  }

  void setFilterList(List<CustomChip> newFilter) async {
    // _breadOptionSelected = false;
    _filterList = [...newFilter];
    // notifyListeners();
    // showLoadingPage(
    //     context: context,
    //     function: () async {
    //       _filterList = [...newFilter];
    //       await makeListInit();
    //       notifyListeners();
    //     });
  }

  void notifyDynamicChanged({required BuildContext context}) async {
    _beforeSelectedFilter = new Set();
    _beforeSelectedFilter.addAll(_nowSelectedFilter);
    // DynamicFilter 중에 적용 된 값이 있다면 교집합 없다면 합집합
    if (_nowSelectedFilter.isEmpty)
      _isOptionIntersection = false;
    else
      _isOptionIntersection = true;

    _breadOptionSelected = false;

    showLoadingPage(
        context: context,
        function: () async {
          await makeListInit(anotherFilter: _dynamicFilterList);
          notifyListeners();
        });
  }

  void switchBreadOptionSelected() {
    _breadOptionSelected = _breadOptionSelected;
    notifyListeners();
  }

  bool get getBreadOptionSelected => _breadOptionSelected;

  List<CustomChip> get getFilterList => _filterList;
  Set<dynamic> get getFilteredList => _filteredList;

  // firstInit() async {
  //   print("Chips !!");
  //   await initChips();
  //   print("Chips22 !!");
  //   await makeListInit();
  //   print("Chips33 !!");
  //   notifyListeners();
  // }

  Future firstInit() {
    return Future(() async {
      print("Chips !!");
      await initChips();
      print("Chips22 !!");
      await makeListInit();
      print("Chips33 !!");
      notifyListeners();
    });
  }

  Future makeListInit({List<CustomChip>? anotherFilter}) async {
    if (anotherFilter == null) {
      anotherFilter = [];
    }
    return Future(() async {
      print("MakeListInit");
      // 완전 필터링 된 값을 넣을 곳 (중복 값 방지 위해 Set)
      Set<dynamic> filteredBackend = new Set();
      // 이전 필터에서 끝 값을 봤다면 hasMore = false 일 것임
      // 다시 초기화 시켜주기
      hasMore = true;
      // _current도 다시 Initialize !
      _current = 0;
      // Backend Data에서 특정 범위 만큼 값을 담을 곳
      // getData는 Backend에서 가져오는 로직이라고 가정
      do {
        var takeSomeDataFromBackend = await getData();
        // print('getData 바깥!');
        // 이전 필터에서 최종 값까지 갔다면 hasMore는 false일 것임
        // 새롭게 필터를 조정하면 hasMore값도 다시 true가 되어야 함

        filteredBackend.addAll(await filteringAndReturn(
          filterList: [
            ..._filterList,
            if (_dynamicFilterList.isNotEmpty) ..._dynamicFilterList
          ],
          willFilteredList: takeSomeDataFromBackend,
        ));
      } while (filteredBackend.length < 5 && hasMore);
      print("Hasmore $hasMore");
      _filteredList = new Set();
      for (int i = 0; i < filteredBackend.length; i++) {
        _filteredList.add(
          BuildBakeryItem(
            name: filteredBackend.elementAt(i).name,
            index: i,
          ),
        );
      }
      return;
    });
  }

  Future<Set<dynamic>> getData({int howmanyCount = GET_COUNTS}) async {
    // print('getData 실행!');
    Set<BakeryData> _takeSomeDataFromBackend = new Set();

    return await Future(() {
      int _nextGetCounts = _current + GET_COUNTS;
      print(
          "current : $_current :: backend길이 :${backendData.length} :: 어디까지:$_nextGetCounts");
      //백엔드 가져오는 로직
      if (backendData.length < _nextGetCounts) {
        _takeSomeDataFromBackend
            .addAll(backendData.getRange(_current, backendData.length));
        _current += backendData.length;
        hasMore = false;
      } else {
        _takeSomeDataFromBackend
            .addAll(backendData.getRange(_current, _nextGetCounts));
        _current += GET_COUNTS;
      }
      return _takeSomeDataFromBackend;
    });
  }

  Future<Set<dynamic>> filteringAndReturn({
    required List<dynamic> filterList,
    required Set<dynamic> willFilteredList,
  }) async {
    Set<dynamic> filteredBackend = new Set();
    // 교집합일때
    print("필터링 ${filterList.length}");

    return Future(() {
      try {
        filteredBackend.addAll(((willFilteredList.where((element) {
          for (int i = 0; i < filterList.length; i++) {
            if (filterList[i].value == true) {
              if (element.features[i].values.first == false) {
                return false;
              }
            }
          }
          //해당 필터값이 True 인데 False 값인게 하나라도 있으면 false를
          // 모두 True로 통과했다면 true를 반환 해서 filterdBackend에 들어가게
          return true;
        }).toList())));
      } on NoSuchMethodError {
        // value를 가지고 있지 않는 필터 값일경우 오류를 내지 않기 위한 처리
        print(
            "filteringndReturn Method: filterList가 value 값을 가지고 있지 않은 _filterList 입니다");
        return new Set();
      }

      return filteredBackend;
    });
  }

  Future getMoreData() async {
    print("Get More 데이터");
    return await Future(() async {
      if (hasMore == false) return;
      try {
        Set<dynamic> filteredBackend = new Set();
        var takeSomeDataFromBackend = await getData();

        filteredBackend = await filteringAndReturn(
            filterList: [..._filterList, ..._dynamicFilterList],
            willFilteredList: takeSomeDataFromBackend);

        _filteredList = new Set.from(_filteredList);
        for (int i = 0; i < filteredBackend.length; i++) {
          _filteredList.add(
            BuildBakeryItem(
              name: filteredBackend.elementAt(i).name,
              index: i,
            ),
          );
        }

        notifyListeners();
      } catch (err) {
        print(err);
      } finally {}
    });
  }
}
