import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart' as doc;
import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.title,
    super.parentId,
    required super.hasSubcategories,
    super.isActive,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CategoryModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      parentId: data['parentId'] as String?,
      hasSubcategories: data['hasSubcategories'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'parentId': parentId,
      'hasSubcategories': hasSubcategories,
      'isActive': isActive,
    };
  }
}
