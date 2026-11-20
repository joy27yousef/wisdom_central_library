import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/book_entity.dart';

class BookModel extends BookEntity {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    super.description,
    super.coverUrl,
    super.pdfUrl,
    required super.categoryId,
    super.subCategoryId,
    super.publishingHouse,
    super.numbersPages,
    super.rating,
    super.isAvailable,
    super.createdAt,
    super.localization,
    super.downloadCount,
    super.favotitesCount,
    super.loan,
    super.publishedAt,
    super.purchase,
  });

  factory BookModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return BookModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      author: data['author'] as String? ?? '',
      description: data['description'] as String?,
      coverUrl: data['coverUrl'] as String?,
      pdfUrl: data['pdfUrl'] as String?,
      categoryId: data['categoryId'] as String? ?? '',
      subCategoryId: data['subCategoryId'] as String?,
      publishingHouse: data['publishingHouse'] as String? ?? 'دار الحكمة',
      numbersPages: (data['numbersPages'] as num?)?.toInt() ?? 0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      isAvailable: data['isAvailable'] as bool? ?? true,
      createdAt: data['createdAt'] as Timestamp?,
      publishedAt: data['publishedAt'] as String? ?? '',
      localization: data['localization'] as String?,
      downloadCount: (data['downloadCount'] as num?)?.toInt(),
      favotitesCount: (data['favotitesCount'] as num?)?.toInt(),
      loan: data['loan'] as bool? ?? false,
      purchase: data['purchase'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'pdfUrl': pdfUrl,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'publishingHouse': publishingHouse,
      'publishedAt': publishedAt,
      'numbersPages': numbersPages,
      'rating': rating,
      'isAvailable': isAvailable,
      'createdAt': createdAt,
      'localization': localization,
      'downloadCount': downloadCount,
      'favotitesCount': favotitesCount,
      'loan': loan,
      'purchase': purchase,
    };
  }
}
