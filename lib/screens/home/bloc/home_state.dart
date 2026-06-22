part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

abstract class HomeActionState extends HomeState {}

// Home States
final class HomeLoadingState extends HomeState {}

final class HomeLoadedSucsessState extends HomeState {
  final List<Contact> contacts;
  HomeLoadedSucsessState({required this.contacts});
}

final class HomeErrorState extends HomeState {
  final Exception exception;
  HomeErrorState({required this.exception});
}

//Home Action States

final class HomeNavigateToOptionsPageActionState extends HomeActionState {}
