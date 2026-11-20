import 'package:equatable/equatable.dart';
import 'package:wisdom_central_library/features/books/domain/entities/book_entity.dart';

abstract class BookDetailsEvent extends Equatable {
  const BookDetailsEvent();

  @override
  List<Object?> get props => [];
}

class InitBookDetailsEvent extends BookDetailsEvent {
  final BookEntity? initialBook;
  final String? bookId;
  final String userId;

  const InitBookDetailsEvent({
    this.initialBook,
    this.bookId,
    required this.userId,
  });

  @override
  List<Object?> get props => [initialBook, bookId, userId];
}

class DownloadBookEvent extends BookDetailsEvent {
  const DownloadBookEvent();
}
