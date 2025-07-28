import 'package:dio/dio.dart';
import 'package:motors_app/data/datasources/car_detail_datasource.dart';
import 'package:motors_app/data/models/car_detail/car_detail_response.dart';
import 'package:motors_app/data/models/dealer_user/dealer_user_response.dart';

abstract class CarDetailRepository {
  Future<CarDetailResponse> getCarDetail({int? id, int? userId});

  Future<Response> addToFavorite(int carId, FavouriteActions action);

  Future<DealerResponse> getDealerProfile(dealerId);
}

class CarDetailRepositoryImpl implements CarDetailRepository {
  final _carDetailDataSource = CarDetailRemoteDataSource();

  @override
  Future<CarDetailResponse> getCarDetail({int? id, int? userId}) async {
    try {
      final response = await _carDetailDataSource.getCarDetail(id, userId);

      return response;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<Response> addToFavorite(int carId, FavouriteActions action) async => await _carDetailDataSource.addToFavourite(
        carId,
        action,
      );

  @override
  Future<DealerResponse> getDealerProfile(dealerId) async {
    try {
      final response = await _carDetailDataSource.getDealerProfile(dealerId);

      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
