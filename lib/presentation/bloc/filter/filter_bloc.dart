import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/base_models/base_featured_response.dart';
import 'package:motors_app/data/repositories/filter_repository.dart';

part 'filter_event.dart';

part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(InitialFilterState()) {
    on<LoadFilterEvent>((event, emit) async {
      try {
        final List<dynamic> _filterResponse = await _filterRepository.getFilter();

        final List<BaseFeaturedResponse> _featuredResponse = await _filterRepository.getFeaturedFilter();

        emit(LoadedFilterState(_filterResponse, _featuredResponse));
      } catch (e, s) {
        logger.e('Error during with getFilter or getFeaturedFilter', error: e, stackTrace: s);
        emit(ErrorFilterState(e.toString()));
      }
    });


  }

  final _filterRepository = FilterRepositoryImpl();
}
