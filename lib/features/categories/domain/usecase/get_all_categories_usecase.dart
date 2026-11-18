import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetAllCategoriesUseCase {
  final CategoryRepository repository;

  const GetAllCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await repository.getAllCategories();
  }
}
