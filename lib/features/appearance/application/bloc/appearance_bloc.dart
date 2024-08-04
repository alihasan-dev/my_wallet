import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'appearance_event.dart';
part 'appearance_state.dart';

class ApperanceBloc extends Bloc<AppearanceEvent, ApperanceState>{

  ApperanceBloc() : super(ApperanceInitialState()){
    on<ApperanceChangeThemeEvent>(_onLanguageChangeEvent);
  }

  void _onLanguageChangeEvent(ApperanceChangeThemeEvent event, Emitter emit){
    emit(ApperanceThemeChangeState(themeMode: event.themeMode));
  }
}