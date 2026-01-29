import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/Constants/api_paths.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/models/product_item.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class ProductDetailsService {
  Future<ProductItem> fetchProductDetails(String productId);
  Future<void> addToCart(AddToCartModel cartItem, String userId);
}

class ProductDetailsServiceImpl implements ProductDetailsService {
  @override
  Future<ProductItem> fetchProductDetails(String productId) async {
    final firestoreService = FirestoreService.instance;

    final selectedProduct = await firestoreService.getDocument<ProductItem>(
      path: ApiPaths.productDetails(productId),
      builder: (data, documentId) {
        //  Pass documentId to fromMap
        return ProductItem.fromMap(data!, documentId: documentId);
      },
    );

    return selectedProduct;
  }

  @override
  Future<void> addToCart(AddToCartModel cartItem, String userId) async {
    final firestoreService = FirestoreService.instance;

    
    // This will create or update the cart item with the product ID as the document ID
    await firestoreService.setData(
      path: ApiPaths.cartItem(userId, cartItem.product.id),
      data: cartItem.toMap(),
    );
  }
}

/// Helper function to upload initial products to Firestore
/// Call this ONCE from your app to populate the database
Future<void> uploadInitialProducts() async {
  final firestoreService = FirestoreService.instance;

  try {
    debugPrint(' Starting to upload products to Firestore...');

    for (var product in productItems) {
      await firestoreService.setData(
        path: '${ApiPaths.products()}/${product.id}',
        data: product.toMap(),
      );
      debugPrint(' Uploaded: ${product.productName}');
    }

    debugPrint(' All products uploaded successfully!');
  } catch (e) {
    debugPrint(' Error uploading products: $e');
    rethrow;
  }
}

/// Alternative: Upload products in a batch (faster)
Future<void> uploadInitialProductsBatch() async {
  final firestoreService = FirestoreService.instance;

  try {
    debugPrint('🚀 Starting batch upload of products to Firestore...');

    final operations = productItems.map((product) {
      return BatchSetOperation(
        '${ApiPaths.products()}/${product.id}',
        product.toMap(),
      );
    }).toList();

    await firestoreService.batchWrite(operations: operations);

    debugPrint(
      '🎉 All ${productItems.length} products uploaded successfully in batch!',
    );
  } catch (e) {
    debugPrint(' Error in batch upload: $e');
    rethrow;
  }
}

Future<void> debugFirebaseConnection() async {
  debugPrint('🔍 === FIREBASE DEBUG START ===');

  try {
    // 1. Check Firebase Auth
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      debugPrint(' User is logged in: ${user.email}');
    } else {
      debugPrint(' User is NOT logged in (anonymous access)');
    }

    // 2. Check Firestore instance
    final firestore = FirebaseFirestore.instance;
    debugPrint('✅ Firestore instance created');

    // 3. Try to read products collection directly
    debugPrint('🔍 Attempting to read products collection...');

    final snapshot = await firestore.collection('products').get();

    debugPrint('📦 Collection exists: ${snapshot.docs.isNotEmpty}');
    debugPrint('📦 Number of documents: ${snapshot.docs.length}');

    if (snapshot.docs.isEmpty) {
      debugPrint('⚠️ WARNING: Products collection is EMPTY!');
      debugPrint('⚠️ Possible reasons:');
      debugPrint('   1. Collection name is wrong (check Firebase Console)');
      debugPrint('   2. Firebase Rules are blocking access');
      debugPrint('   3. No products have been uploaded yet');

      // Try to list all collections
      debugPrint('🔍 Trying to check if collection exists...');
    } else {
      debugPrint('✅ Products found!');

      // Show first product details
      final firstDoc = snapshot.docs.first;
      debugPrint('📄 First product ID: ${firstDoc.id}');
      debugPrint('📄 First product data: ${firstDoc.data()}');
    }

    debugPrint('🔍 === FIREBASE DEBUG END ===');
  } catch (e, stackTrace) {
    debugPrint('❌ ERROR in Firebase debug:');
    debugPrint('❌ Error: $e');
    debugPrint('❌ StackTrace: $stackTrace');
  }
}

/// Widget to add to your app for easy debugging
class FirebaseDebugButton extends StatelessWidget {
  const FirebaseDebugButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await debugFirebaseConnection();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check Debug Console for results'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      icon: const Icon(Icons.bug_report),
      label: const Text('Debug Firebase'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }
}
