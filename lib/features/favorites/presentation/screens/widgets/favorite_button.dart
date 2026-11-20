import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/shared/widgets/message.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/features/favorites/presentation/logic/bloc/favourite_bloc.dart';
import 'package:wisdom_central_library/features/favorites/presentation/logic/bloc/favourite_event.dart';
import 'package:wisdom_central_library/features/favorites/presentation/logic/bloc/favourite_state.dart';

class FavoriteButton extends WatchingWidget {
  final String bookId;
  final double size;
  final bool showSnackBar;

  const FavoriteButton({
    super.key,
    required this.bookId,
    this.size = 20,
    this.showSnackBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = di<FavouriteBloc>();
    registerStreamHandler<FavouriteBloc, FavouriteSideEffect>(
      target: bloc,
      select: (b) => b.sideEffects,
      handler: (context, snapshot, cancel) {
        final effect = snapshot.data;
        if (effect == null || effect.type == FavouriteSideEffectType.none) {
          return;
        }

        if (effect.type == FavouriteSideEffectType.error) {
          final msg = effect.message.trim();
          showMessage(context, message: msg.isEmpty ? 'حصل خطأ ما' : msg);
          return;
        }

        if (effect.type == FavouriteSideEffectType.added) {
          showMessage(
            context,
            message: effect.message.isNotEmpty
                ? effect.message
                : 'تمت الإضافة إلى المفضلة',
          );
          return;
        }

        if (effect.type == FavouriteSideEffectType.removed) {
          showMessage(
            context,
            message: effect.message.isNotEmpty
                ? effect.message
                : 'تمت الإزالة من المفضلة',
          );
          return;
        }
      },
    );

    final state = watchStream(
      (FavouriteBloc b) => b.stream,
      initialValue: bloc.state,
    ).data!;

    final bool isFavorite = state.isFavourite(bookId);
    final bool isUpdating = state.updatingBookId == bookId;

    return IconButton(
      onPressed: isUpdating
          ? null
          : () => di<FavouriteBloc>().add(ToggleFavouriteEvent(bookId: bookId)),
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
      tooltip: isFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
      icon: isUpdating
          ? SizedBox(
              width: size * 0.85,
              height: size * 0.85,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.redAccent,
              ),
            )
          : Icon(
              isFavorite ? Icons.favorite_rounded : Iconsax.heart,
              size: size,
              color: isFavorite ? Colors.redAccent : AppColors.prim,
            ),
    );
  }
}
