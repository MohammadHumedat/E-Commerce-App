import 'package:e_commerce_app/Constants/api_paths.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:flutter/material.dart';

abstract class CartService {
  Future<List<AddToCartModel>> loadCartItems(String userId);
}

class CartServiceImp extends CartService {
  final _firestoreService = FirestoreService.instance;

  @override
  Future<List<AddToCartModel>> loadCartItems(String userId) async {
    try {
      debugPrint(' Fetching cart items: ${ApiPaths.fetchCartItems(userId)}');

      final result = await _firestoreService.getCollection<AddToCartModel>(
        path: ApiPaths.fetchCartItems(userId),
        queryBuilder: (data, documentId) {
          debugPrint(' Processing cart: $documentId');
          return AddToCartModel.fromMap(data, documentId: documentId);
        },
      );

      debugPrint(' Fetched ${result.length} cart items');
      return result;
    } catch (e) {
      debugPrint(' Error fetching cart items: $e');
      rethrow;
    }
  }
}
