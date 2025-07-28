import 'package:dio/dio.dart';
import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/services/http_service.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/add_car/add_car_response.dart';
import 'package:motors_app/data/models/delete_car/delete_car_response.dart';

abstract class AddCarDataSource {
  Future<AddCarResponse> getAddCarParams();
  Future<AddedCarResponse> addCar({Map<String, dynamic>? data});
  Future<DeleteCarResponse> deleteCar(int carId);
  Future getEditCarData(int carId);
  Future updateCar({Map<String, dynamic>? data});
  Future uploadCarPhoto({Map<String, dynamic>? data});
}

class AddCarRemoteDataSource extends AddCarDataSource {
  final HttpService _httpService = HttpService();

  // Helper method to print cURL request
  void _printCurl(RequestOptions options, [dynamic data]) {
    final headers = options.headers.entries
        .map((e) => '-H "${e.key}: ${e.value}"')
        .join(' ');

    String dataPart = '';
    if (data is FormData) {
      final fields =
          data.fields.map((e) => '-F "${e.key}=${e.value}"').join(' ');
      final files =
          data.files.map((e) => '-F "${e.key}=@${e.value.filename}"').join(' ');
      dataPart = '$fields $files';
    } else if (data is Map) {
      dataPart = data.entries.map((e) => '-d "${e.key}=${e.value}"').join(' ');
    }

    final curl =
        'curl -X ${options.method} "${options.uri}" $headers $dataPart';
    logger.i('cURL Request:\n$curl');
  }

  @override
  Future<AddCarResponse> getAddCarParams() async {
    try {
      final options = Options(
        headers: {
          'accept': 'Application/json',
        },
      );

      // Print cURL before making the request
      _printCurl(
        RequestOptions(
          method: 'GET',
          path: '/add-car',
          baseUrl: _httpService.dio.options.baseUrl,
          headers: options.headers,
        ),
      );

      final response = await _httpService.dio.get(
        '/add-car',
        options: options,
      );
      return AddCarResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<AddedCarResponse> addCar({Map<String, dynamic>? data}) async {
    logger.i(data);

    FormData formData = FormData.fromMap(data!);

    try {
      final options = Options(
        headers: {
          'content-Type': 'application/x-www-form-urlencoded',
          'accept': 'Application/json',
        },
      );

      // Print cURL before making the request
      _printCurl(
        RequestOptions(
          method: 'POST',
          path: '/add-a-car',
          baseUrl: _httpService.dio.options.baseUrl,
          headers: options.headers,
        ),
        formData,
      );

      final response = await _httpService.dio.post(
        '/add-a-car',
        data: formData,
        options: options,
      );

      return AddedCarResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            '${e.response?.data['message']}\n${e.response?.data['not_send_required_fields']}');
      } else {
        throw Exception(e.message);
      }
    }
  }

  @override
  Future uploadCarPhoto({Map<String, dynamic>? data}) async {
    try {
      final options = Options(
        headers: {
          'content-Type': 'application/x-www-form-urlencoded',
          'accept': 'Application/json',
        },
      );

      // Print cURL before making the request
      _printCurl(
        RequestOptions(
          method: 'POST',
          path: '/upload-media',
          baseUrl: _httpService.dio.options.baseUrl,
          headers: options.headers,
        ),
        data,
      );

      final response = await _httpService.dio.post(
        '/upload-media',
        data: data,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<DeleteCarResponse> deleteCar(int carId) async {
    Map<String, dynamic> data = {
      'user_id': preferences.getString(PreferencesName.userId),
      'user_token': preferences.getString(PreferencesName.apiToken),
      'post_id': carId,
    };

    try {
      final options = Options(
        headers: {
          'content-Type': 'application/x-www-form-urlencoded',
          'accept': 'Application/json',
        },
      );

      // Print cURL before making the request
      _printCurl(
        RequestOptions(
          method: 'POST',
          path: '/delete-car',
          baseUrl: _httpService.dio.options.baseUrl,
          headers: options.headers,
        ),
        data,
      );

      final response = await _httpService.dio.post(
        '/delete-car',
        data: data,
        options: options,
      );
      return DeleteCarResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future getEditCarData(int carId) async {
    try {
      final options = Options(
        headers: {
          'accept': 'Application/json',
        },
      );

      // Print cURL before making the request
      _printCurl(
        RequestOptions(
          method: 'GET',
          path: '/get-edit-car/$carId',
          baseUrl: _httpService.dio.options.baseUrl,
          headers: options.headers,
        ),
      );

      final response = await _httpService.dio.get(
        '/get-edit-car/$carId',
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future updateCar({Map<String, dynamic>? data}) async {
    logger.i(data);
    try {
      final options = Options(
        headers: {
          'content-Type': 'application/x-www-form-urlencoded',
          'accept': 'Application/json',
        },
      );

      // Print cURL before making the request
      _printCurl(
        RequestOptions(
          method: 'POST',
          path: '/edit-car',
          baseUrl: _httpService.dio.options.baseUrl,
          headers: options.headers,
        ),
        data,
      );

      final response = await _httpService.dio.post(
        '/edit-car',
        data: data,
        options: options,
      );
      return AddedCarResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            '${e.response?.data['message']}\n${e.response?.data['not_send_required_fields']}');
      } else {
        throw Exception(e.message);
      }
    }
  }
}
