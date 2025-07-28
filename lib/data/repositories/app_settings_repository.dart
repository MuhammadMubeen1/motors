import 'package:motors_app/data/datasources/app_settings_datasource.dart';
import 'package:motors_app/data/models/app_settings/app_settings_response.dart';

abstract class AppSettingsRepository {
  Future<AppSettingsResponse> getAppSettings();
}

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final _appSettingsDataSource = AppSettingsRemoteDataSource();

  @override
  Future<AppSettingsResponse> getAppSettings() async => await _appSettingsDataSource.getAppSettings();
}
