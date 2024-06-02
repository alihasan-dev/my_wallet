import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnectivity {

  ///Named internal constructor
  CheckConnectivity._internal();

  static final CheckConnectivity instance = CheckConnectivity._internal();

  ///factory constructor
  factory CheckConnectivity() => instance;

  ///method used to check the internet connection
  Future<bool> get hasConnection async {
    var connectionResult = await (Connectivity().checkConnectivity());
    switch (connectionResult) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.vpn:
        return true;
      default:
        return false;
    }
  }

}