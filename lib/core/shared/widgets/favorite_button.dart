// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:wisdom_central_library/core/themes/app_colors.dart';
// import 'package:wisdom_central_library/features/favorites/domain/entities/favorite_entity.dart';
// import 'package:wisdom_central_library/features/favorites/presentation/bloc/favorite_bloc.dart';
// import 'package:wisdom_central_library/features/favorites/presentation/bloc/favorite_event.dart';
// import 'package:wisdom_central_library/features/favorites/presentation/bloc/favorite_state.dart';

// class FavoriteButton extends StatelessWidget {
//   final String bookId;
//   final double size;

//   const FavoriteButton({super.key, required this.bookId, this.size = 20});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FavoriteBloc, FavoriteState>(
//       builder: (context, state) {
//         // التحقق السريع من الـ IDs في الـ State
//         final bool isFavorite = state.favoriteBookIds.contains(bookId);
//         final String currentUserId =
//             FirebaseAuth.instance.currentUser?.uid ?? '';

//         return IconButton(
//           onPressed: () {
//             if (currentUserId.isEmpty) return; // تأكد من تسجيل الدخول

//             final favoriteEntity = FavoriteEntity(
//               id: '',
//               userId: currentUserId,
//               bookId: bookId,
//               createdAt: Timestamp.now(),
//             );

//             // إرسال حدث التبديل (إضافة أو حذف)
//             context.read<FavoriteBloc>().add(
//               ToggleFavoriteEvent(favoriteEntity, isFavorite),
//             );
//           },
//           constraints: const BoxConstraints(),
//           padding: EdgeInsets.zero,
//           icon: Icon(
//             isFavorite ? Icons.favorite_rounded : Iconsax.heart,
//             size: size,
//             color: isFavorite ? Colors.redAccent : AppColors.prim,
//           ),
//         );
//       },
//     );
//   }
// }
