import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';
import 'package:my_wallet/utils/preferences.dart';
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
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    Preferences.setBool(key: AppStrings.prefBiometricAuthentication, value: Preferences.getBool(key: AppStrings.prefEnableBiometric));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyAppBloc, MyAppState>(
      builder: (context, state) {
        switch (state) {
          case MyAppInitialState _:
            themeMode = state.themeMode;
            locale = state.locale;
            break;
          }
        return MaterialApp.router(
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
          ),
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          theme: MyAppTheme.getAppTheme,
          darkTheme: ThemeData(
            scaffoldBackgroundColor: AppColors.backgroundColorDark,
            colorScheme: const ColorScheme.dark(primary: AppColors.primaryColor),
            appBarTheme: const AppBarTheme(backgroundColor: AppColors.backgroundColorDark),
            useMaterial3: true,
            textTheme: const TextTheme().apply(bodyColor: AppColors.white.withValues(alpha: 0.9)),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: ZoomPageTransitionsBuilder(
                  allowEnterRouteSnapshotting: false
                )
              }
            )
          ),
          themeMode: themeMode,
          routerConfig: AppRoutes.router
        );
      }
    );
  }
}