import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/MyPage/myPageScreen.dart';
import 'package:bbangnarae_frontend/screens/MyPage/query.dart';
import 'package:bbangnarae_frontend/screens/SignUp/signUpScreen.dart';
import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:bbangnarae_frontend/shared/sharedClass.dart';
import 'package:bbangnarae_frontend/shared/sharedValidator.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../shared/sharedFunction.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final idTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final _focusNode = FocusScopeNode();
  final _addBtnNode = FocusNode();
  @override
  void dispose() {
    print("디스포스~~");
    _focusNode.dispose();
    _addBtnNode.dispose();
    idTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  bool _isInAsyncCall = false;
  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    print("로그인 페이지 빌드");
    return Scaffold(
      body: ModalProgressScreen(
        isAsyncCall: _isInAsyncCall,
        child: CustomScrollView(
          slivers: [
            MySliverAppBar(
              title: "빵판다 로그인",
            ),
            SliverToBoxAdapter(
              child: FormContainer(
                child: Column(
                  children: [
                    MyForm(),
                    Find_Id_PW(),
                    signUpButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//=====================
////////// functions
  ///
  void _submit() async {
    if (this.formKey.currentState!.validate()) {
      setState(() {
        _isInAsyncCall = true;
      });
      late final ErrorCode? error;
      await Future.delayed(Duration(milliseconds: 50), () async {
        error = await signInWithServer(
            idTextController.text, passwordTextController.text);
        setState(() {
          _isInAsyncCall = false;
        });
      });

      if (error != null) {
        showError(title: error!.errorCode, message: error!.errorMessage);
        return;
      }
      Get.to(MyPage());
      Get.snackbar(
        '로그인 성공',
        '야호',
        backgroundColor: Colors.white,
      );
    } else {
      String snackBarMesasge = idValidator(idTextController.text) ?? '';
      if (snackBarMesasge == "") {
        snackBarMesasge = passwordValidator(passwordTextController.text) ?? '';
      }
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.white,
        titleText: Container(
          child: Center(
            child: Text("로그인 실패"),
          ),
        ),
        messageText: Container(
          child: Center(
            child: Text(snackBarMesasge),
          ),
        ),
      );
    }
  }

//=====================
////////// Widgets
  ///
  Widget renderButton() {
    return SizedBox(
      width: 80.0.w,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: _submit,
        child: Text(
          '로그인',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0.sp,
          ),
        ),
      ),
    );
  }

  Widget signUpButton() {
    return GestureDetector(
      onTap: () async {
        idTextController.text = await Get.toNamed('/signUp');
      },
      child: Container(
        width: 80.0.w,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.3.h),
          child: Center(
            child: Text(
              '회원가입',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12.0.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget MyForm() => Form(
        key: this.formKey, // 나중에 한꺼번에 폼필드 데이터 Save할때 사용
        child: TextFieldList(),
      );
  Widget Find_Id_PW() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              print("아이디 찾기 탭");
            },
            child: Padding(
              padding: EdgeInsets.all(10.0.sp),
              child: Text(
                "아이디찾기",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12.0.sp,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              print("비밀번호 찾기 탭");
            },
            child: Padding(
              padding: EdgeInsets.all(10.0.sp),
              child: Text(
                "비밀번호찾기",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12.0.sp,
                ),
              ),
            ),
          ),
        ],
      );
  Widget TextFieldList() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RenderTextFormField(
            label: '이메일 혹은 휴대폰번호 입력',
            controller: idTextController,
            validator: (val) {
              return emailValidator(val);
            },
            autoFocus: true,
            useIcon: true,
          ),
          RenderTextFormField(
            label: '비밀번호',
            controller: passwordTextController,
            isSecure: true,
            useIcon: true,
            validator: (val) {
              return passwordValidator(val);
            },
          ),
          renderButton(),
        ],
      );
}

Future<ErrorCode?> signInWithServer(String id, String password) async {
  String email = '';
  String phoneNumber = '';
  print('id들어옴 :$id');
  try {
    if (id.startsWith('010')) {
      print("체크");
      phoneNumber = id;
    } else {
      email = id;
    }
    final result = await client.mutate(MutationOptions(
        document: gql(MyPageQuery.loginMutation),
        variables: email.isNotEmpty
            ? {'email': email, 'password': password}
            : {'phonenumber': phoneNumber, 'password': password}));
    if (result.hasException) {
      return ErrorCode(errorMessage: "로그인 접속 오류 잠시 후 다시 시도 해 주세요");
    }
    if (result.data != null) {
      final loginResult = result.data?['login'];
      if (loginResult['ok']) {
        try {
          print("로그인 완료");
          await FirebaseAuth.instance
              .signInWithCustomToken(loginResult['customToken']);
          final token = await FirebaseAuth.instance.currentUser?.getIdToken();
          Hive.box('auth').putAll({
            'token': token,
            'tokenExpired': loginResult['customTokenExpired'],
            'refreshToken': loginResult['refreshToken'],
            'refreshTokenExpired': loginResult['refreshTokenExpired']
          });
          GraphQLConfiguration.setToken(token!);
        } catch (err) {
          print("에러발생");
          print(err);
          return null;
        }
      } else {
        return loginResult['error'].split('\n');
      }
    }
    // FirebaseAuth.instance.signInWithCustomToken();
  } catch (e) {
    print(e);
  }
  return null;
}

class RenderTextFormField extends StatelessWidget {
  RenderTextFormField(
      {Key? key,
      required this.controller,
      required this.label,
      required this.validator,
      this.isSecure = false,
      this.autoFocus = false,
      this.labelSize,
      this.additional,
      this.useIcon = false,
      this.maxLength})
      : super(key: key);
  final bool? isSecure;
  final bool autoFocus;
  final TextEditingController controller;
  final String label;
  final FormFieldValidator validator;
  final Widget? additional;
  final bool useIcon;
  final int? maxLength;
  double? labelSize = 14.0.sp;

  late final ValueNotifier<bool?> isSecureNotifier = ValueNotifier(isSecure);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height: 6.0.h,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                    // width: additional == null ? 85.0.w : 72.0.w,
                    child: ValueListenableBuilder(
                  valueListenable: isSecureNotifier,
                  builder: (context, _isSecure, _) => TextFormField(
                    autofocus: autoFocus,
                    style: TextStyle(fontSize: labelSize),
                    controller: controller,
                    validator: validator,
                    obscureText: _isSecure as bool,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: maxLength,
                    decoration: new InputDecoration(
                      hintText: label,
                      counterText: "",
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                      enabledBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.grey.shade300, width: 0),
                      ),
                      focusedBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.blue),
                      ),
                      errorBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                )),
              ),
              if (useIcon)
                isSecure!
                    ? secureIcon(isSecureNotifier)
                    : removeIcon(controller),
              if (additional != null)
                Container(
                    margin: EdgeInsets.only(left: 3.0.w),
                    width: 20.0.w,
                    height: 5.0.h,
                    color: Colors.grey.shade300,
                    child: Center(child: additional))
            ],
          ),
        ),
        SizedBox(height: 3.0.h),
      ],
    );
  }
}

removeIcon(TextEditingController controller) {
  return Container(
    width: 5.0.w,
    child: GestureDetector(
      onTap: () {
        controller.clear();
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Icon(Icons.clear),
      ),
    ),
  );
}

secureIcon(ValueNotifier<bool?> isSecureNotifier) {
  return Container(
    width: 5.0.w,
    child: GestureDetector(
      onTap: () {
        isSecureNotifier.value = !isSecureNotifier.value!;
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ValueListenableBuilder(
          valueListenable: isSecureNotifier,
          builder: (context, value, child) => isSecureNotifier.value!
              ? Icon(Icons.lock_rounded)
              : Icon(Icons.lock_open_rounded),
        ),
      ),
    ),
  );
}
