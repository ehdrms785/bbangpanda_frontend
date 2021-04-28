import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:hive/hive.dart';

bool loggedInCheck() {
  var token = Hive.box('auth').get('token');
  if (token != null) {
    GraphQLConfiguration.setToken(token);
    return true;
  }
  return false;
}
