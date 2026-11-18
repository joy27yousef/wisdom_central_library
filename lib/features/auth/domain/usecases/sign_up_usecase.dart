// sign_up_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  final String email;
  final String password;
  final String name;
  const SignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}

class SignUpUseCase {
  final AuthRepository repository;
  const SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(SignUpParams params) {
    return repository.signUpWithEmailAndPassword(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}
