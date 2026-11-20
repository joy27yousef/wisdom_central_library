import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/exceptions.dart'
    show ServerException;
import 'package:wisdom_central_library/core/services/error/failures.dart';

import '../../domain/entities/book_entity.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_remote_data_source.dart';
import '../models/book_model.dart';

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

  @override
  Future<Either<Failure, BookEntity>> getBookDetails(String bookId) async {
    try {
      final book = await remoteDataSource.getBookDetails(bookId);
      return Right(book);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

 

  @override
  Future<Either<Failure, Unit>> incrementDownloadCount(String bookId) async {
    try {
      await remoteDataSource.incrementDownloadCount(bookId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
