import 'package:bbangnarae_frontend/model/filterListModel.dart';
import 'package:bbangnarae_frontend/screens/FindBakery/filterScreen.dart';
import 'package:bbangnarae_frontend/screens/FindBakery/searchScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FindBakery extends StatefulWidget {
  @override
  _FindBakeryState createState() => _FindBakeryState();
}

class _FindBakeryState extends State<FindBakery>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _controller;
  late bool _loading;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    _loading = false;
    _controller = ScrollController();
    _controller.addListener(() async {
      try {
        print(
            'maxExtent ${_controller.position.maxScrollExtent} :: ${_controller.position.pixels}');

        if (_controller.position.pixels + 50 >=
                _controller.position.maxScrollExtent &&
            !_loading) {
          // 잠시 딜레이를 주어야
          // _loading = true로 바뀐거 인식하고
          // 중복 로딩이 되지 않는다.
          Future.delayed(
            Duration(milliseconds: 500),
            () async {
              if (_loading) {
                print("로딩이랑게");
                return;
              }
              _loading = true;
              await context.read<FilteredList>().getMoreData();
            },
          );
        }
      } catch (e) {
        print(e);
      } finally {
        Future.delayed(Duration(milliseconds: 200), () {
          _loading = false;
        });
      }
    });
    context.read<FilteredList>().firstInit().then((result) {
      print("hello");
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: CustomScrollView(
        key: UniqueKey(),
        controller: _controller,
        slivers: <Widget>[
          SliverAppBar(
            toolbarHeight: 5.0.h,
            pinned: false,
            floating: true,
            snap: true,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Container(
              child: Text("빵집 찾기"),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  goAnotherPage(context, SearchPage());
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.search, size: 20.0.sp),
                ),
              ),
              GestureDetector(
                onTap: () {
                  goAnotherPage(context, FilterPage());
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(Icons.filter_list, size: 20.0.sp),
                ),
              ),
            ],
          ),
          Consumer<FilteredList>(
            builder: (context, filteredList, chid) {
              print("Consumer FilteredList Run");
              if (filteredList.getFilteredList.isEmpty) {
                if (filteredList.hasMore == false) {
                  return SliverToBoxAdapter(
                    child: Container(
                      alignment: Alignment.center,
                      height: 80.0.h,
                      child: Center(
                        child: Text("해당 하는 빵집이\n    빵개에요..😭",
                            style: TextStyle(
                              fontSize: 30.0.sp,
                              height: 1.3,
                            )),
                      ),
                    ),
                  );
                }
                return SliverToBoxAdapter(
                    child: Container(
                        height: 80.0.h,
                        child: Center(child: CupertinoActivityIndicator())));
              }
              return SliverList(
                key: ObjectKey(filteredList.getFilteredList.first),
                delegate: SliverChildListDelegate([
                  ...filteredList.getFilteredList,
                  Visibility(
                      visible: filteredList.hasMore,
                      child: CupertinoActivityIndicator())
                ]),
              );
            },
          ),
        ],
      ),
    );
  }

  void goAnotherPage(BuildContext context, Widget page) {
    const _changeDuration = 300;

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: _changeDuration),
        reverseTransitionDuration:
            const Duration(milliseconds: _changeDuration),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, _, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;

          return SlideTransition(
            position: Tween(begin: begin, end: end).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInCubic)),
            child: child,
          );
        },
      ),
    );
  }
}

class BuildBakeryItem extends StatefulWidget {
  final int index;
  final String name;
  final Map<String, Object>? features;
  BuildBakeryItem(
      {Key? key, required this.name, this.features, required this.index})
      : super(key: key);
  @override
  BuildBakeryItemState createState() => BuildBakeryItemState();
}

class BuildBakeryItemState extends State<BuildBakeryItem> {
  bool _isExpandItem = false;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    print("BuilderItem ${widget.name} & ${widget.index} Dispose !");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("hello here is ItemState of ${widget.index} ~");
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          Stack(children: [
            Card(
              margin: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shadowColor: Colors.transparent,
              color: Colors.amber[(widget.index % 5 * 100) + 100],
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          width: 30.0.w,
                          height: 20.0.h,
                          child: Image.asset(
                            'assets/No${widget.index % 5 + 1}.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            height: 18.0.h,
                            child: Row(
                              children: [
                                Container(
                                  width: 40.0.w,
                                  // color: Colors.blue[50],
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 0, 0),
                                          child: Text(
                                            //헬로
                                            '${widget.name} ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 0, 0),
                                          child: Text(
                                            "대표메뉴",
                                            style: TextStyle(
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 0, 0),
                                          child: Text(
                                            "호밀깜빠뉴, 바질치아바타, 비건샌드위치",
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: 23.0.w,
                                    // color: Colors.red,
                                    alignment: Alignment.center,
                                    child: Center(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            // padding: MaterialStateProperty.all<
                                            //     EdgeInsets>(EdgeInsets.zero),
                                            // tapTargetSize: MaterialTapTargetSize
                                            //     .shrinkWrap
                                            ),
                                        onPressed: () {
                                          //
                                        },
                                        child: Text("스토어\n 가 기 "),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_isExpandItem == false)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpandItem = !_isExpandItem;
                                });
                              },
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Center(
                                  child: Text(
                                    "더보기",
                                    style: TextStyle(
                                      //   color: Colors.black,
                                      fontSize: 10.0.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ), // 더보기용 Column
                  // if (_isExpandItem == true)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear,
                    height: _isExpandItem ? 100 : 0,
                    child: Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(0),
                      color: Colors.transparent,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isExpandItem = !_isExpandItem;
                          });
                        },
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text("접기")),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
