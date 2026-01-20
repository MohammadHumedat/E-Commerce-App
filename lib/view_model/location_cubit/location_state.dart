part of 'location_cubit.dart';

sealed class LocationState {}

final class LocationInitial extends LocationState {}

final class LocationsFetching extends LocationState {}

final class LocationFetchEmpty extends LocationState {}

final class LocationAdding extends LocationState {}

final class LocationsFetched extends LocationState {
  final List<LocationItemModel> locations;
  final String selectedId;
  LocationsFetched({required this.locations, required this.selectedId});
}

final class LocationAdded extends LocationState {
  final LocationItemModel location;
  LocationAdded({required this.location});
}

final class LocationAddingFailure extends LocationState {
  final String message;
  LocationAddingFailure({required this.message});
}

final class LocationsFetchFailure extends LocationState {
  final String message;
  LocationsFetchFailure({this.message = 'Failed to fetch locations'});
}
