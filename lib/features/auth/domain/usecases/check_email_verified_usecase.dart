// check_email_verified_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../repositories/auth_repository.dart';

class CheckEmailVerifiedUseCase {
  final AuthRepository repository;
  const CheckEmailVerifiedUseCase(this.repository);

  Future<Either<Failure, bool>> call() {
    return repository.checkEmailVerified();
  }
}
