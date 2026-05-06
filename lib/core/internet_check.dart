import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetChecker {
  static late StreamSubscription<InternetConnectionStatus> mListener;

  static Future<InternetConnectionStatus> checkInternet() async {
    mListener = InternetConnectionCheckerPlus().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          print("✅ Internet Connected");
          break;
        case InternetConnectionStatus.disconnected:
          print("❌ Internet Disconnected");
          break;
      }
    });

    return await InternetConnectionCheckerPlus().connectionStatus;
  }
}
