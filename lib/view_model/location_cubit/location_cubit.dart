import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/location_item_model.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  // Track the ID of the selected location internally
  String? _selectedId;

  void fetchLocations() async {
    emit(LocationsFetching());
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
    
    // In a real app, wrap this in try-catch
    final locations = dummyLocationItems;
    if (locations.isNotEmpty) {
      _selectedId ??= locations.first.id;
      emit(LocationsFetched(locations: locations, selectedId: _selectedId!));
    } else {
      emit(LocationFetchEmpty());
    }
  }

  void selectLocation(String id) {
    _selectedId = id;
    if (state is LocationsFetched) {
      final currentLocations = (state as LocationsFetched).locations;
      emit(LocationsFetched(locations: currentLocations, selectedId: _selectedId!));
    }
  }

  void addLocation(String location) async {
    if (!location.contains('-')) {
      emit(LocationAddingFailure(message: 'Use format: City-Country'));
      return;
    }

    emit(LocationAdding());
    await Future.delayed(const Duration(seconds: 1));

    final splitLocation = location.split('-');
    final newLocation = LocationItemModel(
      id: DateTime.now().toIso8601String(),
      city: splitLocation[0].trim(),
      country: splitLocation[1].trim(),
      imgURL: 'https://cdn-icons-png.flaticon.com/512/1865/1865269.png',
    );

    dummyLocationItems.add(newLocation);
    _selectedId = newLocation.id; // Automatically select the new one
    emit(LocationAdded(location: newLocation));
    emit(LocationsFetched(locations: List.from(dummyLocationItems), selectedId: _selectedId!));
  }
}