import 'package:bbangnarae_frontend/model/filterListModel.dart';
import 'package:bbangnarae_frontend/shared/sharedValues.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  FilterPage({Key? key}) : super(key: key);
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late ScrollController controller;

  late ValueNotifier<List<CustomChip>> _filterListValueNoti;
  late ValueNotifier<List<CustomChip>> _dynamicListValueNoti;
  late bool somethingChanged;
  late List<bool> listChanged;

  @override
  void initState() {
    _filterListValueNoti =
        ValueNotifier(context.read<FilteredList>().getFilterList);
    _dynamicListValueNoti =
        ValueNotifier(context.read<FilteredList>().dynamicFilterList);
    listChanged = [
      ..._filterListValueNoti.value.map((e) => e.value),
      ..._dynamicListValueNoti.value.map((e) => e.value)
    ];
    print("리스트 체인지드!");
    print(listChanged);
    somethingChanged = false;
    controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void somethingchangeCheck() {
    if (!somethingChanged) somethingChanged = true;
  }

  @override
  Widget build(BuildContext context) {
    print(context.read<FilteredList>().getFilterList);
    return ResponsiveSizer(
      builder: (context, orientation, screentype) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                var isSameBefore = listEq(listChanged, [
                  ..._filterListValueNoti.value.map((e) => e.value),
                  ..._dynamicListValueNoti.value.map((e) => e.value)
                ]);
                if (!isSameBefore)
                  context.read<FilteredList>()
                    ..setFilterList(_filterListValueNoti.value)
                    ..setDynamicFilter(_dynamicListValueNoti.value)
                    ..notify();
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            shadowColor: Colors.transparent,
            title: Text("정렬 설정"),
          ),
          body: CustomScrollView(controller: controller, slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue.shade300),
                      ),
                      child: Text(
                        "초기화",
                        style: TextStyle(letterSpacing: 0.5.sp),
                      ),
                      onPressed: () {
                        _filterListValueNoti.value
                            .asMap()
                            .forEach((index, element) {
                          if (index == 0) {
                            _filterListValueNoti.value[index].value = true;
                          } else {
                            _filterListValueNoti.value[index].value = false;
                          }
                        });
                        _dynamicListValueNoti.value
                            .asMap()
                            .forEach((index, element) {
                          _dynamicListValueNoti.value[index].value = false;
                        });
                        somethingchangeCheck();
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    color: Colors.blue[200],
                    child: Center(
                      child: Text("매장 기본 옵션",
                          style: TextStyle(
                              fontSize: 20.0.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  ValueListenableBuilder<List<CustomChip>>(
                    valueListenable: _filterListValueNoti,
                    builder: (context, _filterList, _) {
                      print("하이2");
                      List<Widget> chips = [];
                      for (int i = 0; i < _filterList.length; i++) {
                        var chip;
                        chip = GestureDetector(
                          onTap: () {
                            int _count = 0;
                            for (var item in _filterList) {
                              if (item.value == true) _count++;
                            }

                            if (_filterList[i].value && _count < 2) {
                              Flushbar(
                                flushbarPosition: FlushbarPosition.TOP,
                                message: "최소 1개 이상은 선택 해 주세요",
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.blue.shade700,
                                onTap: (bar) {
                                  bar.dismiss();
                                },
                              ).show(context);
                              return;
                            }
                            somethingchangeCheck();
                            _filterList[i].value = !_filterList[i].value;
                            _filterListValueNoti.notifyListeners();
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                    value: _filterList[i].value,
                                    fillColor: MaterialStateProperty.all<Color>(
                                        Colors.blue.shade200),
                                    onChanged: (bool? value) {},
                                    // 일부로 onChnage는 생략
                                  ),
                                  Text(_filterList[i].name),
                                ],
                              ),
                            ),
                          ),
                        );
                        chips.add(chip);
                      }

                      return Column(children: [
                        GridView.count(
                          padding: EdgeInsets.only(left: 10.0.w),
                          physics: NeverScrollableScrollPhysics(), // 이것두
                          shrinkWrap: true, // 이거 해야 ScrollView랑 공존가능
                          childAspectRatio: 4 / 1, // 가로 : 세로
                          crossAxisCount: 2, // 한 줄에 2개
                          children: [
                            ...chips,
                          ],
                        ),
                      ]);
                    },
                  ),
                  // 여기는 이제 빵 옵션
                  Container(
                    // margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    color: Colors.blue[200],
                    child: Center(
                      child: Text("빵 옵션",
                          style: TextStyle(
                              fontSize: 20.0.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  ValueListenableBuilder<List<CustomChip>>(
                    valueListenable: _dynamicListValueNoti,
                    builder: (context, _dynamicList, _) {
                      print("하이3");
                      List<Widget> chips = [];
                      for (int i = 0; i < _dynamicList.length; i++) {
                        var chip;
                        chip = GestureDetector(
                          onTap: () {
                            somethingchangeCheck();
                            _dynamicList[i].value = !_dynamicList[i].value;
                            _dynamicListValueNoti.notifyListeners();
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                    value: _dynamicListValueNoti.value[i].value,
                                    fillColor: MaterialStateProperty.all<Color>(
                                        Colors.blue.shade200),
                                    onChanged: (bool? value) {},
                                    // 일부로 onChnage는 생략
                                  ),
                                  Text(_dynamicList[i].name),
                                ],
                              ),
                            ),
                          ),
                        );
                        chips.add(chip);
                      }

                      return Column(children: [
                        GridView.count(
                          padding: EdgeInsets.only(left: 10.0.w),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          childAspectRatio: 4 / 1,
                          crossAxisCount: 2,
                          children: [
                            ...chips,
                          ],
                        ),
                      ]);
                    },
                  )
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}
