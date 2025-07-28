part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  SignInEvent(this.login, this.password);

  final String login;
  final String password;
}

class SignUpEvent extends AuthEvent {
  SignUpEvent({
    required this.login,
    this.name,
    this.surname,
    this.phone,
    required this.email,
    required this.password,
    this.avatar,
  });

  final String login;
  final String? name;
  final String? surname;
  final String? phone;
  final String email;
  final String password;
  File? avatar;
}

class UpdateProfileEvent extends AuthEvent {
  UpdateProfileEvent({
    required this.userLogin,
    this.userName,
    this.userSurname,
    required this.userPhone,
    required this.userEmail,
    required this.userPassword,
    this.userAvatar,
    required this.userId,
    required this.userToken,
  });

  final String userLogin;
  final String? userName;
  final String? userSurname;
  final String userPhone;
  final String userEmail;
  final String userPassword;
  File? userAvatar;
  final String userId;
  final String? userToken;
}

class Logout extends AuthEvent {}
