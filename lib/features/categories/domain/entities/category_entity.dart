import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String title;
  final String? parentId;
  final bool hasSubcategories;
  final bool isActive;

  const CategoryEntity({
    required this.id,
    required this.title,
    this.parentId,
    required this.hasSubcategories,
    this.isActive = true,
  });

  bool get isRoot => parentId == null || parentId!.isEmpty;

  @override
  List<Object?> get props => [
    id,
    title,
    parentId,
    hasSubcategories,
    isActive,
  ];
}
