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
        name
      }
    } 
  """;
}
