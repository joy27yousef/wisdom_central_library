import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/shared/widgets/app_cached_image.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';
import 'package:wisdom_central_library/features/auth/presentation/managers/auth_manager.dart';
import 'package:wisdom_central_library/features/books/domain/entities/book_entity.dart';
import 'package:wisdom_central_library/features/books/presentation/logic/bloc/book_details_bloc.dart';
import 'package:wisdom_central_library/features/books/presentation/logic/bloc/book_details_event.dart';
import 'package:wisdom_central_library/features/books/presentation/logic/bloc/book_details_state.dart';
import 'package:wisdom_central_library/features/favorites/presentation/screens/widgets/favorite_button.dart';

class BookDetailsScreen extends WatchingWidget {
  final BookEntity? initialBook;
  final String? bookId;

  final void Function(BuildContext context, BookEntity book)? onReadInApp;
  final Future<void> Function(
    BuildContext context,
    BookEntity book, {
    required bool saveOfflineInApp,
  })?
  onDownloadOffline;
  final Future<void> Function(
    BuildContext context,
    BookEntity book, {
    required double rating,
    required String notes,
  })?
  onSubmitReview;

  const BookDetailsScreen({
    super.key,
    this.initialBook,
    this.bookId,
    this.onReadInApp,
    this.onDownloadOffline,
    this.onSubmitReview,
  });

  String get _currentUserId =>
      di<AuthManager>().currentUser.value?.uid ??
      di<FirebaseAuth>().currentUser?.uid ??
      'guest';

  @override
  Widget build(BuildContext context) {
    final bloc = createOnce(
      () => di<BookDetailsBloc>(),
      dispose: (b) => b.close(),
    );

    callOnce((_) {
      bloc.add(
        InitBookDetailsEvent(
          initialBook: initialBook,
          bookId: bookId,
          userId: _currentUserId,
        ),
      );
    });

    final state =
        watchStream(
          (BookDetailsBloc b) => b.stream,
          target: bloc,
          initialValue: bloc.state,
        ).data ??
        bloc.state;

    registerStreamHandler(
      target: bloc,
      select: (BookDetailsBloc b) => b.stream,
      handler: (context, snapshot, cancel) {
        final currentState = snapshot.data;
        if (currentState == null) return;

        if (currentState.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(currentState.errorMessage!)));
        } else if (currentState.successMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(currentState.successMessage!)),
            );
        }
      },
    );

    final book = state.book;

    return Scaffold(
      appBar: _buildAppBar(context, book),
      bottomNavigationBar: book != null
          ? _buildBottomActions(context, bloc, book)
          : null,
      body: state.status == BookDetailsStatus.loading && book == null
          ? _buildLoadingSkeleton()
          : book == null
          ? const Center(child: Text('تعذر تحميل بيانات الكتاب'))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeroHeader(book),
                  const SizedBox(height: 20),
                  _buildDescriptionSection(book),
                  const SizedBox(height: 25),
                  _buildMetadataCard(book),
                  const SizedBox(height: 25),
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, BookEntity? book) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(
        book!.title,
        style: AppTextStyles.headlineSmall.copyWith(
          color: const Color(0xFF1E293B),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          onPressed: () => pop(context),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: AppColors.gray.withValues(alpha: 0.12)),
            ),
          ),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF1E293B),
            size: 16,
          ),
        ),
      ),
      actions: [
        if (book != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FavoriteButton(
                bookId: book.id,
                size: 21,
                showSnackBar: true,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeroHeader(BookEntity book) {
    final categoryText = _extractCategory(book);

    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E293B).withValues(alpha: 0.12),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: AppCachedImage(
                  imageUrl: book.coverUrl,
                  width: 115,
                  height: 172,
                  borderRadius: BorderRadius.circular(16),
                  fallbackIconSize: 44,
                ),
              ),
              if (categoryText.isNotEmpty)
                Positioned(
                  bottom: -9,
                  left: 6,
                  right: 6,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.prim,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.prim.withValues(alpha: 0.28),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        categoryText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.5,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                    fontSize: 16.5,
                    height: 1.3,
                  ),
                ),

                Row(
                  children: [
                    Icon(
                      Iconsax.user_edit,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                // _buildRatingStarsRow(book.rating),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        label: 'التحميلات',
                        value: '${book.downloadCount ?? 0}',
                        icon: Iconsax.document_download,
                        iconColor: AppColors.prim,
                      ),
                    ),
                    _buildVerticalDivider(),
                    Expanded(
                      child: _buildStatItem(
                        label: 'عدد الصفحات',
                        value: '${book.numbersPages}',
                        icon: Iconsax.book_1,
                        iconColor: const Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStarsRow(double rating) {
    final clampedRating = rating.clamp(0.0, 5.0);
    final fullStars = clampedRating.floor();
    final hasHalfStar = (clampedRating - fullStars) >= 0.5;

    return Row(
      children: [
        ...List.generate(5, (index) {
          IconData starIcon;
          if (index < fullStars) {
            starIcon = Icons.star_rounded;
          } else if (index == fullStars && hasHalfStar) {
            starIcon = Icons.star_half_rounded;
          } else {
            starIcon = Icons.star_outline_rounded;
          }

          return Icon(starIcon, size: 18, color: const Color(0xFFF59E0B));
        }),
        const SizedBox(width: 10),
        Text(
          clampedRating.toStringAsFixed(1),
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.gray.withValues(alpha: 0.14),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      children: [
        SizedBox(height: 15),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.grey.shade600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataCard(BookEntity book) {
    final publisherText = _formatPublisherAndYear(book);
    final translationText = book.localization;
    final bool isLoanAvailable = book.loan ?? false;
    final bool isAvailableForSale = _extractForSale(book);
    final String? location = book.localization;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات عن الكتاب : ',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 15),
          _buildInfoRow(
            icon: Iconsax.buildings,
            label: 'دار النشر وسنة النشر',
            value: publisherText,
          ),
          if (location != null && location.trim().isNotEmpty) ...[
            _buildRowSeparator(),
            _buildInfoRow(
              icon: Iconsax.translate,
              label: 'الترجمة',
              value: translationText!,
            ),
          ],
          SizedBox(height: 25),
          Text(
            'الحصول على الكتاب ',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 15),

          _buildStatusRow(
            icon: Iconsax.book_saved,
            label: 'الإعارة',
            isPositive: isLoanAvailable,
            positiveText: 'متاح للإعارة',
            negativeText: 'غير متاح للإعارة',
          ),
          _buildRowSeparator(),
          _buildStatusRow(
            icon: Iconsax.shop,
            label: 'البيع في المكتبة المركزية',
            isPositive: isAvailableForSale,
            positiveText: 'موجود للبيع',
            negativeText: 'غير متوفر للبيع',
          ),
        ],
      ),
    );
  }

  Widget _buildRowSeparator() {
    return Divider(
      height: 20,
      thickness: 0.8,
      color: AppColors.gray.withValues(alpha: 0.1),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.prim),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          textAlign: TextAlign.end,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow({
    required IconData icon,
    required String label,
    required bool isPositive,
    required String positiveText,
    required String negativeText,
  }) {
    final badgeColor = isPositive
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);
    final text = isPositive ? positiveText : negativeText;

    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.prim),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: 11.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BookEntity book) {
    final hasDescription =
        book.description != null && book.description!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'نبذة عن الكتاب',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: Text(
            hasDescription
                ? book.description!.trim()
                : 'لا يوجد شرح أو وصف متاح لهذا الكتاب حالياً.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.black54,
              height: 1.65,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    BookDetailsBloc bloc,
    BookEntity book,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.prim,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => _handleReadInApp(context, book),
                  icon: const Icon(Iconsax.book, size: 18),
                  label: const Text(
                    'قراءة الكتاب',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.prim,
                    side: const BorderSide(color: AppColors.prim, width: 1.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () =>
                      _showOfflineDownloadOptions(context, bloc, book),
                  icon: const Icon(Iconsax.document_download, size: 18),
                  label: const Text(
                    'تنزيل أوفلاين',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleReadInApp(BuildContext context, BookEntity book) {
    if (onReadInApp != null) {
      onReadInApp!(context, book);
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('جاري فتح "${book.title}" للقراءة داخل التطبيق...'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _showOfflineDownloadOptions(
    BuildContext context,
    BookDetailsBloc bloc,
    BookEntity book,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'خيارات التنزيل للقراءة أوفلاين',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'اختر مكان حفظ نسخة "${book.title}" للقراءة بدون إنترنت:',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                tileColor: const Color(0xFFF8F9FA),
                leading: const Icon(Iconsax.mobile, color: AppColors.prim),
                title: const Text(
                  'حفظ للقراءة أوفلاين داخل التطبيق',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: const Text(
                  'يُحفظ في مكتبتك الخاصة داخل التطبيق للقراءة دون اتصال',
                  style: TextStyle(fontSize: 11),
                ),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  bloc.add(const DownloadBookEvent());
                  if (onDownloadOffline != null) {
                    await onDownloadOffline!(
                      context,
                      book,
                      saveOfflineInApp: true,
                    );
                  }
                },
              ),
              const SizedBox(height: 15),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                tileColor: const Color(0xFFF8F9FA),
                leading: const Icon(Iconsax.export_1, color: Color(0xFF0284C7)),
                title: const Text(
                  'تنزيل للقراءة خارج التطبيق (ملف الجهاز)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: const Text(
                  'تنزيل الملف إلى ذاكرة الجهاز لفتحه بأي قارئ خارجي',
                  style: TextStyle(fontSize: 11),
                ),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  bloc.add(const DownloadBookEvent());
                  if (onDownloadOffline != null) {
                    await onDownloadOffline!(
                      context,
                      book,
                      saveOfflineInApp: false,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _extractCategory(BookEntity book) {
    final dynamic dyn = book;
    try {
      final val = dyn.categoryName ?? dyn.category;
      if (val is String && val.trim().isNotEmpty) return val.trim();
    } catch (_) {}
    return '';
  }

  String _formatPublisherAndYear(BookEntity book) {
    final publisher = (book.publishingHouse ?? '').trim();
    String year = book.publishedAt ?? '';

    if (publisher.isNotEmpty && year.isNotEmpty) {
      return '$publisher   $year';
    }
    if (publisher.isNotEmpty) return publisher;
    if (year.isNotEmpty) return 'سنة النشر: $year';
    return 'غير محدد';
  }

  bool _extractForSale(BookEntity book) {
    final dynamic dyn = book;
    try {
      final forSale =
          dyn.isAvailableForSale ?? dyn.forSale ?? dyn.availableForSale;
      if (forSale is bool) return forSale;
    } catch (_) {}
    return false;
  }

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: const [
          ShimmerBox(
            width: double.infinity,
            height: 290,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          SizedBox(height: 20),
          ShimmerBox(width: double.infinity, height: 78),
          SizedBox(height: 18),
          ShimmerBox(width: double.infinity, height: 160),
          SizedBox(height: 18),
          ShimmerBox(width: double.infinity, height: 120),
        ],
      ),
    );
  }
}
