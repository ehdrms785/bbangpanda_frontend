class Queries {
  static String loginQuery = """
    
  """;

  static String reissueTokenMutation = """
  mutation reissueToken(\$refreshToken: String!) {
    reissueToken(refreshToken: \$refreshToken) {
          ok
          refreshToken
          error
     }
  }
""";
}
