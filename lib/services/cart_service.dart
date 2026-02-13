import 'package:e_commerce_app/Constants/api_paths.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:flutter/material.dart';

abstract class CartService {
  Future<List<AddToCartModel>> loadCartItems(String userId);
  Future<void> updateCartItemQuantity(
    String userId,
    String cartItemId,
    int newQuantity,
  );
  Future<void> removeCartItem(String userId, String cartItemId);
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

  @override
  Future<void> removeCartItem(String userId, String cartItemId) async {
    // remove the document of specific cart item as a whole.
    try {
      debugPrint('Removing cart item: $cartItemId');
      await _firestoreService.deleteData(
        path: ApiPaths.cartItem(userId, cartItemId),
      );
      debugPrint('Successfully removed cart item');
    } catch (error) {
      debugPrint('Error removing cart item: $error');
      rethrow;
    }
  }

  @override
  Future<void> updateCartItemQuantity(
    // Update the quantity field in cart item.
    String userId,
    String cartItemId,
    int newQuantity,
  ) async {
    try {
      await _firestoreService.updateData(
        path: ApiPaths.cartItem(userId, cartItemId),
        data: {'quantity': newQuantity},
      );
    } catch (error) {
      rethrow;
    }
  }
}
