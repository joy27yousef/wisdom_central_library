import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';
import 'package:wisdom_central_library/features/categories/presentation/logic/bloc/category_bloc.dart';
import 'package:wisdom_central_library/features/categories/presentation/logic/bloc/category_event.dart';
import 'package:wisdom_central_library/features/categories/presentation/logic/bloc/category_state.dart';
import 'package:wisdom_central_library/features/categories/presentation/screens/subcategories_page.dart';

class AllCategoriesPage extends WatchingWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = di<CategoryBloc>();

    final state =
        watchStream(
          (CategoryBloc b) => b.stream,
          initialValue: bloc.state,
        ).data ??
        bloc.state;

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

    final categories = state.rootCategories;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'جميع التصنيفات',
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
      body: categories.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.folder_open,
                    size: 56,
                    color: AppColors.gray.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'لا توجد تصنيفات متاحة حالياً',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

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
