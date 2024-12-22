import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import '../features/dashboard/application/bloc/dashboard_bloc.dart';
import '../utils/firebase_options.dart';
import '../features/my_app/presentation/bloc/my_app_bloc.dart';
import '../utils/preferences.dart';
import '../features/my_app/presentation/my_app.dart';

Future<void> main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Preferences().init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MyAppBloc()),
        BlocProvider(create: (_) => DashboardBloc())
      ], 
      child: const MyApp()
    )
  ); 
}