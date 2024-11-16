// File generated by FlutterFire CLI.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        return fuchsia;
    }
  }

  // Generate this file with credentials with the FlutterFire CLI
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCTEJGQgG_CoNSfD8LaZpQj7uKFhFwYlY8',
    appId: '1:976324609510:web:4d119a5ba6befc59e4c227',
    messagingSenderId: '976324609510',
    projectId: 'my-wallet-99fdf',
    authDomain: 'my-wallet-99fdf.firebaseapp.com',
    databaseURL: "https://my-wallet-99fdf-default-rtdb.firebaseio.com",
    storageBucket: 'my-wallet-99fdf.appspot.com',
    measurementId: 'G-TXX98KWH2B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdGnZegndZF2qOWwWA_RPrzC9iQvrydPc',
    appId: '1:976324609510:android:62ceacf3c246006de4c227',
    messagingSenderId: '976324609510',
    projectId: 'my-wallet-99fdf',
    authDomain: 'my-wallet-99fdf.firebaseapp.com',
    //databaseURL: "https://flutter-firebase-web-25540-default-rtdb.firebaseio.com",
    storageBucket: 'my-wallet-99fdf.appspot.com',
    measurementId: 'G-TXX98KWH2B',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTEJGQgG_CoNSfD8LaZpQj7uKFhFwYlY8',
    appId: '1:976324609510:web:4d119a5ba6befc59e4c227',
    messagingSenderId: '976324609510',
    projectId: 'my-wallet-99fdf',
    authDomain: 'my-wallet-99fdf.firebaseapp.com',
    //databaseURL: "https://flutter-firebase-web-25540-default-rtdb.firebaseio.com",
    storageBucket: 'my-wallet-99fdf.appspot.com',
    measurementId: 'G-TXX98KWH2B',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTEJGQgG_CoNSfD8LaZpQj7uKFhFwYlY8',
    appId: '1:976324609510:web:4d119a5ba6befc59e4c227',
    messagingSenderId: '976324609510',
    projectId: 'my-wallet-99fdf',
    authDomain: 'my-wallet-99fdf.firebaseapp.com',
    //databaseURL: "https://flutter-firebase-web-25540-default-rtdb.firebaseio.com",
    storageBucket: 'my-wallet-99fdf.appspot.com',
    measurementId: 'G-TXX98KWH2B',
  );

  static const FirebaseOptions fuchsia = FirebaseOptions(
    apiKey: 'AIzaSyCTEJGQgG_CoNSfD8LaZpQj7uKFhFwYlY8',
    appId: '1:976324609510:web:4d119a5ba6befc59e4c227',
    messagingSenderId: '976324609510',
    projectId: 'my-wallet-99fdf',
    authDomain: 'my-wallet-99fdf.firebaseapp.com',
    //databaseURL: "https://flutter-firebase-web-25540-default-rtdb.firebaseio.com",
    storageBucket: 'my-wallet-99fdf.appspot.com',
    measurementId: 'G-TXX98KWH2B',
  );
}