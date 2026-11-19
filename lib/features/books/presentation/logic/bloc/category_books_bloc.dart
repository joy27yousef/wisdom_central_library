import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisdom_central_library/features/books/domain/usecases/get_books_by_category_usecase.dart';
import 'category_books_event.dart';
import 'category_books_state.dart';

class CategoryBooksBloc extends Bloc<CategoryBooksEvent, CategoryBooksState> {
  final GetBooksByCategoryUseCase getBooksByCategoryUseCase;

  CategoryBooksBloc({required this.getBooksByCategoryUseCase})
    : super(const CategoryBooksState()) {
    on<LoadBooksByCategoryEvent>(_onLoadBooksByCategory);
    on<FilterBySubCategoryEvent>(_onFilterBySubCategory);
    on<ToggleBookViewModeEvent>(_onToggleViewMode);
  }

  Future<void> _onLoadBooksByCategory(
    LoadBooksByCategoryEvent event,
    Emitter<CategoryBooksState> emit,
  ) async {
    emit(state.copyWith(status: CategoryBooksStatus.loading, clearError: true));

    final result = await getBooksByCategoryUseCase(event.categoryId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryBooksStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (books) => emit(
        state.copyWith(
          status: CategoryBooksStatus.loaded,
          books: books,
          filteredBooks: books,
          clearSubCategory: true,
          clearError: true,
        ),
      ),
    );
  }

  void _onFilterBySubCategory(
    FilterBySubCategoryEvent event,
    Emitter<CategoryBooksState> emit,
  ) {
    if (event.subCategoryId == null) {
      emit(state.copyWith(clearSubCategory: true, filteredBooks: state.books));
      return;
    }

    final filtered = state.books
        .where((book) => book.subCategoryId == event.subCategoryId)
        .toList();

    emit(
      state.copyWith(
        selectedSubCategoryId: event.subCategoryId,
        filteredBooks: filtered,
      ),
    );
  }

  void _onToggleViewMode(
    ToggleBookViewModeEvent event,
    Emitter<CategoryBooksState> emit,
  ) {
    emit(state.copyWith(isGridMode: !state.isGridMode));
  }
}
