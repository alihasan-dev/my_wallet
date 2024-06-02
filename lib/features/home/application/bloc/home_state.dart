part of 'home_bloc.dart';

sealed class HomeState {}

class HomeInitialState extends HomeState {}

class HomeDrawerItemState extends HomeState {
  int index;
  HomeDrawerItemState({required this.index});
}

