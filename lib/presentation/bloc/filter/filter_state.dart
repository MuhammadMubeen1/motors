part of 'filter_bloc.dart';

abstract class FilterState {}

class InitialFilterState extends FilterState {}

class InitialFilterListingState extends FilterState {}

class LoadedFilterState extends FilterState {
  LoadedFilterState(this.filter, this.featuredResponse);

  final List<dynamic> filter;
  final List<BaseFeaturedResponse> featuredResponse;
}

class LoadedFilteredListingsState extends FilterState {
  LoadedFilteredListingsState(this.loadedFilteredListings);

  List<dynamic> loadedFilteredListings;
}

class ErrorFilterState extends FilterState {
  ErrorFilterState(this.message);

  final String? message;
}

class ErrorFilterListingState extends FilterState {}
