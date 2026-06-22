part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeOptionsButtonClickedEvent extends HomeEvent {}

class HomeRefreshAfterErrorClickedEvent extends HomeEvent {}
