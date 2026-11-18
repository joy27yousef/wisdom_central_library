import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';
import 'package:wisdom_central_library/features/categories/domain/entities/category_entity.dart';
import 'package:wisdom_central_library/features/categories/presentation/logic/bloc/category_bloc.dart';
import 'package:wisdom_central_library/features/categories/presentation/logic/bloc/category_event.dart';
import 'package:wisdom_central_library/features/categories/presentation/logic/bloc/category_state.dart';

class SubcategoriesPage extends WatchingWidget {
  final CategoryEntity parentCategory;
  final List<CategoryEntity> subcategories;

  const SubcategoriesPage({
    super.key,
    required this.parentCategory,
    required this.subcategories,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = di<CategoryBloc>();

    registerStreamHandler(
      select: (CategoryBloc b) => b.stream,
      handler: (context, snapshot, cancel) {
        final currentState = snapshot.data;
        if (currentState == null) return;

        if (ModalRoute.of(context)?.isCurrent != true) return;

        if (currentState.navigationTarget ==
                CategoryNavigationTarget.subcategories &&
            currentState.selectedCategory != null) {
          bloc.add(const ClearCategoryNavigationEvent());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubcategoriesPage(
                parentCategory: currentState.selectedCategory!,
                subcategories: currentState.currentSubcategories,
              ),
            ),
          );
        } else if (currentState.navigationTarget ==
                CategoryNavigationTarget.books &&
            currentState.selectedCategory != null) {
          final selected = currentState.selectedCategory!;
          bloc.add(const ClearCategoryNavigationEvent());
          pushTo(context, '/categoryBooks/${selected.id}', selected.title);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          parentCategory.title,
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
        leading: IconButton(
          onPressed: () => pop(context),
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.gray.withValues(alpha: 0.1)),
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFF1E293B),
              size: 16,
            ),
          ),
        ),
      ),
      body: subcategories.isEmpty
          ? Center(
              child: Text(
                'لا توجد تصنيفات فرعية',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.25,
                ),
                itemCount: subcategories.length,
                itemBuilder: (context, index) {
                  final category = subcategories[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF1E293B,
                          ).withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.gray.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: () => bloc.add(SelectCategoryEvent(category)),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.prim.withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  category.hasSubcategories
                                      ? Iconsax.folder_2
                                      : Iconsax.book_1,
                                  size: 24,
                                  color: AppColors.prim,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                category.title,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: const Color(0xFF2D3436),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
