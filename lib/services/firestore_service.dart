import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  // Singleton Pattern
  FirestoreService._();
  static final instance = FirestoreService._();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  /// Set data
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      final reference = firestore.doc(path);
      debugPrint('Setting data at $path: $data');
      await reference.set(data);
      debugPrint('Data set successfully');
    } catch (e) {
      debugPrint('Error setting data: $e');
      rethrow;
    }
  }

  /// Update data (special fields only)
  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      final reference = firestore.doc(path);
      debugPrint(' Updating data at $path: $data');
      await reference.update(data);
      debugPrint(' Data updated successfully');
    } catch (e) {
      debugPrint(' Error updating data: $e');
      rethrow;
    }
  }

  /// Add data (document with auto-generated ID)
  Future<String> addData({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    try {
      final reference = firestore.collection(collectionPath);
      debugPrint(' Adding data to $collectionPath: $data');
      final docRef = await reference.add(data);
      debugPrint(' Data added with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint(' Error adding data: $e');
      rethrow;
    }
  }

  // Read data

  /// Get single document
  /// T is a generic type parameter representing the type of the returned object.
  Future<T> getDocument<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentId)
        builder,
  }) async {
    try {
      final reference = firestore.doc(path);
      final snapshot = await reference.get();

      if (snapshot.exists) {
        final data = snapshot.data();
        return builder(data, snapshot.id);
      } else {
        throw Exception('Document at $path does not exist');
      }
    } catch (e) {
      debugPrint(' Error getting document: $e');
      rethrow;
    }
  }

  // Get collection
  Future<List<T>> getCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId)
    queryBuilder,
  }) async {
    try {
      final reference = firestore.collection(path);
      final snapshot = await reference.get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return queryBuilder(data, doc.id);
      }).toList();
    } catch (e) {
      debugPrint(' Error getting collection: $e');
      rethrow;
    }
  }

  /// Stream single document (real-time)
  Stream<Map<String, dynamic>?> streamDocument({required String path}) {
    return firestore.doc(path).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    });
  }

  /// Stream collection (real-time)
  Stream<List<Map<String, dynamic>>> streamCollection({
    required String collectionPath,
    Query Function(Query query)? queryBuilder,
  }) {
    Query query = firestore.collection(collectionPath);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    });
  }

  // DELETE Data
  // Delete document
  Future<void> deleteData({required String path}) async {
    try {
      final reference = firestore.doc(path);
      debugPrint(' Deleting document at $path');
      await reference.delete();
      debugPrint(' Document deleted successfully');
    } catch (e) {
      debugPrint(' Error deleting document: $e');
      rethrow;
    }
  }

  /// Delete collection (batch delete)
  Future<void> deleteCollection({
    required String collectionPath,
    int batchSize = 500,
  }) async {
    try {
      final reference = firestore.collection(collectionPath);
      final snapshot = await reference.limit(batchSize).get();

      if (snapshot.docs.isEmpty) {
        debugPrint(' Collection already empty');
        return;
      }

      final batch = firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      debugPrint('Batch deleted ${snapshot.docs.length} documents');

      // Recursively delete remaining documents
      return deleteCollection(
        collectionPath: collectionPath,
        batchSize: batchSize,
      );
    } catch (e) {
      debugPrint(' Error deleting collection: $e');
      rethrow;
    }
  }

  // Advanced query

  /// Query collection with filters
  Future<List<Map<String, dynamic>>> queryCollection({
    required String collectionPath,
    required Query Function(Query query) queryBuilder,
  }) async {
    try {
      Query query = firestore.collection(collectionPath);
      query = queryBuilder(query);

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    } catch (e) {
      debugPrint(' Error querying collection: $e');
      rethrow;
    }
  }

  // BATCH OPERATIONS

  /// Batch write (multiple operations in one transaction)
  Future<void> batchWrite({required List<BatchOperation> operations}) async {
    try {
      final batch = firestore.batch();

      for (final operation in operations) {
        operation.execute(batch, firestore);
      }

      await batch.commit();
      debugPrint(' Batch write completed: ${operations.length} operations');
    } catch (e) {
      debugPrint(' Error in batch write: $e');
      rethrow;
    }
  }
}

// Batch Operation Classes
abstract class BatchOperation {
  void execute(WriteBatch batch, FirebaseFirestore firestore);
}

class BatchSetOperation extends BatchOperation {
  BatchSetOperation(this.path, this.data);
  final String path;
  final Map<String, dynamic> data;

  @override
  void execute(WriteBatch batch, FirebaseFirestore firestore) {
    batch.set(firestore.doc(path), data);
  }
}

class BatchUpdateOperation extends BatchOperation {
  BatchUpdateOperation(this.path, this.data);
  final String path;
  final Map<String, dynamic> data;

  @override
  void execute(WriteBatch batch, FirebaseFirestore firestore) {
    batch.update(firestore.doc(path), data);
  }
}

class BatchDeleteOperation extends BatchOperation {
  BatchDeleteOperation(this.path);
  final String path;

  @override
  void execute(WriteBatch batch, FirebaseFirestore firestore) {
    batch.delete(firestore.doc(path));
  }
}
