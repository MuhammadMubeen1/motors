part of 'home_bloc.dart';

abstract class HomeState {}

class InitialHomeState extends HomeState {}

class LoadedHomeState extends HomeState {
  LoadedHomeState(this.mainPage);

  final MainPageResponse mainPage;
}

class ErrorHomeState extends HomeState {
  ErrorHomeState(this.message);

  final String? message;
}
