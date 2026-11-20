import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../repositories/book_repository.dart';

class IncrementDownloadCountUseCase {
  final BookRepository repository;

  const IncrementDownloadCountUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String bookId) async {
    return await repository.incrementDownloadCount(bookId);
  }
}