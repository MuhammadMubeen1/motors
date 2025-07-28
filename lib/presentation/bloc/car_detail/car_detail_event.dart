part of 'car_detail_bloc.dart';

abstract class CarDetailEvent {}

class CarDetailLoadEvent extends CarDetailEvent {
  CarDetailLoadEvent({required this.id, this.userId});

  final int id;
  final int? userId;
}
