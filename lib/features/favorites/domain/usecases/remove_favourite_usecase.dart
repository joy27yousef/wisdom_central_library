// lib/features/favourate/domain/usecases/remove_favourite_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:wisdom_central_library/core/services/error/failures.dart'
    show Failure;
import '../repositories/favourite_repository.dart';

class RemoveFavouriteUseCase {
  final FavouriteRepository repository;

  const RemoveFavouriteUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required String bookId}) {
    return repository.removeFavourite(bookId: bookId);
  }
}
