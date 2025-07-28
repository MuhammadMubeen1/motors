part of 'filter_result_bloc.dart';

abstract class FilterState {}

class InitialFilterListingState extends FilterState {}

class LoadedFilteredListingsState extends FilterState {
  LoadedFilteredListingsState(this.listings);

  final List<BaseCarDetailResponse> listings;
}

class ErrorFilterListingState extends FilterState {}

class EmptyFilteredListingState extends FilterState {}
