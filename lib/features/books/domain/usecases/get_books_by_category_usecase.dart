import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class GetBooksByCategoryUseCase {
  final BookRepository repository;

  const GetBooksByCategoryUseCase(this.repository);

  Future<Either<Failure, List<BookEntity>>> call(String categoryId) async {
    return await repository.getBooksByCategory(categoryId);
  }
}
