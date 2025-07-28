import 'package:dio/dio.dart';
import 'package:motors_app/data/datasources/add_car_datasource.dart';
import 'package:motors_app/data/datasources/place_search_datasource.dart';
import 'package:motors_app/data/models/add_car/add_car_response.dart';
import 'package:motors_app/data/models/delete_car/delete_car_response.dart';
import 'package:motors_app/data/models/place_search/place_search.dart';

abstract class AddCarRepository {
  Future getAddCarParams();

  Future<AddedCarResponse> addCar({Map<String, dynamic> data});

  Future<DeleteCarResponse> deleteCar(int carId);

  Future getEditCarData(int carId);

  Future<AddedCarResponse> updateCar({Map<String, dynamic> data});

  Future uploadCarPhoto({Map<String, dynamic> data});

  Future searchPlaces({search});
}

class AddCarRepositoryImpl extends AddCarRepository {
  final _addCarDataSource = AddCarRemoteDataSource();
  final _placeSearchDataSource = PlaceSearchRemoteDataSource();

  @override
  Future getAddCarParams() async {
    try {
      AddCarResponse addCarResponse = await _addCarDataSource.getAddCarParams();

      return addCarResponse;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future searchPlaces({search}) async {
    try {
      PlaceSearchResponse placeSearchResponse = await _placeSearchDataSource.getAutoComplete(search);

      return placeSearchResponse;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<AddedCarResponse> addCar({Map<String, dynamic>? data}) async => await _addCarDataSource.addCar(data: data!);

  @override
  Future uploadCarPhoto({Map<String, dynamic>? data}) async {
    try {
      final response = await _addCarDataSource.uploadCarPhoto(data: data!);

      return response;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<DeleteCarResponse> deleteCar(int carId) async => await _addCarDataSource.deleteCar(carId);

  @override
  Future getEditCarData(int carId) async => await _addCarDataSource.getEditCarData(carId);

  @override
  Future<AddedCarResponse> updateCar({Map<String, dynamic>? data}) async {
    try {
      AddedCarResponse addedCarResponse = await _addCarDataSource.updateCar(data: data!);

      return addedCarResponse;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }
}
