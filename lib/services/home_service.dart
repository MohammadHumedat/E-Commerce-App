import 'package:e_commerce_app/Constants/api_paths.dart';
import 'package:e_commerce_app/models/product_item.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:flutter/material.dart';

abstract class HomeService {
  Future<List<ProductItem>> fetchHomeData();
}

class HomeServiceImp implements HomeService {
  final firestoreService = FirestoreService.instance;

  @override
  Future<List<ProductItem>> fetchHomeData() async {
    try {
      debugPrint('🔍 Fetching products from: ${ApiPaths.products()}');

      final result = await firestoreService.getCollection<ProductItem>(
        path: ApiPaths.products(),
        queryBuilder: (data, documentId) {
          debugPrint('📦 Processing product: $documentId');
          // Pass documentId to fromMap
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
}
