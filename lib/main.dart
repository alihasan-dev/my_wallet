import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/dashboard/application/bloc/dashboard_bloc.dart';
import '../utils/firebase_options.dart';
import '../features/my_app/presentation/bloc/my_app_bloc.dart';
import '../utils/preferences.dart';
import '../features/my_app/presentation/my_app.dart';
import 'core/analytics/analytics_service.dart';

Future<void> main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  if (!kIsWeb) {
    MediaStore.appFolder = "MyWallet";
    await MediaStore.ensureInitialized();
  }

  late final String projectUrl;
  late final String publishableKey;

  if (kIsWeb) {
    projectUrl = const String.fromEnvironment('PROJECT_URL');
    publishableKey = const String.fromEnvironment('PUBLISHABLE_KEY');
  } else {
    await dotenv.load();
    projectUrl = dotenv.get('PROJECT_URL');
    publishableKey = dotenv.get('PUBLISHABLE_KEY');
  }

  await Supabase.initialize(
    url: projectUrl,
    publishableKey: publishableKey,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light
    ),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } else {
    FlutterError.onError = (errorDetails) {
      FlutterError.presentError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('Uncaught error: $error\n$stack');
      return true;
    };
  }

  await AnalyticsService.instance.logEvent(
    name: 'app_started', 
    parameters: {'platform': DefaultFirebaseOptions.getCurrentPlatform}
  );
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