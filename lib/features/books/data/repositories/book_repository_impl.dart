import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/exceptions.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_remote_data_source.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;

  const BookRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BookEntity>>> getBooksByCategory(
    String categoryId,
  ) async {
    try {
      final books = await remoteDataSource.getBooksByCategory(categoryId);
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
