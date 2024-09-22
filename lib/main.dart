import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../features/my_app/presentation/bloc/my_app_bloc.dart';
import '../utils/preferences.dart';
import 'features/my_app/presentation/my_app.dart';
//Updated Code by AliHasan
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Preferences().init();
  runApp(BlocProvider(create: (_) => MyAppBloc(), child: const MyApp()));  
}