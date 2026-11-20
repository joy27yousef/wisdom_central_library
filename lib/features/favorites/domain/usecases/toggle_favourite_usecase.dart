// lib/features/favourate/domain/usecases/toggle_favourite_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart';
import '../repositories/favourite_repository.dart';

class ToggleFavouriteUseCase {
  final FavouriteRepository repository;

  const ToggleFavouriteUseCase(this.repository);

  Future<Either<Failure, bool>> call({required String bookId}) {
    return repository.toggleFavourite(bookId: bookId);
  }
}
