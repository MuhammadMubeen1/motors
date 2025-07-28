import 'dart:convert';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/services/http_service.dart';
import 'package:motors_app/data/models/car_detail/car_detail_response.dart';
import 'package:motors_app/data/models/dealer_user/dealer_user_response.dart';


enum FavouriteActions { add, remove }
abstract class CarDetailDataSource {
  /// Get car detail by id
  Future<CarDetailResponse> getCarDetail(int? id, int? userId);
  /// Add or remove car from favourites
  Future<Response> addToFavourite(int carId, FavouriteActions action);
  Future<DealerResponse> getDealerProfile(dealerId);


}

class CarDetailRemoteDataSource implements CarDetailDataSource {
  final HttpService _httpService = HttpService();

  @override
Future<CarDetailResponse> getCarDetail(int? id, int? userId) async {
    String url = '';

    if (id == null && userId == null) {
      url = '/listing';
    } else if (id != null && userId != null) {
      url = '/listing?id=$id&user_id=$userId';
    } else {
      url = '/listing?id=$id';
    }

    try {
      final response = await _httpService.dio.get(url);

      // Print the complete response to console
      print('Car Details API Response:');
      print('URL: ${_httpService.dio.options.baseUrl}$url');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      return CarDetailResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('Error in getCarDetail:');
      print(e.message);
      print(e.response?.data);
      throw Exception(e.response);
    }
  }
  @override
  Future<Response> addToFavourite(int carId, FavouriteActions action) async {
    Map<String, dynamic> data = {
      'userId': preferences.getString(PreferencesName.userId),
      'userToken': preferences.getString(PreferencesName.apiToken),
      'carId': carId,
      'action': action == FavouriteActions.add ? 'add' : 'remove',
    };      

    // Print the complete data map
    print('Favourite Action Request Data:');
    print('URL: ${_httpService.dio.options.baseUrl}/action-with-favorite');
    print('Method: POST');
    print('Data: $data');

    try {
      final response = await _httpService.dio.post(
        '/action-with-favorite',
        data: data,
        options: Options(
          headers: {
            'content-Type': 'application/x-www-form-urlencoded',
            'accept': 'Application/json',
          },
        ),
      );

      // Print the response
      print('Favourite Action Response:');
      print('Status Code: ${response.statusCode}');
      print('Data: ${response.data}');

      return response;
    } on DioException catch (e) {
      print('Error in addToFavourite:');
      print('Error Message: ${e.message}');
      print('Error Response: ${e.response?.data}');

      if (e.response != null) {
        throw Exception(e.response?.data['message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  @override
  Future<DealerResponse> getDealerProfile(dealerId) async {
    if (dealerId.toString() == 'null') {
      dealerId = 0;
    }

    try {
      final response = await _httpService.dio.get('/user/$dealerId');

      return DealerResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }
}
 