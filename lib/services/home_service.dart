import 'package:e_commerce_app/Constants/api_paths.dart';
import 'package:e_commerce_app/models/category_model.dart';
import 'package:e_commerce_app/models/product_item.dart';
import 'package:e_commerce_app/models/slider_carousel_model.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:flutter/material.dart';

abstract class HomeService {
  Future<List<ProductItem>> fetchHomeData();
  Future<List<SliderCarouselModel>> fetchCarouselData();
  Future<List<CategoryModel>> fetchCategoryData();

}

class HomeServiceImp implements HomeService {
  final firestoreService = FirestoreService.instance;

  // @override
  // Future<List<ProductItem>> fetchFavoriteData(String userId) async {
  //   try {
  //     debugPrint(
  //       ' Fetching Favorite items from: ${ApiPaths.favoriteData(userId)}',
  //     );

  //     final result = await firestoreService.getCollection<ProductItem>(
  //       path: ApiPaths.favoriteData(userId),
  //       queryBuilder: (data, documentId) {
  //         debugPrint(' Processing favorite product: $documentId');
  //         return ProductItem.fromMap(data, documentId: documentId);
  //       },
  //     );

  //     debugPrint(' Fetched ${result.length} favorite products');
  //     return result;
  //   } catch (e) {
  //     debugPrint(' Error fetching favorite products: $e');
  //     return []; // Return empty list instead of throwing
  //   }
  // }

  @override
  Future<List<ProductItem>> fetchHomeData() async {
    try {
      debugPrint('Fetching products from: ${ApiPaths.products()}');

      final result = await firestoreService.getCollection<ProductItem>(
        path: ApiPaths.products(),
        queryBuilder: (data, documentId) {
          debugPrint(' Processing product: $documentId');
          return ProductItem.fromMap(data, documentId: documentId);
        },
      );

      debugPrint(' Fetched ${result.length} products');
      return result;
    } catch (e) {
      debugPrint(' Error fetching products: $e');
      rethrow;
    }
  }

  @override
  Future<List<SliderCarouselModel>> fetchCarouselData() async {
    try {
      final result = await firestoreService.getCollection<SliderCarouselModel>(
        path: ApiPaths.announcement(),
        queryBuilder: (data, documentId) {
          return SliderCarouselModel.fromMap(data);
        },
      );
      debugPrint(' Fetched ${result.length} Carousels Data');
      return result;
    } catch (e) {
      debugPrint(' Error fetching Carousel data: $e');
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> fetchCategoryData() async {
    try {
      final result = await firestoreService.getCollection<CategoryModel>(
        path: ApiPaths.category(),
        queryBuilder: (data, documentId) => CategoryModel.fromMap(data),
      );
      debugPrint(' Fetched ${result.length} Category Data');
      return result;
    } catch (e) {
      debugPrint(' Error fetching Category data: $e');
      rethrow;
    }
  }

  // @override
  // Future<void> addFavoriteItem(ProductItem product, String userId) async {
  //   try {
  //     debugPrint(
  //       ' Adding product ${product.id} to favorites for user $userId',
  //     );

  //     await firestoreService.setData(
  //       path: ApiPaths.favoriteProduct(userId, product.id),
  //       data: product.toMap(),
  //     );

  //     debugPrint(' Successfully added to favorites');
  //   } catch (e) {
  //     debugPrint(' Error adding to favorites: $e');
  //     rethrow;
  //   }
  // }

  // @override
  // Future<void> removeFavoriteItem(String productId, String userId) async {
  //   try {
  //     debugPrint(
  //       ' Removing product $productId from favorites for user $userId',
  //     );

  //     await firestoreService.deleteData(
  //       path: ApiPaths.favoriteProduct(userId, productId),
  //     );

  //     debugPrint(' Successfully removed from favorites');
  //   } catch (e) {
  //     debugPrint(' Error removing from favorites: $e');
  //     rethrow;
  //   }
  // }
}
