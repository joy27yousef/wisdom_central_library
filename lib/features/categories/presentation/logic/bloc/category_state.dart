import 'package:equatable/equatable.dart';
import 'package:wisdom_central_library/features/categories/domain/entities/category_entity.dart';

enum CategoryStatus { initial, loading, loaded, error }

enum CategoryNavigationTarget { none, subcategories, books }

class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<CategoryEntity> allCategories;
  final List<CategoryEntity> rootCategories;
  final List<CategoryEntity> filteredCategories;
  final CategoryEntity? selectedCategory;
  final List<CategoryEntity> currentSubcategories;
  final CategoryNavigationTarget navigationTarget;
  final String searchQuery;
  final String? errorMessage;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.allCategories = const [],
    this.rootCategories = const [],
    this.filteredCategories = const [],
    this.selectedCategory,
    this.currentSubcategories = const [],
    this.navigationTarget = CategoryNavigationTarget.none,
    this.searchQuery = '',
    this.errorMessage,
  });

  List<CategoryEntity> get homePreviewCategories =>
      rootCategories.take(6).toList();

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryEntity>? allCategories,
    List<CategoryEntity>? rootCategories,
    List<CategoryEntity>? filteredCategories,
    CategoryEntity? selectedCategory,
    bool clearSelectedCategory = false,
    List<CategoryEntity>? currentSubcategories,
    CategoryNavigationTarget? navigationTarget,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CategoryState(
      status: status ?? this.status,
      allCategories: allCategories ?? this.allCategories,
      rootCategories: rootCategories ?? this.rootCategories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      selectedCategory: clearSelectedCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      currentSubcategories: currentSubcategories ?? this.currentSubcategories,
      navigationTarget: navigationTarget ?? this.navigationTarget,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    allCategories,
    rootCategories,
    filteredCategories,
    selectedCategory,
    currentSubcategories,
    navigationTarget,
    searchQuery,
    errorMessage,
  ];
}
