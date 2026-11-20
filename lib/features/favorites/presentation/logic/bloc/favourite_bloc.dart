import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisdom_central_library/features/favorites/domain/entities/favourite_item_entity.dart';
import 'package:wisdom_central_library/features/favorites/domain/usecases/get_favourites_usecase.dart';
import 'package:wisdom_central_library/features/favorites/domain/usecases/remove_favourite_usecase.dart';
import 'package:wisdom_central_library/features/favorites/domain/usecases/toggle_favourite_usecase.dart';

import 'favourite_event.dart';
import 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final GetFavouritesUseCase getFavouritesUseCase;
  final ToggleFavouriteUseCase toggleFavouriteUseCase;
  final RemoveFavouriteUseCase removeFavouriteUseCase;

  final StreamController<FavouriteSideEffect> _sideEffectController =
      StreamController<FavouriteSideEffect>.broadcast();

  Stream<FavouriteSideEffect> get sideEffects => _sideEffectController.stream;

  int _effectCounter = 0;

  FavouriteBloc({
    required this.getFavouritesUseCase,
    required this.toggleFavouriteUseCase,
    required this.removeFavouriteUseCase,
  }) : super(const FavouriteState()) {
    on<LoadFavouritesEvent>(_onLoadFavourites);
    on<ToggleFavouriteEvent>(_onToggleFavourite);
    on<RemoveFavouriteEvent>(_onRemoveFavourite);
  }

  void _emitSideEffect(FavouriteSideEffectType type, String message) {
    _effectCounter += 1;
    final effect = FavouriteSideEffect(
      type: type,
      message: message,
      id: _effectCounter,
    );
    if (!_sideEffectController.isClosed) {
      _sideEffectController.add(effect);
    }
    emit(state.copyWith(sideEffect: effect));
  }

  Future<void> _onLoadFavourites(
    LoadFavouritesEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FavouriteStatus.loading,
        errorMessage: null,
        successMessage: null,
      ),
    );

    final result = await getFavouritesUseCase();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: FavouriteStatus.error,
            errorMessage: failure.message,
            successMessage: null,
          ),
        );
        _emitSideEffect(FavouriteSideEffectType.error, failure.message);
      },
      (items) {
        final ids = items.map((e) => e.bookId).toSet();
        emit(
          state.copyWith(
            status: FavouriteStatus.loaded,
            items: items,
            favouriteBookIds: ids,
            errorMessage: null,
            successMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _onToggleFavourite(
    ToggleFavouriteEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    emit(
      state.copyWith(
        updatingBookId: event.bookId,
        errorMessage: null,
        successMessage: null,
      ),
    );

    final result = await toggleFavouriteUseCase(bookId: event.bookId);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: FavouriteStatus.error,
            clearUpdatingBookId: true,
            errorMessage: failure.message,
            successMessage: null,
          ),
        );
        _emitSideEffect(FavouriteSideEffectType.error, failure.message);
      },
      (isNowFavourite) {
        final updatedIds = Set<String>.from(state.favouriteBookIds);
        final updatedItems = List<FavouriteItemEntity>.from(state.items);

        if (isNowFavourite) {
          updatedIds.add(event.bookId);
          final alreadyExists = updatedItems.any((e) => e.bookId == event.bookId);
          if (!alreadyExists) {
            updatedItems.insert(
              0,
              FavouriteItemEntity(bookId: event.bookId, createdAt: DateTime.now()),
            );
          }
        } else {
          updatedIds.remove(event.bookId);
          updatedItems.removeWhere((e) => e.bookId == event.bookId);
        }

        const msg = 'تم تحديث قائمة المفضلة بنجاح';
        emit(
          state.copyWith(
            status: FavouriteStatus.loaded,
            items: updatedItems,
            favouriteBookIds: updatedIds,
            clearUpdatingBookId: true,
            errorMessage: null,
            successMessage: msg,
          ),
        );
        _emitSideEffect(
          isNowFavourite
              ? FavouriteSideEffectType.added
              : FavouriteSideEffectType.removed,
          isNowFavourite ? 'تمت إضافة الكتاب إلى المفضلة' : 'تمت إزالة الكتاب من المفضلة',
        );
      },
    );
  }

  Future<void> _onRemoveFavourite(
    RemoveFavouriteEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    emit(
      state.copyWith(
        updatingBookId: event.bookId,
        errorMessage: null,
        successMessage: null,
      ),
    );

    final result = await removeFavouriteUseCase(bookId: event.bookId);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: FavouriteStatus.error,
            clearUpdatingBookId: true,
            errorMessage: failure.message,
            successMessage: null,
          ),
        );
        _emitSideEffect(FavouriteSideEffectType.error, failure.message);
      },
      (_) {
        final updatedIds = Set<String>.from(state.favouriteBookIds)
          ..remove(event.bookId);
        final updatedItems = state.items
            .where((item) => item.bookId != event.bookId)
            .toList();

        const msg = 'تم حذف الكتاب من المفضلة';
        emit(
          state.copyWith(
            status: FavouriteStatus.loaded,
            items: updatedItems,
            favouriteBookIds: updatedIds,
            clearUpdatingBookId: true,
            errorMessage: null,
            successMessage: msg,
          ),
        );
        _emitSideEffect(FavouriteSideEffectType.removed, msg);
      },
    );
  }

  @override
  Future<void> close() async {
    await _sideEffectController.close();
    return super.close();
  }
}