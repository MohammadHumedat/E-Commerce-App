import 'package:e_commerce_app/Constants/api_paths.dart';
import 'package:e_commerce_app/models/location_item_model.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:flutter/material.dart';

abstract class LocationService {
  Future<List<LocationItemModel>> fetchLocations(String userId);
  Future<void> addLocation(String userId, LocationItemModel location);
  Future<void> deleteLocation(String userId, String locationId);
}

class LocationServiceImp extends LocationService {
  final _firestore = FirestoreService.instance;
  @override
  Future<List<LocationItemModel>> fetchLocations(String userId) async {
    try {
      final locations = await _firestore.getCollection(
        path: ApiPaths.locations(userId),
        queryBuilder: (data, documentId) {
          debugPrint('Processing location : $documentId');
          return LocationItemModel.fromMap(data, documentId);
        },
      );
      return locations;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> addLocation(String userid, LocationItemModel location) async {
    try {
      await _firestore.addData(
        collectionPath: ApiPaths.locations(userid),
        data: location.toMap(),
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> deleteLocation(String userId, String locationId) async {
    try {
      await _firestore.deleteData(
        path: ApiPaths.addLocation(userId, locationId),
      );
    } catch (error) {
      rethrow;
    }
  }
}
