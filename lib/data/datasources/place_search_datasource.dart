import 'package:dio/dio.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/services/http_service.dart';
import 'package:motors_app/data/models/place_search/place_search.dart';

abstract class PlaceSearchDataSource {
  Future<PlaceSearchResponse> getAutoComplete(String search);
}

class PlaceSearchRemoteDataSource extends PlaceSearchDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<PlaceSearchResponse> getAutoComplete(String search) async {
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    Map<String, dynamic> queryParams = {
      'key': googleApiToken,
      'input': search,
    };

    try {
      Response response = await _httpService.dio.get(
        url,
        queryParameters: queryParams,
      );

      return PlaceSearchResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }
}
