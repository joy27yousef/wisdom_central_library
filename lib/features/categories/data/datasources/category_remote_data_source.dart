import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisdom_central_library/core/services/error/exceptions.dart';

import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firestore;

  const CategoryRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: mapFirebaseExceptionMessage(e));
    } on FirebaseException catch (e) {
      throw ServerException(message: mapFirebaseExceptionMessage(e));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
