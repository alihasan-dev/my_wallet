import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import '../constants/app_font.dart';
import '../constants/app_style.dart';
import 'app_size.dart';

abstract class MyAppTheme {

  static const double columnWidth = 380.0;

  static const double navRailWidth = 64.0;

  static bool isColumnModeByWidth(double width) => width > columnWidth * 2 + navRailWidth;

  static bool isColumnMode(BuildContext context) => isColumnModeByWidth(MediaQuery.of(context).size.width);

  static bool isThreeColumnMode(BuildContext context) => MediaQuery.of(context).size.width > MyAppTheme.columnWidth * 3.5;

  static const Duration animationDuration = Duration(milliseconds: 240);

  ///method used to convert color to material color
  static MaterialColor createMaterialColor(Color? color) {
    if (color == null) return Colors.indigo;
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final double r = color.r, g = color.g, b = color.b;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        (r + (ds < 0 ? r : (255 - r)) * ds).toInt(),
        (g + (ds < 0 ? g : (255 - g)) * ds).toInt(),
        (b + (ds < 0 ? b : (255 - b)) * ds).toInt(),
        1,
      );
    }
    return MaterialColor(color.toARGB32(), swatch);
  }

  static ThemeData get getAppTheme {
    return ThemeData(
      //main color of app
      primarySwatch: Colors.indigo,
      primaryColor: Colors.indigo,
      primaryColorLight: Colors.indigo.withValues(alpha: 0.7),
      primaryColorDark: Colors.indigo,
      disabledColor: Colors.grey,
      //ripple color
      splashColor: Colors.grey.withValues(alpha: 0.5),
      fontFamily: 'OpenSans',
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      //card view theme
      cardTheme: const CardTheme(color: Colors.white, elevation: AppSize.s4, shadowColor: Colors.grey),
      ///app bar theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        color: Colors.indigo,
        elevation: AppSize.s4,
        shadowColor: Colors.grey,
        titleTextStyle: getRegularStyle(color: Colors.white),
      ),
      //Buttom theme
      bottomSheetTheme: const BottomSheetThemeData(
        shape: StadiumBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: getRegularStyle(color: Colors.white),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s12))) 
        ),
      ),

      //Text theme
      textTheme: TextTheme(
        displayLarge: getSemiBoldStyle(color: Colors.grey, fontSize: AppFontSize.s18),
        displayMedium: getMediumStyle(color: Colors.grey, fontSize: AppFontSize.s16),
        displaySmall: getRegularStyle(color: Colors.grey, fontSize: AppFontSize.s14),
        bodySmall: getRegularStyle(color: Colors.grey)
      ).apply(bodyColor: AppColors.black),
      //input decoration theme(text form field)
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(AppSize.s8),
        //hint style
        hintStyle: getRegularStyle(color: Colors.grey),
        //label style
        labelStyle: getMediumStyle(color: Colors.grey),
        //error style
        errorStyle: getRegularStyle(color: Colors.red),
        //enable border
        // outlineBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.grey, width: AppSize.s4),
        //   borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))
        // )
        
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(
            allowEnterRouteSnapshotting: false
          )
        }
      )
    );
  }
}