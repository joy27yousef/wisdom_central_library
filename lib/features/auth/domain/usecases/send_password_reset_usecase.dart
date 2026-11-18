// send_password_reset_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../repositories/auth_repository.dart';

class SendPasswordResetUseCase {
  final AuthRepository repository;
  const SendPasswordResetUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String email) {
    return repository.sendPasswordResetEmail(email);
  }
}
