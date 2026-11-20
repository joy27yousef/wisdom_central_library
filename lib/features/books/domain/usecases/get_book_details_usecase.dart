import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class GetBookDetailsUseCase {
  final BookRepository repository;

  const GetBookDetailsUseCase(this.repository);

  Future<Either<Failure, BookEntity>> call(String bookId) async {
    return await repository.getBookDetails(bookId);
  }
}
