import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../features/my_app/presentation/bloc/my_app_bloc.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_theme.dart';
import '../../../routes/app_routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late ThemeMode themeMode;
  late Locale locale;

  @override
  Widget build(BuildContext context) {
    ///set app status bar color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: AppColors.primaryColor));
    ///set app prefered orientation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return BlocBuilder<MyAppBloc, MyAppState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case MyAppInitialState:
            state = state as MyAppInitialState;
            themeMode = state.themeMode;
            locale = state.locale;
            break;
          default:
        }
        return MaterialApp.router(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          theme: getAppTheme,
          darkTheme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            colorScheme: const ColorScheme.dark(primary: AppColors.primaryColor),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
            useMaterial3: true
          ),
          themeMode: themeMode,
          routerConfig: AppRoutes.router
        );
      }
    );
  }
}