// update_user_data_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateUserParams {
  final String name;
  final String phone;
  final String branch;
  final String stage;

  const UpdateUserParams({
    required this.name,
    required this.phone,
    required this.branch,
    required this.stage,
  });
}

class UpdateUserDataUseCase {
  final AuthRepository repository;
  const UpdateUserDataUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(UpdateUserParams params) {
    return repository.updateUserData(
      name: params.name,
      phone: params.phone,
      branch: params.branch,
      stage: params.stage,
    );
  }
}
