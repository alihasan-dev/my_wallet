import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeInitialState()){

    on<HomeDrawerItemEvent>(_onDrawerItemClick);
    on<HomeBackPressEvent>(_onBackPress);
  }

  void _onDrawerItemClick(HomeDrawerItemEvent event, Emitter emit){
    emit(HomeDrawerItemState(index: event.index));
  }

  void _onBackPress(HomeBackPressEvent event, Emitter emit){
    emit(HomeDrawerItemState(index: event.pageIndex));
  }

}