import 'package:dio/dio.dart';
import 'package:motors_app/core/services/http_service.dart';
import 'package:motors_app/data/models/main_page/main_page_response.dart';

abstract class MainPageDataSource {
  Future<MainPageResponse> getMainPage();
}

class MainPageRemoteDataSource implements MainPageDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<MainPageResponse> getMainPage() async {
    try {
      final response = await _httpService.dio.get('/main-page');

      return MainPageResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }
}
