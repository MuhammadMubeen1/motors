part of 'favourite_car_bloc.dart';

abstract class FavouriteCarState {}

class InitialFavouriteCarState extends FavouriteCarState {}

class LoadingFavouriteCarState extends FavouriteCarState {}

class SuccessFavouriteCarState extends FavouriteCarState {}

class ErrorFavouriteCarState extends FavouriteCarState {
  ErrorFavouriteCarState(this.oldValue, this.message);

  final bool oldValue;
  final String? message;
}
