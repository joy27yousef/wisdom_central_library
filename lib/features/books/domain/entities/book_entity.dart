import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String id;
  final String author;
  final String title;
  final String categoryId;
  final String? subCategoryId;
  final String? coverUrl;
  final Timestamp? createdAt;
  final String? description;
  final String? localization;
  final int? downloadCount;
  final int? favotitesCount;
  final bool? loan;
  final int numbersPages;
  final String? pdfUrl;
  final String? publishingHouse;
  final bool? purchase;
  final double rating;
  final bool isAvailable;

  const BookEntity({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    this.coverUrl,
    this.pdfUrl,
    required this.categoryId,
    this.subCategoryId,
    this.publishingHouse,
    this.numbersPages = 0,
    this.rating = 0.0,
    this.isAvailable = false,
    this.createdAt,
    this.localization,
    this.downloadCount,
    this.favotitesCount,
    this.loan = false,
    this.purchase,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    description,
    coverUrl,
    pdfUrl,
    categoryId,
    subCategoryId,
    publishingHouse,
    numbersPages,
    rating,
    isAvailable,
    createdAt,
    localization,
    downloadCount,
    favotitesCount,
    loan,
    purchase,
  ];
}
