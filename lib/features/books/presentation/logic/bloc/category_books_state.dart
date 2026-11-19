import 'package:equatable/equatable.dart';
import 'package:wisdom_central_library/features/books/domain/entities/book_entity.dart';

enum CategoryBooksStatus { initial, loading, loaded, error }

class CategoryBooksState extends Equatable {
  final CategoryBooksStatus status;
  final List<BookEntity> books;
  final List<BookEntity> filteredBooks;
  final String? selectedSubCategoryId;
  final bool isGridMode;
  final String? errorMessage;

  const CategoryBooksState({
    this.status = CategoryBooksStatus.initial,
    this.books = const [],
    this.filteredBooks = const [],
    this.selectedSubCategoryId,
    this.isGridMode = true,
    this.errorMessage,
  });

  CategoryBooksState copyWith({
    CategoryBooksStatus? status,
    List<BookEntity>? books,
    List<BookEntity>? filteredBooks,
    String? selectedSubCategoryId,
    bool clearSubCategory = false,
    bool? isGridMode,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CategoryBooksState(
      status: status ?? this.status,
      books: books ?? this.books,
      filteredBooks: filteredBooks ?? this.filteredBooks,
      selectedSubCategoryId: clearSubCategory
          ? null
          : (selectedSubCategoryId ?? this.selectedSubCategoryId),
      isGridMode: isGridMode ?? this.isGridMode,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    books,
    filteredBooks,
    selectedSubCategoryId,
    isGridMode,
    errorMessage,
  ];
}
