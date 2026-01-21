part of 'location_cubit.dart';

sealed class LocationState {}

final class LocationInitial extends LocationState {}

final class LocationsFetching extends LocationState {}

final class LocationFetchEmpty extends LocationState {}

final class LocationAdding extends LocationState {}

final class LocationsFetched extends LocationState {
  LocationsFetched({required this.locations, required this.selectedId});
  final List<LocationItemModel> locations;
  final String selectedId;
}

final class LocationAdded extends LocationState {
  LocationAdded({required this.location});
  final LocationItemModel location;
}

final class LocationAddingFailure extends LocationState {
  LocationAddingFailure({required this.message});
  final String message;
}

final class LocationsFetchFailure extends LocationState {
  LocationsFetchFailure({this.message = 'Failed to fetch locations'});
  final String message;
}
