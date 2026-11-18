import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, Unit>> sendEmailVerification();

  Future<Either<Failure, bool>> checkEmailVerified();

  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);

  Future<Either<Failure, UserEntity>> updateUserData({
    required String name,
    required String phone,
    required String branch,
    required String stage,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle();
}
