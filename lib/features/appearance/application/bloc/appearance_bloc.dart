import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/features/appearance/application/bloc/appearance_event.dart';
import 'package:my_wallet/features/appearance/application/bloc/appearance_state.dart';

class ApperanceBloc extends Bloc<AppearanceEvent, ApperanceState>{

  ApperanceBloc() : super(ApperanceInitialState()){
    on<ApperanceChangeThemeEvent>(_onLanguageChangeEvent);
  }

  void _onLanguageChangeEvent(ApperanceChangeThemeEvent event, Emitter emit){
    emit(ApperanceThemeChangeState(themeMode: event.themeMode));
  }
}