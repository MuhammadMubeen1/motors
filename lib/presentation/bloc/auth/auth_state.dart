part of 'auth_bloc.dart';

abstract class AuthState {}

class InitialAuthState extends AuthState {}

// --- Sign In State --- //
class LoadingSignInState extends AuthState {}

class SuccessSignInState extends AuthState {}

class ErrorSignInState extends AuthState {
  ErrorSignInState(this.message);

  final dynamic message;
}

// --- Sign Up State --- //
class LoadingSignUpState extends AuthState {}

class SuccessSignUpState extends AuthState {}

class ErrorSignUpState extends AuthState {
  ErrorSignUpState(this.message);

  dynamic message;
}

class LoadingUpdateUserState extends AuthState {}

class UpdatedUserState extends AuthState {}

class ErrorUpdateUserState extends AuthState {
  ErrorUpdateUserState(this.message);

  dynamic message;
}
