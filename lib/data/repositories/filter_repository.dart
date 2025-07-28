import 'package:motors_app/data/datasources/filter_data_source.dart';
import 'package:motors_app/data/models/base_models/base_featured_response.dart';
import 'package:motors_app/data/models/filter/filter_result_response.dart';

abstract class FilterRepository {
  Future<List<dynamic>> getFilter();

  Future<List<BaseFeaturedResponse>> getFeaturedFilter();

  Future<FilterResultResponse> getFilterResults({
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
  });
}

class FilterRepositoryImpl implements FilterRepository {
  final _filterDataSource = FilterRemoteDataSource();

  @override
  Future<List<dynamic>> getFilter() async => _filterDataSource.getFilter();

  @override
  Future<List<BaseFeaturedResponse>> getFeaturedFilter() async => await _filterDataSource.getFeaturedFilter();

  @override
  Future<FilterResultResponse> getFilterResults({
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
  }) async {
    return _filterDataSource.getFilterResults(
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
}
