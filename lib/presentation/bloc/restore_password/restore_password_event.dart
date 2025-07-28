part of 'restore_password_bloc.dart';

abstract class RestorePasswordEvent {}

class ResetPasswordEvent extends RestorePasswordEvent {
  ResetPasswordEvent(this.email);

  final String email;
}
