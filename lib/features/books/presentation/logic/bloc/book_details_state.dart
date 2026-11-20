import 'package:equatable/equatable.dart';
import 'package:wisdom_central_library/features/books/domain/entities/book_entity.dart';

enum BookDetailsStatus { initial, loading, loaded, error }

class BookDetailsState extends Equatable {
  final BookDetailsStatus status;
  final BookEntity? book;
  final String? successMessage;
  final String? errorMessage;

  const BookDetailsState({
    this.status = BookDetailsStatus.initial,
    this.book,

    this.successMessage,
    this.errorMessage,
  });

  BookDetailsState copyWith({
    BookDetailsStatus? status,
    BookEntity? book,
    bool? isFavorite,
    bool? isTogglingFavorite,
    String? successMessage,
    bool clearSuccess = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BookDetailsState(
      status: status ?? this.status,
      book: book ?? this.book,

      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    book,

    successMessage,
    errorMessage,
  ];
}
