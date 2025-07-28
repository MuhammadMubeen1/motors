part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class InitialSplashState extends SplashState {}

class LoadedSplashState extends SplashState {
  LoadedSplashState(this.appSettings);

  final AppSettingsResponse appSettings;
}

class ErrorSplashState extends SplashState {
  ErrorSplashState(this.message);

  final String? message;
}
