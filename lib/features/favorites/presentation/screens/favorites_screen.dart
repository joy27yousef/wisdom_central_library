import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/routes/app_routes.dart';
import 'package:wisdom_central_library/core/shared/widgets/message.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';
import 'package:wisdom_central_library/features/auth/presentation/managers/auth_manager.dart';
import 'package:wisdom_central_library/features/books/domain/entities/book_entity.dart';
import 'package:wisdom_central_library/features/books/domain/usecases/get_book_details_usecase.dart';
import 'package:wisdom_central_library/features/books/presentation/logic/bloc/book_details_bloc.dart';
import 'package:wisdom_central_library/features/books/presentation/logic/bloc/book_details_event.dart';
import 'package:wisdom_central_library/features/favorites/domain/entities/favourite_item_entity.dart';
import 'package:wisdom_central_library/features/favorites/presentation/logic/bloc/favourite_bloc.dart';
import 'package:wisdom_central_library/features/favorites/presentation/logic/bloc/favourite_event.dart';
import 'package:wisdom_central_library/features/favorites/presentation/logic/bloc/favourite_state.dart';

final GetIt _getIt = GetIt.instance;

class FavoriteBookDisplayData {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final String publishingHouse;
  final int numbersPages;
  final BookEntity? bookEntity;

  const FavoriteBookDisplayData({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    this.publishingHouse = '',
    this.numbersPages = 0,
    this.bookEntity,
  });

  factory FavoriteBookDisplayData.fromBookEntity(BookEntity book) {
    return FavoriteBookDisplayData(
      id: book.id,
      title: book.title,
      author: book.author,
      coverUrl: book.coverUrl!,
      publishingHouse: book.publishingHouse!,
      numbersPages: book.numbersPages,
      bookEntity: book,
    );
  }
}

class FavoritesScreen extends WatchingWidget {
  final String? userId;

  final FavoriteBookDisplayData Function(FavouriteItemEntity item)?
  bookResolver;

  final void Function(BuildContext context, String bookId)? onBookTap;

  const FavoritesScreen({
    super.key,
    this.userId,
    this.bookResolver,
    this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = _getIt<FavouriteBloc>();

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

    if (state.status == FavouriteStatus.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getIt<FavouriteBloc>().add(const LoadFavouritesEvent());
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'الكتب المفضلة',
          style: AppTextStyles.headlineSmall.copyWith(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () => pop(context),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.gray.withValues(alpha: 0.1)),
              ),
            ),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFF1E293B),
              size: 16,
            ),
          ),
        ),
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, FavouriteState state) {
    if (state.status == FavouriteStatus.loading && state.items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.prim),
      );
    }

    if (state.status == FavouriteStatus.error && state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.errorMessage ?? 'حدث خطأ أثناء تحميل المفضلة',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () =>
                    _getIt<FavouriteBloc>().add(const LoadFavouritesEvent()),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.prim.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.heart_remove,
                size: 60,
                color: AppColors.prim.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد كتب في قائمة المفضلة حالياً',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.prim,
      onRefresh: () async {
        _getIt<FavouriteBloc>().add(const LoadFavouritesEvent());
      },
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final item = state.items[index];
          final bool isRemoving = state.updatingBookId == item.bookId;

          return _FavoriteBookCard(
            key: ValueKey(item.bookId),
            item: item,
            isRemoving: isRemoving,
            customResolver: bookResolver,
            onBookTap: onBookTap,
          );
        },
      ),
    );
  }
}

class _FavoriteBookCard extends StatefulWidget {
  final FavouriteItemEntity item;
  final bool isRemoving;
  final FavoriteBookDisplayData Function(FavouriteItemEntity item)?
  customResolver;
  final void Function(BuildContext context, String bookId)? onBookTap;

  const _FavoriteBookCard({
    super.key,
    required this.item,
    required this.isRemoving,
    this.customResolver,
    this.onBookTap,
  });

  @override
  State<_FavoriteBookCard> createState() => _FavoriteBookCardState();
}

class _FavoriteBookCardState extends State<_FavoriteBookCard> {
  FavoriteBookDisplayData? _resolvedBook;
  bool _isLoadingDetails = false;
  String get _currentUserId =>
      di<AuthManager>().currentUser.value?.uid ??
      di<FirebaseAuth>().currentUser?.uid ??
      'guest';
  @override
  void initState() {
    super.initState();
    _loadBookDetails();
  }

  @override
  void didUpdateWidget(covariant _FavoriteBookCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.bookId != widget.item.bookId) {
      _resolvedBook = null;
      _loadBookDetails();
    }
  }

  Future<void> _loadBookDetails() async {
    // 1. إذا مرّر المستدعي دالة مخصصة من بلوك الكتب، نستخدمها أولاً
    if (widget.customResolver != null) {
      final resolved = widget.customResolver!(widget.item);
      if (mounted) {
        setState(() {
          _resolvedBook = resolved;
        });
      }
      if (resolved.bookEntity != null) return;
    }

    // 2. إذا كان BookDetailsBloc يحمل نفس الكتاب حالياً، نستفيد منه مباشرة
    if (_getIt.isRegistered<BookDetailsBloc>()) {
      final detailsState = _getIt<BookDetailsBloc>().state;
      final dynamic dynState = detailsState;
      try {
        final currentBook = dynState.book;
        if (currentBook is BookEntity && currentBook.id == widget.item.bookId) {
          if (mounted) {
            setState(() {
              _resolvedBook = FavoriteBookDisplayData.fromBookEntity(
                currentBook,
              );
            });
          }
          return;
        }
      } catch (_) {}
    }

    // 3. جلب تفاصيل الكتاب عبر GetBookDetailsUseCase المسجل في GetIt
    if (!_getIt.isRegistered<GetBookDetailsUseCase>()) return;

    setState(() {
      _isLoadingDetails = true;
    });

    final result = await _getIt<GetBookDetailsUseCase>()(widget.item.bookId);
    if (!mounted) return;

    result.fold(
      (_) {
        setState(() {
          _isLoadingDetails = false;
        });
      },
      (bookEntity) {
        setState(() {
          _resolvedBook = FavoriteBookDisplayData.fromBookEntity(bookEntity);
          _isLoadingDetails = false;
        });
      },
    );
  }

  void _handleTap(BuildContext context, FavoriteBookDisplayData book) {
    if (widget.onBookTap != null) {
      widget.onBookTap!(context, book.id);
      return;
    }

    if (_getIt.isRegistered<BookDetailsBloc>()) {
      _getIt<BookDetailsBloc>().add(
        InitBookDetailsEvent(
          bookId: book.id,
          initialBook: book.bookEntity,
          userId: _currentUserId,
        ),
      );
    }

    pushTo(context, AppRoutes.bookDetails, book.bookEntity ?? book.id);
  }

  @override
  Widget build(BuildContext context) {
    final book =
        _resolvedBook ??
        FavoriteBookDisplayData(
          id: widget.item.bookId,
          title: _isLoadingDetails
              ? 'جاري تحميل بيانات الكتاب...'
              : 'كتاب #${widget.item.bookId}',
          author: _isLoadingDetails ? 'يرجى الانتظار' : 'مؤلف غير محدد',
          coverUrl: '',
        );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.04),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: AppColors.gray.withValues(alpha: 0.08)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _handleTap(context, book),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // غلاف الكتاب
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: book.coverUrl.isNotEmpty
                        ? Image.network(
                            book.coverUrl,
                            width: 70,
                            height: 95,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildCoverPlaceholder(),
                          )
                        : _buildCoverPlaceholder(),
                  ),
                ),
                const SizedBox(width: 14),
                // معلومات الكتاب
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.prim.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              book.publishingHouse.isNotEmpty
                                  ? book.publishingHouse
                                  : 'دار النشر',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.prim,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${book.numbersPages} صفحة',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // زر الإزالة من المفضلة
                InkWell(
                  onTap: widget.isRemoving
                      ? null
                      : () => _getIt<FavouriteBloc>().add(
                          RemoveFavouriteEvent(bookId: widget.item.bookId),
                        ),
                  customBorder: const CircleBorder(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: widget.isRemoving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.redAccent,
                            ),
                          )
                        : const Icon(
                            Iconsax.heart5,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoverPlaceholder() {
    return Container(
      width: 70,
      height: 95,
      color: AppColors.prim.withValues(alpha: 0.08),
      child: const Icon(Icons.book_rounded, color: AppColors.prim, size: 30),
    );
  }
}
