import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/exceptions.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../../domain/entities/favourite_item_entity.dart';
import '../../domain/repositories/favourite_repository.dart';
import '../datasources/favourite_remote_data_source.dart';

class FavouriteRepositoryImpl implements FavouriteRepository {
  final FavouriteRemoteDataSource remoteDataSource;

  const FavouriteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FavouriteItemEntity>>> getFavourites() async {
    try {
      final result = await remoteDataSource.getFavourites();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavourite({
    required String bookId,
  }) async {
    try {
      final isNowFavourite = await remoteDataSource.toggleFavourite(
        bookId: bookId,
      );
      return Right(isNowFavourite);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavourite({
    required String bookId,
  }) async {
    try {
      await remoteDataSource.removeFavourite(bookId: bookId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
