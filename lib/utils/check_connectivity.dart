import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnectivity {

  static CheckConnectivity? _checkConnectivity;

  ///named internal constructor
  CheckConnectivity._internal();

  ///factory constructor
  factory CheckConnectivity() {
    _checkConnectivity ??= CheckConnectivity._internal();
    return _checkConnectivity!;
  }

  ///method used to check the internet connection
  Future<bool> get hasConnection async {
    var connectionResult = await (Connectivity().checkConnectivity());
    for(var item in connectionResult) {
      switch (item) {
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
    return false;
  }

}