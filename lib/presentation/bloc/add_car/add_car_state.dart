part of 'add_car_bloc.dart';

abstract class AddCarState {}

class InitialAddCarState extends AddCarState {}

class LoadedAddCarParamsState extends AddCarState {
  LoadedAddCarParamsState({this.addCarResponse});

  AddCarResponse? addCarResponse;
}

class ErrorAddCarParamsState extends AddCarState {
  ErrorAddCarParamsState(this.message);

  final String? message;
}

// States of Add Car
class LoadingAddCarState extends AddCarState {}

class SuccessAddedCarState extends AddCarState {
  SuccessAddedCarState({required this.addedCarResponse});

  final AddedCarResponse addedCarResponse;
}

class ErrorAddCarState extends AddCarState {
  ErrorAddCarState({
    required this.message,
    this.specificError,
  });

  final String? message;
  final String? specificError;
}

// State of Upload photo
class LoadingUploadPhotoState extends AddCarState {}

class SuccessUploadCarPhotoState extends AddCarState {
  SuccessUploadCarPhotoState({this.response});

  final dynamic response;
}

class ErrorUploadPhotoState extends AddCarState {
  ErrorUploadPhotoState(this.message);

  final String? message;
}

class LoadingEditCarState extends AddCarState {}

class SuccessEditCarState extends AddCarState {
  SuccessEditCarState({required this.addedCarResponse});

  final AddedCarResponse addedCarResponse;
}

class ErrorEditCarState extends AddCarState {
  ErrorEditCarState(this.message);

  final String? message;
}
