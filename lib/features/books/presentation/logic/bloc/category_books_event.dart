import 'package:equatable/equatable.dart';

abstract class CategoryBooksEvent extends Equatable {
  const CategoryBooksEvent();

  @override
  List<Object?> get props => [];
}

class LoadBooksByCategoryEvent extends CategoryBooksEvent {
  final String categoryId;

  const LoadBooksByCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class FilterBySubCategoryEvent extends CategoryBooksEvent {
  final String? subCategoryId;

  const FilterBySubCategoryEvent(this.subCategoryId);

  @override
  List<Object?> get props => [subCategoryId];
}

class ToggleBookViewModeEvent extends CategoryBooksEvent {
  const ToggleBookViewModeEvent();
}
