part of 'restore_password_bloc.dart';

abstract class RestorePasswordState {}

class InitialRestorePasswordState implements RestorePasswordState {}

class LoadingRestorePasswordState implements RestorePasswordState {}

class SuccessRestorePasswordState implements RestorePasswordState {
  SuccessRestorePasswordState(this.restorePasswordResponse);

  final RestorePasswordResponse restorePasswordResponse;
}

class ErrorRestorePasswordState implements RestorePasswordState {
  ErrorRestorePasswordState(this.message);

  final String? message;
}
