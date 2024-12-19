import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../utils/preferences.dart';
part 'my_app_event.dart';
part 'my_app_state.dart';

class MyAppBloc extends Bloc<MyAppEvent, MyAppState>{

  MyAppBloc() : super(MyAppInitialState(locale: Preferences.getString(key: AppStrings.prefLanguage).getLocale, themeMode: Preferences.getString(key: AppStrings.prefTheme).getThemeMode)){
    on<MyAppChangeThemeEvent>(_onChangeThemeMode);
    on<MyAppChangeLanguageEvent>(_onChangeLangugae);
  }

  void _onChangeThemeMode(MyAppChangeThemeEvent event, Emitter emit){
    var temp = event.themeMode.toString().split('.')[1];
    Preferences.setString(key: AppStrings.prefTheme, value: temp);
    var locale = Preferences.getString(key: AppStrings.prefLanguage).getLocale;
    emit(MyAppInitialState(themeMode: event.themeMode, locale: locale));
  }

  void _onChangeLangugae(MyAppChangeLanguageEvent event, Emitter emit){
    if(event.locale == const Locale('hi','IN')){
      Preferences.setString(key: AppStrings.prefLanguage, value: AppStrings.hindi);
    } else {
      Preferences.setString(key: AppStrings.prefLanguage, value: AppStrings.english);
    }
    var theme = Preferences.getString(key: AppStrings.prefTheme).getThemeMode;
    emit(MyAppInitialState(themeMode: theme, locale: event.locale));
  }
}