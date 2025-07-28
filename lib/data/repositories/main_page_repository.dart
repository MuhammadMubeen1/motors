import 'package:motors_app/data/datasources/main_page_datasource.dart';
import 'package:motors_app/data/models/main_page/main_page_response.dart';

abstract class MainPageRepository {
  Future<MainPageResponse> getMainPage();
}

class MainPageRepositoryImpl implements MainPageRepository {
  final _mainPageRemoteDataSource = MainPageRemoteDataSource();

  @override
  Future<MainPageResponse> getMainPage() async => await _mainPageRemoteDataSource.getMainPage();
}
