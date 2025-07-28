part of 'profile_bloc.dart';

abstract class ProfileState {}

class InitialProfileState extends ProfileState {}

// State of load profile info
class LoadingProfileState extends ProfileState {}

class LoadedProfileState extends ProfileState {
  LoadedProfileState(this.userInfo);

  final UserInfoResponse userInfo;
}

class ErrorProfileState extends ProfileState {
  ErrorProfileState(this.message);

  final String? message;
}

// States of Delete car
class LoadingDeleteCarState extends ProfileState {}

class SuccessDeleteCarState extends ProfileState {
  SuccessDeleteCarState({required this.response});

  final DeleteCarResponse response;
}

class ErrorDeleteCarState extends ProfileState {
  ErrorDeleteCarState(this.message);

  final String? message;
}

// States of Remove car from fav
class LoadingRemoveFromFavCarState extends ProfileState {}

class SuccessRemoveFromFavCarState extends ProfileState {}

class ErrorRemoveFromFavCarState extends ProfileState {
  ErrorRemoveFromFavCarState(this.message);

  final String? message;
}

class LoadingEditCarState extends ProfileState {}

class LoadedEditCarState extends ProfileState {
  LoadedEditCarState({required this.response});

  Map<String, dynamic> response = {};
}

class ErrorEditCarState extends ProfileState {
  ErrorEditCarState(this.message);

  final String? message;
}
