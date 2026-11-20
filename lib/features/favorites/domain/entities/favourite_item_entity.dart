import 'package:equatable/equatable.dart';

class FavouriteItemEntity extends Equatable {
  final String bookId;
  final DateTime createdAt;

  const FavouriteItemEntity({
    required this.bookId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [bookId, createdAt];
}