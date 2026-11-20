import 'package:equatable/equatable.dart';
import '../../../domain/entities/favourite_item_entity.dart';

enum FavouriteStatus { initial, loading, loaded, error }

enum FavouriteSideEffectType { none, added, removed, error }

class FavouriteSideEffect extends Equatable {
  final FavouriteSideEffectType type;
  final String message;
  final int id;

  const FavouriteSideEffect({
    this.type = FavouriteSideEffectType.none,
    this.message = '',
    this.id = 0,
  });

  @override
  List<Object?> get props => [type, message, id];
}

class FavouriteState extends Equatable {
  final FavouriteStatus status;
  final List<FavouriteItemEntity> items;
  final Set<String> favouriteBookIds;
  final String? updatingBookId;
  final String? errorMessage;
  final String? successMessage;
  final FavouriteSideEffect sideEffect;

  const FavouriteState({
    this.status = FavouriteStatus.initial,
    this.items = const [],
    this.favouriteBookIds = const {},
    this.updatingBookId,
    this.errorMessage,
    this.successMessage,
    this.sideEffect = const FavouriteSideEffect(),
  });

  bool isFavourite(String bookId) => favouriteBookIds.contains(bookId);

  FavouriteState copyWith({
    FavouriteStatus? status,
    List<FavouriteItemEntity>? items,
    Set<String>? favouriteBookIds,
    String? updatingBookId,
    bool clearUpdatingBookId = false,
    String? errorMessage,
    String? successMessage,
    FavouriteSideEffect? sideEffect,
  }) {
    return FavouriteState(
      status: status ?? this.status,
      items: items ?? this.items,
      favouriteBookIds: favouriteBookIds ?? this.favouriteBookIds,
      updatingBookId: clearUpdatingBookId ? null : (updatingBookId ?? this.updatingBookId),
      // تصفير رسائل الخطأ والنجاح تلقائياً عند تغيير الحالة ما لم تُمرر رسالة جديدة
      errorMessage: errorMessage,
      successMessage: successMessage,
      sideEffect: sideEffect ?? this.sideEffect,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        favouriteBookIds,
        updatingBookId,
        errorMessage,
        successMessage,
        sideEffect,
      ];
}