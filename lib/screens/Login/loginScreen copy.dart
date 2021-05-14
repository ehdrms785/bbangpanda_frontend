import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PhoneSignInSectionState();
}

class PhoneSignInSectionState extends State<PhoneSignInSection> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String _message = '';
  String _verificationId = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: const Text('Test sign in with phone number'),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration:
                  InputDecoration(labelText: 'Phone number (+x xxx-xxx-xxxx)'),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Phone number (+x xxx-xxx-xxxx)';
                }
                return null;
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () async {
                  _verifyPhoneNumber();
                },
                child: const Text('Verify phone number'),
              ),
            ),
            TextField(
              controller: _smsController,
              decoration: InputDecoration(labelText: 'Verification code'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () async {
                  _signInWithPhoneNumber();
                },
                child: const Text('Sign in with phone number'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _message,
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  // Example code of how to verify phone number
  void _verifyPhoneNumber() async {
    setState(() {
      _message = '';
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      print("1번");
      _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _message = 'Received phone auth credential: $phoneAuthCredential';
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print("2번");
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };
    final PhoneCodeSent codeSent =
        (String verificationId, int? forceResendingToken) async {
      print("3번");
      print(forceResendingToken);
      Get.snackbar('알림', '인증번호를 확인 해 주세요.');
      _verificationId = verificationId;
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print("4번");
      _verificationId = verificationId;
    };
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumberController.text,
      timeout: const Duration(seconds: 15),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    print(credential);
    final UserCredential user = await _auth.signInWithCredential(credential);
    //
    // try {
    // final UserCredential user = await _auth.signInWithCredential(credential);
    // UserCredential로 파이어베이스 회원가입 하고
    // currentUser 있으면 해당 유저
    if (_auth.currentUser != null) {
      _auth.currentUser!.uid;
      print("유저 있음");
      // 유저가 있는걸로 나오면 uid 전달해서 회원가입 쿼리 실행!
      // 해당 유저 삭제하고 다시 생성!
    }

    // assert(user.uid == currentUser.uid);
    // setState(() {
    //   if (user != null) {
    //     _message = 'Successfully signed in, uid: ' + user.uid;
    //   } else {
    //     _message = 'Sign in failed';
    //   }
    // });
  }
}
