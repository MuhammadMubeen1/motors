import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/base_models/base_car_response.dart';
import 'package:motors_app/data/repositories/filter_repository.dart';

part 'filter_result_event.dart';

part 'filter_result_state.dart';

class FilterResultBloc extends Bloc<FilterResultEvent, FilterState> {
  FilterResultBloc() : super(InitialFilterListingState()) {
    on<AddToFilterEvent>((event, emit) async {
      emit(InitialFilterListingState());

      try {
        // Log the incoming event to verify the filters are correct
        logger.d('Filters: ${event.condition}');

        final _filterResponse = await _filterRepository.getFilterResults(
          limit: event.limit,
          condition: event.condition, // Passing the filters here
          min_price: event.min_price,
          max_price: event.max_price,
          min_ca_year: event.min_year,
          max_ca_year: event.max_year,
          max_search_radius: event.search_radius,
        );

        if (_filterResponse.listings.isEmpty) {
          emit(EmptyFilteredListingState());
        } else {
          emit(LoadedFilteredListingsState(_filterResponse.listings));
        }
      } catch (e, s) {
        // Log error
        logger.e('Error during getFilteredListings', error: e, stackTrace: s);
        emit(ErrorFilterListingState());
      }
    });
  }

  final _filterRepository = FilterRepositoryImpl();
}
