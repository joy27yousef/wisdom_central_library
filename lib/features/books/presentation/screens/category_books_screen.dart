import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/routes/app_routes.dart';
import 'package:wisdom_central_library/core/shared/widgets/app_cached_image.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';
import 'package:wisdom_central_library/features/books/domain/entities/book_entity.dart';
import 'package:wisdom_central_library/features/books/presentation/logic/bloc/category_books_bloc.dart';
import 'package:wisdom_central_library/features/books/presentation/logic/bloc/category_books_event.dart';
import 'package:wisdom_central_library/features/books/presentation/logic/bloc/category_books_state.dart';
import 'package:wisdom_central_library/features/categories/presentation/logic/bloc/category_bloc.dart';
import 'package:wisdom_central_library/features/favorites/presentation/screens/widgets/favorite_button.dart';

class CategoryBooksScreen extends WatchingWidget {
  final String categoryName;
  final String categoryId;

  const CategoryBooksScreen({
    super.key,
    this.categoryName = 'التصنيف',
    this.categoryId = 'cat_1',
  });

  @override
  Widget build(BuildContext context) {
    final bloc = createOnce(
      () => di<CategoryBooksBloc>(),
      dispose: (b) => b.close(),
    );

    final subCategories = di<CategoryBloc>().state.allCategories
        .where((c) => c.parentId == categoryId)
        .toList();

    callOnce((_) {
      bloc.add(LoadBooksByCategoryEvent(categoryId));
    });

    final state =
        watchStream(
          (CategoryBooksBloc b) => b.stream,
          target: bloc,
          initialValue: bloc.state,
        ).data ??
        bloc.state;

    registerStreamHandler(
      target: bloc,
      select: (CategoryBooksBloc b) => b.stream,
      handler: (context, snapshot, cancel) {
        final currentState = snapshot.data;
        if (currentState == null) return;

        if (currentState.status == CategoryBooksStatus.error &&
            currentState.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(currentState.errorMessage!)));
        }
      },
    );

    final books = state.filteredBooks;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: const Color(0xFFF8F9FA),
            centerTitle: true,
            title: Text(
              categoryName,
              style: AppTextStyles.headlineSmall.copyWith(
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () => pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: AppColors.gray.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Color(0xFF1E293B),
                  size: 16,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: AppColors.gray.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  icon: Icon(
                    state.isGridMode
                        ? Icons.view_list_rounded
                        : Icons.grid_view_rounded,
                    color: AppColors.prim,
                    size: 20,
                  ),
                  onPressed: () {
                    bloc.add(const ToggleBookViewModeEvent());
                  },
                ),
              ),
            ],
          ),

          if (subCategories.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: subCategories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final isAllSelected = state.selectedSubCategoryId == null;
                      return _buildSubCategoryChip(
                        title: 'الكل',
                        isSelected: isAllSelected,
                        onTap: () {
                          bloc.add(const FilterBySubCategoryEvent(null));
                        },
                      );
                    }

                    final subCategory = subCategories[index - 1];
                    final isSelected =
                        state.selectedSubCategoryId == subCategory.id;

                    return _buildSubCategoryChip(
                      title: subCategory.title,
                      isSelected: isSelected,
                      onTap: () {
                        bloc.add(FilterBySubCategoryEvent(subCategory.id));
                      },
                    );
                  },
                ),
              ),
            ),

          if (state.status == CategoryBooksStatus.loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (books.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد كتب متاحة في هذا التصنيف حالياً',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: state.isGridMode
                  ? SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.60,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _buildBookGridItem(books[index], () {
                              pushTo(
                                context,
                                AppRoutes.bookDetails,
                                books[index],
                              );
                            }),
                        childCount: books.length,
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _buildBookListItem(books[index], () {
                              pushTo(
                                context,
                                AppRoutes.bookDetails,
                                books[index],
                              );
                            }),
                        childCount: books.length,
                      ),
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubCategoryChip({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppColors.prim : AppColors.white,
          border: Border.all(
            color: isSelected
                ? AppColors.prim
                : AppColors.gray.withValues(alpha: 0.15),
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: const Color(0xFF1E293B).withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : const Color(0xFF2D3436),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildBookGridItem(BookEntity book, void Function()? ontap) {
    final cover = book.coverUrl ?? '';
    return Container(
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
          onTap: ontap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: cover.isNotEmpty
                          ? AppCachedImage(
                              imageUrl: book.coverUrl,
                              width: double.infinity,
                              height: double.infinity,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              fallbackIcon: Icons.book_rounded,
                              fallbackIconSize: 40,
                            )
                          : _buildPlaceholderIcon(),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: FavoriteButton(bookId: book.id),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gray.withValues(alpha: 0.8),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${book.numbersPages} صفحة',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: AppColors.prim,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookListItem(BookEntity book, void Function()? ontap) {
    final cover = book.coverUrl ?? '';
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
          onTap: ontap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: cover.isNotEmpty
                      ? AppCachedImage(
                          imageUrl: book.coverUrl,
                          width: 70,
                          height: 95,
                          borderRadius: BorderRadius.circular(14),
                          fallbackIcon: Icons.book_rounded,
                          fallbackIconSize: 30,
                        )
                      : Container(
                          width: 70,
                          height: 95,
                          color: AppColors.prim.withValues(alpha: 0.08),
                          child: const Icon(
                            Icons.book_rounded,
                            color: AppColors.prim,
                            size: 30,
                          ),
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            book.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          FavoriteButton(bookId: book.id),
                        ],
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
                              book.publishingHouse ?? 'دار النشر',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      color: AppColors.prim.withValues(alpha: 0.08),
      child: const Center(
        child: Icon(Icons.book_rounded, size: 40, color: AppColors.prim),
      ),
    );
  }
}
