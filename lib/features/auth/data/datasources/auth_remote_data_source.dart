import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wisdom_central_library/core/const/app_endpoints.dart';
import 'package:wisdom_central_library/core/services/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<void> signOut();
  Future<UserModel> signInWithGoogle();

  Future<UserModel?> getCurrentUser();

  Future<bool> checkEmailVerified();

  Future<void> sendEmailVerification();

  Future<void> sendPasswordResetEmail(String email);

  Future<UserModel> updateUserData({
    required String name,
    required String phone,
    required String branch,
    required String stage,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  const AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const ServerException(message: 'تعذر العثور على بيانات الجلسة.');
      }

      final userDoc = await firestore
          .collection(AppEndpoints.users)
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        throw const ServerException(
          message: 'بيانات المستخدم غير موجودة في قاعدة البيانات.',
        );
      }

      return UserModel.fromMap(
        userDoc.data()!,
        firebaseUser.uid,
        isEmailVerified: firebaseUser.emailVerified,
      );
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
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const ServerException(message: 'فشل إنشاء حساب المستخدم.');
      }

      await firebaseUser.updateDisplayName(name.trim());

      final userModel = UserModel(
        uid: firebaseUser.uid,
        email: email.trim(),
        name: name.trim(),
        role: 'user',
        phone: '',
        stage: '',
        branch: '',
        isEmailVerified: firebaseUser.emailVerified,
        createdAt: DateTime.now(),
      );

      await firestore
          .collection(AppEndpoints.users)
          .doc(firebaseUser.uid)
          .set(userModel.toMap());

      return userModel;
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
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
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
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser =
          firebaseAuth.currentUser ??
          await firebaseAuth.authStateChanges().first;
      if (currentUser == null) return null;

      await currentUser.reload();
      final refreshedUser = firebaseAuth.currentUser;
      if (refreshedUser == null) return null;

      final userDoc = await firestore
          .collection(AppEndpoints.users)
          .doc(refreshedUser.uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) return null;

      return UserModel.fromMap(
        userDoc.data()!,
        refreshedUser.uid,
        isEmailVerified: refreshedUser.emailVerified,
      );
    } on FirebaseException catch (e) {
      throw ServerException(message: mapFirebaseExceptionMessage(e));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'لا يوجد مستخدم مسجل الدخول حالياً.',
        );
      }
      if (!user.emailVerified) {
        await user.sendEmailVerification();
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
  Future<bool> checkEmailVerified() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return false;
      await user.reload();
      return firebaseAuth.currentUser?.emailVerified ?? false;
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
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email.trim());
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
  Future<UserModel> updateUserData({
    required String name,
    required String phone,
    required String branch,
    required String stage,
  }) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const ServerException(
          message: 'لا يوجد مستخدم مسجل الدخول حالياً.',
        );
      }

      final docRef = firestore
          .collection(AppEndpoints.users)
          .doc(currentUser.uid);

      await docRef.update({
        'name': name.trim(),
        'phone': phone.trim(),
        'branch': branch.trim(),
        'stage': stage.trim(),
      });

      final updatedDoc = await docRef.get();
      if (!updatedDoc.exists || updatedDoc.data() == null) {
        throw const ServerException(message: 'تعذر جلب البيانات بعد التحديث.');
      }

      return UserModel.fromMap(
        updatedDoc.data()!,
        currentUser.uid,
        isEmailVerified: currentUser.emailVerified,
      );
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
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const ServerException(
          message: 'تم إلغاء تسجيل الدخول عبر Google.',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await firebaseAuth
          .signInWithCredential(credential);

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const ServerException(
          message: 'تعذر إتمام تسجيل الدخول عبر Google.',
        );
      }

      final docRef = firestore
          .collection(AppEndpoints.users)
          .doc(firebaseUser.uid);
      final userDoc = await docRef.get();

      if (userDoc.exists && userDoc.data() != null) {
        return UserModel.fromMap(
          userDoc.data()!,
          firebaseUser.uid,
          isEmailVerified: true,
        );
      }

      final newUser = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? googleUser.email,
        name: firebaseUser.displayName ?? googleUser.displayName ?? '',
        role: 'user',
        phone: firebaseUser.phoneNumber ?? '',
        stage: '',
        branch: '',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );

      await docRef.set(newUser.toMap());
      return newUser;
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: mapFirebaseExceptionMessage(e));
    } on FirebaseException catch (e) {
      throw ServerException(message: mapFirebaseExceptionMessage(e));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'فشل تسجيل الدخول عبر Google: ${e.toString()}',
      );
    }
  }
}
