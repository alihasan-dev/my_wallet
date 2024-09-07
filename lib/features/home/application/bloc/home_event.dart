sealed class HomeEvent {}

class HomeDrawerItemEvent extends HomeEvent {
  int index;
  HomeDrawerItemEvent({required this.index});
}

class HomeBackPressEvent extends HomeEvent {
  int pageIndex;
  HomeBackPressEvent({required this.pageIndex});
}