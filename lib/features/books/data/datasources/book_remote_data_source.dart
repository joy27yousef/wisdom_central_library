import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisdom_central_library/core/services/error/exceptions.dart';
import '../models/book_model.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> getBooksByCategory(String categoryId);
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final FirebaseFirestore firestore;

  const BookRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<BookModel>> getBooksByCategory(String categoryId) async {
    try {
      final snapshot = await firestore
          .collection('books')
          .where('categoryId', isEqualTo: categoryId)
          .where('isAvailable', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) => BookModel.fromFirestore(doc)).toList();
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