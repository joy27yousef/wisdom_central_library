import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisdom_central_library/core/services/error/exceptions.dart';
import '../models/favourite_item_model.dart';

abstract class FavouriteRemoteDataSource {
  Future<List<FavouriteItemModel>> getFavourites();
  Future<bool> toggleFavourite({required String bookId});
  Future<void> removeFavourite({required String bookId});
}

class FavouriteRemoteDataSourceImpl implements FavouriteRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const FavouriteRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  CollectionReference _favouritesCollection() {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw const ServerException(
        message: 'يجب تسجيل الدخول أولاً لإدارة المفضلة',
      );
    }
    return firestore.collection('users').doc(user.uid).collection('favourites');
  }

  @override
  Future<List<FavouriteItemModel>> getFavourites() async {
    try {
      final snapshot = await _favouritesCollection()
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) {
            final rawData = doc.data();
            final map = rawData is Map
                ? Map<String, dynamic>.from(rawData)
                : <String, dynamic>{};
            return FavouriteItemModel.fromMap(map, docId: doc.id);
          })
          .where((item) => item.bookId.isNotEmpty)
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

  @override
  Future<bool> toggleFavourite({required String bookId}) async {
    try {
      final docRef = _favouritesCollection().doc(bookId);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        await docRef.delete();
        return false; // تمت الإزالة من المفضلة
      } else {
        final model = FavouriteItemModel(
          bookId: bookId,
          createdAt: DateTime.now(),
        );
        await docRef.set(model.toMap());
        return true; // تمت الإضافة إلى المفضلة
      }
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

  @override
  Future<void> removeFavourite({required String bookId}) async {
    try {
      await _favouritesCollection().doc(bookId).delete();
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
