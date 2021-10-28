// ignore_for_file: non_constant_identifier_names

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
// List와 Set 타입은 내부 요소의 값이 변경되어도 감지하지 못하기에
// list와 set이 완전히 같은지 체크하는 용도로 쓰이는 함수

Function listEq = const ListEquality().equals;
Function setEq = const SetEquality().equals;

class SharedValues {
  static ValueNotifier<String> _p_appBarTitleValueNotifier =
      ValueNotifier<String>('빵판다 홈');
  static ValueNotifier<String> get p_appBarTitleValueNotifier =>
      _p_appBarTitleValueNotifier;

  static Color mainColor = Color.fromRGBO(27, 115, 64, 0.8);
}

ScrollPhysics CupertinoScrollPhysics =
    BouncingScrollPhysics(parent: const AlwaysScrollableScrollPhysics());
// 페이지 변환되었을때 AppBar 타이틀 변경하는 Notifier
