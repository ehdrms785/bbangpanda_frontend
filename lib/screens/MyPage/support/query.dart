import 'package:get/get.dart';

class MyPageQuery {
  static String loginMutation = """
      mutation login(\$email: String, \$phonenumber: String, \$password: String!) {
    login(email: \$email, phonenumber: \$phonenumber, password: \$password) {
      ok
      error
      customToken
      customTokenExpired
      refreshToken
      refreshTokenExpired
     }
  }
  """;

  static String userDetailQuery = """
    query userDetail {
      userDetail {
       id
       username
       orderListCount
      }
    } 
  """;
  static String editUserDetailQuery = """
    query userDetail {
      userDetail {
       email
       username
       phonenumber
      }
    } 
  """;
  static String editProfilelMutation = """
    mutation editProfile(\$username: String, \$phonenumber: String) {
      editProfile(username: \$username, phonenumber: \$phonenumber) {
       ok
       error
      }
    } 
  """;

  static String createUserMutation = """
  mutation createUser(\$username: String!, \$email: String!, \$phonenumber: String!, \$password: String!, \$uid: String!) {
    createUser(username: \$username, email: \$email, phonenumber: \$phonenumber, password: \$password, uid: \$uid) {
        ok
        error
        customToken
        customTokenExpired
        refreshToken
     }
  }
""";

  static String sendSmsMutation = """
    mutation sendSms(\$phonenumber: String!) {
      sendSms( phonenumber: \$phonenumber) {
       ok
       code
       error
      }
    } 
  """;
}
