import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
}
