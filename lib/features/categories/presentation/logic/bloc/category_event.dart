import 'package:equatable/equatable.dart';
import 'package:wisdom_central_library/features/categories/domain/entities/category_entity.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllCategoriesEvent extends CategoryEvent {
  final bool forceRefresh;

  const LoadAllCategoriesEvent({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class SelectCategoryEvent extends CategoryEvent {
  final CategoryEntity category;

  const SelectCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchCategoriesEvent extends CategoryEvent {
  final String query;

  const SearchCategoriesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearCategoryNavigationEvent extends CategoryEvent {
  const ClearCategoryNavigationEvent();
}
