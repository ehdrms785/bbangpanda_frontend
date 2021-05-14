String? nameValidator(String val) {
  if (val.length < 1) {
    return '이름을 입력 해 주세요';
  }
  return null;
}

String? signCodeValidator(String val) {
  if (val.length < 6) {
    return '휴대폰 번호로 발송된 인증코드 6자리 입력 해 주세요';
  }
  return null;
}

String? phoneValidator(String val) {
  if (val.length < 1) {
    return '휴대폰번호 입력 해 주세요';
  } else if (RegExp(r'^010((?!@).)*$').hasMatch(val)) {
    return phoneValidateModule(val);
  }
  return null;
}

String? emailValidator(String val) {
  if (val.length < 1) {
    return '이메일 입력 해 주세요';
  } else {
    return emailValidateModule(val);
  }
}

String? idValidator(String val) {
  if (val.length < 1) {
    return '이메일 혹은 휴대폰번호 입력 해 주세요';
  }
  if (RegExp(r'^010((?!@).)*$').hasMatch(val)) {
    return phoneValidateModule(val);
  } else {
    return emailValidateModule(val);
  }
}

String? passwordValidator(String val) {
  if (val.length < 1) {
    return '비밀번호는 필수사항입니다.';
  } else if (val.length < 8) {
    return '비밀번호는 8자 이상 입력해주세요!';
  }
  return null;
}

String? phoneValidateModule(String val) {
  if (!RegExp(r'^010\d{4}\d{4}').hasMatch(val)) {
    return '휴대폰번호 전체 자리를 입력 해 주세요';
  }
  if (!RegExp(r'^010\d{8}$').hasMatch(val)) {
    return '휴대폰번호가 너무 깁니다';
  }
  return null;
}

String? emailValidateModule(String val) {
  if (!RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(val)) {
    return '잘못된 이메일 형식입니다.';
  }
  return null;
}

String? signUpTotalValidator(
    {required String email,
    required String password,
    required String name,
    required String phonenumber,
    required String signCode}) {
  String? error;
  error = emailValidator(email);
  if (error != null) return error;
  error = passwordValidator(password);
  if (error != null) return error;
  error = nameValidator(name);
  if (error != null) return error;
  error = phoneValidator(phonenumber);
  if (error != null) return error;
  error = signCodeValidator(signCode);
  return error;
}
