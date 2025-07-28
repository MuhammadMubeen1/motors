import 'package:dio/dio.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/services/http_service.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/base_models/base_featured_response.dart';
import 'package:motors_app/data/models/filter/filter_result_response.dart';

abstract class FilterDataSource {
  Future<List<dynamic>> getFilter();
  Future<List<BaseFeaturedResponse>> getFeaturedFilter();
  Future<FilterResultResponse> getFilterResults(
    limit,
    min_ca_year,
    max_ca_year,
    min_price,
    max_price,
    max_search_radius,
    condition,
    body,
    serie,
    mileage,
    fuel,
    engine,
    fuel_consumption,
    transmission,
    drive,
    fuel_economy,
    exterior_color,
    interior_color,
  );
}

class FilterRemoteDataSource implements FilterDataSource {
  final HttpService _httpService = HttpService();

  // Helper function to print cURL command
  void _printCurl(RequestOptions options) {
    final method = options.method.toUpperCase();
    final url = options.uri.toString();
    final headers = options.headers.entries
        .map((e) => '-H "${e.key}: ${e.value}"')
        .join(' ');
    final data = options.data != null ? '--data \'${options.data}\'' : '';

    final curl = 'curl -X $method $headers $data "$url"';
    logger.i('cURL Request: $curl');
  }

  @override
  Future<List<dynamic>> getFilter() async {
    try {
      final response = await _httpService.dio.get(
        '/filter',
        options: Options(
          headers: _httpService.dio.options.headers,
        ),
      );

      // Print cURL before making the request
      _printCurl(response.requestOptions);

      List<dynamic> _responseFilter = [];
      _responseFilter.add(response.data);
      return _responseFilter;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  @override
  Future<List<BaseFeaturedResponse>> getFeaturedFilter() async {
    List<BaseFeaturedResponse> _featuredList = [];

    try {
      final response = await _httpService.dio.get(
        '/featured',
        options: Options(
          headers: _httpService.dio.options.headers,
        ),
      );

      // Print cURL before making the request
      _printCurl(response.requestOptions);

      for (var element in response.data['featured']) {
        _featuredList.add(BaseFeaturedResponse.fromJson(element));
      }

      return _featuredList;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data.toString());
      } else {
        throw Exception(e.message);
      }
    }
  }

  @override
  Future<FilterResultResponse> getFilterResults(
    limit,
    min_ca_year,
    max_ca_year,
    min_price,
    max_price,
    max_search_radius,
    condition,
    body,
    serie,
    mileage,
    fuel,
    engine,
    fuel_consumption,
    transmission,
    drive,
    fuel_economy,
    exterior_color,
    interior_color,
  ) async {
    try {
      Map<String, dynamic> queryParams = {};

      queryParams = {
        for (var el in filteredListForSearch)
          for (var entry in el.entries) '${entry.key}': entry.value,
        'limit': limit,
        'min_price': min_price,
        'max_price': max_price,
        'min_ca_year': min_ca_year ?? 0,
        'max_ca_year': max_ca_year ?? 0,
        'max_search_radius': max_search_radius,
      };

      logger.i(queryParams);

      final response = await _httpService.dio.get(
        '/filtered-listings',
        queryParameters: queryParams,
        options: Options(
          headers: _httpService.dio.options.headers,
        ),
      );

      // Print cURL before making the request
      _printCurl(response.requestOptions);

      return FilterResultResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data.toString());
      } else {
        throw Exception(e.message);
      }
    }
  }
}
