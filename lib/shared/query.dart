class Queries {
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
