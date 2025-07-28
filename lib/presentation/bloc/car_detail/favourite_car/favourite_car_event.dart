part of 'favourite_car_bloc.dart';

abstract class FavouriteCarEvent {}

class AddToFavouriteEvent extends FavouriteCarEvent {
  AddToFavouriteEvent({
    required this.carId,
    required this.action,
  });

  final int carId;
  final FavouriteActions action;
}
