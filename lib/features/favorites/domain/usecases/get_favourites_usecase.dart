// lib/features/favourate/domain/usecases/get_favourites_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../entities/favourite_item_entity.dart';
import '../repositories/favourite_repository.dart';

class GetFavouritesUseCase {
  final FavouriteRepository repository;

  const GetFavouritesUseCase(this.repository);

  Future<Either<Failure, List<FavouriteItemEntity>>> call() {
    return repository.getFavourites();
  }
}
