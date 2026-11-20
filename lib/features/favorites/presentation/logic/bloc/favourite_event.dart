import 'package:equatable/equatable.dart';

abstract class FavouriteEvent extends Equatable {
  const FavouriteEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavouritesEvent extends FavouriteEvent {
  const LoadFavouritesEvent();
}

class ToggleFavouriteEvent extends FavouriteEvent {
  final String bookId;

  const ToggleFavouriteEvent({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class RemoveFavouriteEvent extends FavouriteEvent {
  final String bookId;

  const RemoveFavouriteEvent({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}