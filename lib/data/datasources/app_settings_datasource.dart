import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:motors_app/core/services/http_service.dart';
import 'package:motors_app/data/models/app_settings/app_settings_response.dart';

abstract class AppSettingsDataSource {
  Future<AppSettingsResponse> getAppSettings();
}

class AppSettingsRemoteDataSource implements AppSettingsDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<AppSettingsResponse> getAppSettings() async {
    try {
      final response = await _httpService.dio.get('/settings');
  
      // Check if the response data is already a Map
      if (response.data is Map<String, dynamic>) {
        return AppSettingsResponse.fromJson(response.data);
      }
      // If it's a string, parse it first
      else if (response.data is String) {
        final jsonData = json.decode(response.data);
        return AppSettingsResponse.fromJson(jsonData);
      }
      // If it's neither, throw an exception
      else {
        throw Exception('Invalid response format');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('${e.response?.statusCode}/${e.response?.data}');
      } else {
        throw Exception(e.message);
      }
    }
  }
}
