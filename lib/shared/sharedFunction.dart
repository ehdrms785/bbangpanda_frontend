import 'package:connectivity/connectivity.dart';

Future<bool> internetCheck() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // data
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // wifi
    return true;
  }
  return false;
}
