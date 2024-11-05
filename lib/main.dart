import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../features/my_app/presentation/bloc/my_app_bloc.dart';
import '../utils/preferences.dart';
import '../features/my_app/presentation/my_app.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAdGnZegndZF2qOWwWA_RPrzC9iQvrydPc',
      appId: '1:976324609510:android:62ceacf3c246006de4c227',
      messagingSenderId: '976324609510',
      projectId: 'my-wallet-99fdf',
      storageBucket: 'my-wallet-99fdf.appspot.com'
    )
  );
  await Preferences().init();
  runApp(BlocProvider(create: (_) => MyAppBloc(), child: const MyApp()));  
}