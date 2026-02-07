import 'package:e_commerce_app/Constants/api_paths.dart';
import 'package:e_commerce_app/models/product_item.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:flutter/material.dart';

abstract class FavoriteService {
  Future<void> addFavorite(String userId, ProductItem product);
  Future<List<ProductItem>> loadFavoriteData(String userId);
  Future<void> removeFavorite(String userId, String productId);
}

class FavoriteServiceImpl extends FavoriteService {
  final firestoreService = FirestoreService.instance;
  @override
  Future<void> addFavorite(String userId, ProductItem product) async {
    try {
      debugPrint(' Adding product ${product.id} to favorites for user $userId');

      await firestoreService.setData(
        path: ApiPaths.favoriteProduct(userId, product.id),
        data: product.toMap(),
      );

      debugPrint(' Successfully added to favorites');
    } catch (e) {
      debugPrint(' Error adding to favorites: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProductItem>> loadFavoriteData(String userId) async {
   try {
      debugPrint(
        ' Fetching Favorite items from: ${ApiPaths.favoriteData(userId)}',
      );

      final result = await firestoreService.getCollection<ProductItem>(
        path: ApiPaths.favoriteData(userId),
        queryBuilder: (data, documentId) {
          debugPrint(' Processing favorite product: $documentId');
          return ProductItem.fromMap(data, documentId: documentId);
        },
      );

      debugPrint(' Fetched ${result.length} favorite products');
      return result;
    } catch (e) {
      debugPrint(' Error fetching favorite products: $e');
      return []; // Return empty list instead of throwing
    }
  }

  @override
  Future<void> removeFavorite(String userId, String productId) async {
    try {
      debugPrint(
        ' Removing product $productId from favorites for user $userId',
      );

      await firestoreService.deleteData(
        path: ApiPaths.favoriteProduct(userId, productId),
      );

      debugPrint(' Successfully removed from favorites');
    } catch (e) {
      debugPrint(' Error removing from favorites: $e');
      rethrow;
    }
  }
}
