// send_email_verification_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../repositories/auth_repository.dart';

class SendEmailVerificationUseCase {
  final AuthRepository repository;
  const SendEmailVerificationUseCase(this.repository);

  Future<Either<Failure, Unit>> call() {
    return repository.sendEmailVerification();
  }
}
