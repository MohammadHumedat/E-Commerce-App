import 'package:e_commerce_app/services/auth_service.dart';
import 'package:e_commerce_app/services/location_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/location_item_model.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  // Track the ID of the selected location internally
  String? _selectedId;
  final _locationService = LocationServiceImp();
  final _authService = AuthServiceImpl();
  Future<void> fetchLocations() async {
    try {
      final userId = _authService.currentUser!.uid;
      emit(LocationsFetching());
      final locations = await _locationService.fetchLocations(userId);
      if (locations.isNotEmpty) {
        _selectedId ??= locations.first.id;
        emit(LocationsFetched(locations: locations, selectedId: _selectedId!));
      } else {
        emit(LocationFetchEmpty());
      }
    } catch (error) {
      rethrow;
    }
  }

  void selectLocation(String id) {
    if (state is! LocationsFetched) return;

    final currentState = state as LocationsFetched;

    _selectedId = id;

    emit(
      LocationsFetched(
        locations: currentState.locations,
        selectedId: _selectedId!,
      ),
    );
  }

  Future<void> addLocation(String location) async {
    emit(LocationAdding());
    try {
      if (!location.contains('-')) {
        emit(LocationAddingFailure(message: 'Use format: City-Country'));
        return;
      }
      final splitLocation = location.split('-');
      final newLocation = LocationItemModel(
        id: '', // Firestore will generate the ID
        city: splitLocation[0].trim(),
        country: splitLocation[1].trim(),
        imgURL: 'https://cdn-icons-png.flaticon.com/512/1865/1865269.png',
      );
      final userId = _authService.currentUser!.uid;
      await _locationService.addLocation(userId, newLocation);

      final locations = await _locationService.fetchLocations(userId);
      _selectedId = newLocation.id; // Automatically select the new one
      emit(LocationAdded(location: newLocation));
      emit(LocationsFetched(locations: locations, selectedId: _selectedId!));
    } catch (error) {
      rethrow;
    }
  }
}
