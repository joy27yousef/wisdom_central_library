import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/favourite_item_entity.dart';

class FavouriteItemModel extends FavouriteItemEntity {
  const FavouriteItemModel({required super.bookId, required super.createdAt});

  factory FavouriteItemModel.fromMap(
    Map<String, dynamic> map, {
    String? docId,
  }) {
    final rawDate = map['createdAt'];
    DateTime parsedDate = DateTime.now();
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    }

    return FavouriteItemModel(
      bookId: (map['bookId'] as String?)?.trim().isNotEmpty == true
          ? map['bookId'] as String
          : (docId ?? ''),
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {'bookId': bookId, 'createdAt': Timestamp.fromDate(createdAt)};
  }

  factory FavouriteItemModel.fromEntity(FavouriteItemEntity entity) {
    return FavouriteItemModel(
      bookId: entity.bookId,
      createdAt: entity.createdAt,
    );
  }
}
