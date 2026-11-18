// sign_out_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository repository;
  const SignOutUseCase(this.repository);

  Future<Either<Failure, Unit>> call() {
    return repository.signOut();
  }
}
