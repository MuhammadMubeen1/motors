import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/main_page/main_page_response.dart';
import 'package:motors_app/data/repositories/main_page_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(InitialHomeState()) {
    on<LoadHomeEvent>((event, emit) async {
      emit(InitialHomeState());
      try {
        final MainPageResponse mainPageResponse = await _mainPageRepository.getMainPage();

        emit(LoadedHomeState(mainPageResponse));
      } catch (e, s) {
        logger.e('Error with method getMainPage() - HomeBloc', error: e, stackTrace: s);
        emit(ErrorHomeState(e.toString()));
      }
    });
  }

  final MainPageRepository _mainPageRepository = MainPageRepositoryImpl();
}
