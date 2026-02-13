import 'package:e_commerce_app/Constants/api_paths.dart';
import 'package:e_commerce_app/models/Payment_cart_model.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:flutter/widgets.dart';

abstract class CheckoutService {
  Future<String> addPaymentMethod(String userId, PaymentCardModel method);
  Future<List<PaymentCardModel>> fetchPaymentMethods(String userId);
  Future<void> removePaymentMethod(String userId, String methodId);
  Future<void> updatePaymentMethod(String userId, PaymentCardModel method);
}

class CheckoutServiceImpl extends CheckoutService {
  final _firestoreService = FirestoreService.instance;

  @override
  Future<String> addPaymentMethod(
    String userId,
    PaymentCardModel method,
  ) async {
    try {
      debugPrint(' Adding payment method for user: $userId');

      final docId = await _firestoreService.addData(
        collectionPath: ApiPaths.addPaymentMethod(userId, method.id),
        data: method.toMap(),
      );

      debugPrint(' Payment method added with ID: $docId');
      return docId;
    } catch (error) {
      debugPrint(' Error adding payment method: $error');
      rethrow;
    }
  }

  @override
  Future<List<PaymentCardModel>> fetchPaymentMethods(String userId) async {
    try {
      debugPrint('Fetching payment methods for user: $userId');

      final data = await _firestoreService.getCollection<PaymentCardModel>(
        path: ApiPaths.fetchPaymentMethod(userId),
        queryBuilder: (data, documentId) {
          debugPrint('Processing payment method: $documentId');
          return PaymentCardModel.fromMap(data, documentId);
        },
      );

      debugPrint('Fetched ${data.length} payment methods');
      return data;
    } catch (error) {
      debugPrint('Error fetching payment methods: $error');
      return [];
    }
  }

  @override
  Future<void> removePaymentMethod(String userId, String methodId) async {
    try {
      debugPrint(' Removing payment method: $methodId');

      await _firestoreService.deleteData(
        path: ApiPaths.removePaymentMethod(userId, methodId),
      );

      debugPrint('Payment method removed successfully');
    } catch (error) {
      debugPrint('Error removing payment method: $error');
      rethrow;
    }
  }

  @override
  Future<void> updatePaymentMethod(
    String userId,
    PaymentCardModel method,
  ) async {
    try {
      debugPrint('Updating payment method: ${method.id}');

      await _firestoreService.setData(
        path: ApiPaths.updatePaymentMethod(userId, method.id),
        data: method.toMap(),
      );

      debugPrint('Payment method updated successfully');
    } catch (error) {
      debugPrint(' Error updating payment method: $error');
      rethrow;
    }
  }
}
