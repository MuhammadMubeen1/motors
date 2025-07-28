part of 'add_car_bloc.dart';

abstract class AddCarEvent {}

class LoadAddCarParamsEvent extends AddCarEvent {}

class AddCar extends AddCarEvent {
  AddCar({required this.data});

  dynamic data;
}

class UploadPhotoEvent extends AddCarEvent {
  UploadPhotoEvent({required this.data});

  Map<String, dynamic> data;
}

class UpdateCarEvent extends AddCarEvent {
  UpdateCarEvent({required this.data});

  Map<String, dynamic> data;
}
