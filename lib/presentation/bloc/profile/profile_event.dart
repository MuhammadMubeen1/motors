part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {
  LoadProfileEvent(this.id);

  final String? id;
}

class DeleteCarEvent extends ProfileEvent {
  DeleteCarEvent({required this.carId});

  final int carId;
}

class RemoveFavouriteCarEvent extends ProfileEvent {
  RemoveFavouriteCarEvent({required this.carId});

  final int carId;
}

class EditCarEvent extends ProfileEvent {
  EditCarEvent({required this.carId});

  final int carId;
}
