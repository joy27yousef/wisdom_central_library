import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisdom_central_library/features/books/domain/usecases/get_book_details_usecase.dart';
import 'package:wisdom_central_library/features/books/domain/usecases/increment_download_count_usecase.dart';
import 'book_details_event.dart';
import 'book_details_state.dart';

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  final GetBookDetailsUseCase getBookDetailsUseCase;
  final IncrementDownloadCountUseCase incrementDownloadCountUseCase;

  BookDetailsBloc({
    required this.getBookDetailsUseCase,
    required this.incrementDownloadCountUseCase,
  }) : super(const BookDetailsState()) {
    on<InitBookDetailsEvent>(_onInitBookDetails);
    on<DownloadBookEvent>(_onDownloadBook);
  }

  Future<void> _onInitBookDetails(
    InitBookDetailsEvent event,
    Emitter<BookDetailsState> emit,
  ) async {
    final targetId = event.initialBook?.id ?? event.bookId;
    if (targetId == null || targetId.isEmpty) {
      emit(
        state.copyWith(
          status: BookDetailsStatus.error,
          errorMessage: 'معرّف الكتاب غير صالح',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: event.initialBook != null
            ? BookDetailsStatus.loaded
            : BookDetailsStatus.loading,
        book: event.initialBook,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final detailsFuture = getBookDetailsUseCase(targetId);
    final detailsResult = await detailsFuture;

    detailsResult.fold(
      (failure) {
        if (state.book == null) {
          emit(
            state.copyWith(
              status: BookDetailsStatus.error,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (freshBook) => emit(
        state.copyWith(
          status: BookDetailsStatus.loaded,
          book: freshBook,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onDownloadBook(
    DownloadBookEvent event,
    Emitter<BookDetailsState> emit,
  ) async {
    final currentBook = state.book;
    if (currentBook == null) return;

    final result = await incrementDownloadCountUseCase(currentBook.id);

    result.fold(
      (failure) => emit(
        state.copyWith(errorMessage: failure.message, clearSuccess: true),
      ),
      (_) => emit(
        state.copyWith(
          successMessage: 'جاري تجهيز ملف الكتاب...',
          clearError: true,
        ),
      ),
    );
  }
}
