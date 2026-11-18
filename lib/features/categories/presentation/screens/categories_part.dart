import 'dart:math';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/shared/widgets/build_section_header.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';
import 'package:wisdom_central_library/features/categories/presentation/logic/bloc/category_bloc.dart';
import 'package:wisdom_central_library/features/categories/presentation/logic/bloc/category_event.dart';
import 'package:wisdom_central_library/features/categories/presentation/logic/bloc/category_state.dart';
import 'package:wisdom_central_library/features/categories/presentation/screens/all_categories_page.dart';
import 'package:wisdom_central_library/features/categories/presentation/screens/subcategories_page.dart';

class CategoriesPart extends WatchingWidget {
  const CategoriesPart({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = di<CategoryBloc>();

    callOnce((_) {
      bloc.add(const LoadAllCategoriesEvent());
    });

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

        if (currentState.status == CategoryStatus.error &&
            currentState.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(currentState.errorMessage!)));
        }

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

    final mainCategories = state.rootCategories;
    final displayCount = min(5, mainCategories.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader(
          title: 'التصنيفات',
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AllCategoriesPage(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 38,
          child:
              state.status == CategoryStatus.loading && mainCategories.isEmpty
              ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
              : mainCategories.isEmpty
              ? const Center(child: Text('لا توجد تصنيفات حالياً'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: displayCount,
                  itemBuilder: (context, index) {
                    final category = mainCategories[index];

                    return GestureDetector(
                      onTap: () => bloc.add(SelectCategoryEvent(category)),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: AppConsts.raduisMain,
                          color: AppColors.prim.withValues(alpha: 0.08),
                        ),
                        child: Text(
                          category.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.prim,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
