import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/home/application/bloc/home_event.dart';
import '../../../../features/home/application/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeInitialState()) {
    on<HomeDrawerItemEvent>(_onDrawerItemClick);
    on<HomeBackPressEvent>(_onBackPress);
    on<HomeBiometricAuthEvent>(_onBiometricAuthenticated);
  }

  void _onDrawerItemClick(HomeDrawerItemEvent event, Emitter emit){
    emit(HomeDrawerItemState(index: event.index));
  }

  void _onBackPress(HomeBackPressEvent event, Emitter emit){
    emit(HomeDrawerItemState(index: event.pageIndex));
  }

  void _onBiometricAuthenticated(HomeBiometricAuthEvent event, Emitter emit) {
    emit(HomeBiometricAuthState(isAuthenticated: event.isAuthenticated));
  }

}