import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisdom_central_library/features/categories/domain/usecase/get_all_categories_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoriesUseCase getAllCategoriesUseCase;

  CategoryBloc({required this.getAllCategoriesUseCase})
    : super(const CategoryState()) {
    on<LoadAllCategoriesEvent>(_onLoadAllCategories);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<SearchCategoriesEvent>(_onSearchCategories);
    on<ClearCategoryNavigationEvent>(_onClearNavigation);
  }

  Future<void> _onLoadAllCategories(
    LoadAllCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (state.allCategories.isNotEmpty && !event.forceRefresh) {
      return;
    }

    emit(state.copyWith(status: CategoryStatus.loading, clearError: true));

    final result = await getAllCategoriesUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (categories) {
        final roots = categories.where((c) => c.isRoot).toList();
        emit(
          state.copyWith(
            status: CategoryStatus.loaded,
            allCategories: categories,
            rootCategories: roots,
            filteredCategories: roots,
            clearError: true,
          ),
        );
      },
    );
  }

  void _onSelectCategory(
    SelectCategoryEvent event,
    Emitter<CategoryState> emit,
  ) {
    final children = state.allCategories
        .where((c) => c.parentId == event.category.id)
        .toList();

    final hasChildren = event.category.hasSubcategories || children.isNotEmpty;

    if (hasChildren) {
      emit(
        state.copyWith(
          selectedCategory: event.category,
          currentSubcategories: children,
          navigationTarget: CategoryNavigationTarget.subcategories,
          clearError: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          selectedCategory: event.category,
          currentSubcategories: const [],
          navigationTarget: CategoryNavigationTarget.books,
          clearError: true,
        ),
      );
    }
  }

  void _onSearchCategories(
    SearchCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchQuery: '',
          filteredCategories: state.rootCategories,
        ),
      );
      return;
    }

    final matches = state.allCategories
        .where((c) => c.title.toLowerCase().contains(query))
        .toList();

    emit(state.copyWith(searchQuery: event.query, filteredCategories: matches));
  }

  void _onClearNavigation(
    ClearCategoryNavigationEvent event,
    Emitter<CategoryState> emit,
  ) {
    emit(state.copyWith(navigationTarget: CategoryNavigationTarget.none));
  }
}
