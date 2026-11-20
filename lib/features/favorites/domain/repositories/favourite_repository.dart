import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../entities/favourite_item_entity.dart';

abstract class FavouriteRepository {
  Future<Either<Failure, List<FavouriteItemEntity>>> getFavourites();

  Future<Either<Failure, bool>> toggleFavourite({required String bookId});

  Future<Either<Failure, Unit>> removeFavourite({required String bookId});
}
