import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/routes/app_routes.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';

// نماذج بيانات مبسطة للعرض الستاتيكي فقط
class _StaticBook {
  final String id;
  final String title;
  final String author;
  final String subCategoryId;
  final String coverUrl;
  final String publishingHouse;
  final int numbersPages;

  const _StaticBook({
    required this.id,
    required this.title,
    required this.author,
    required this.subCategoryId,
    this.coverUrl = '',
    this.publishingHouse = 'دار الحكمة',
    this.numbersPages = 250,
  });
}

class _StaticSubCategory {
  final String id;
  final String title;

  const _StaticSubCategory({required this.id, required this.title});
}

class CategoryBooksScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const CategoryBooksScreen({
    super.key,
    this.categoryName = 'التصنيف',
    this.categoryId = 'cat_1',
  });

  @override
  State<CategoryBooksScreen> createState() => _CategoryBooksScreenState();
}

class _CategoryBooksScreenState extends State<CategoryBooksScreen> {
  bool isGridMode = true;
  String? selectedSubCategoryId;

  // بيانات تجريبية للتصنيفات الفرعية
  final List<_StaticSubCategory> _subCategories = const [
    _StaticSubCategory(id: 'sub_1', title: 'تطوير التطبيقات'),
    _StaticSubCategory(id: 'sub_2', title: 'هندسة البرمجيات'),
    _StaticSubCategory(id: 'sub_3', title: 'الذكاء الاصطناعي'),
  ];

  // بيانات تجريبية للكتب
  final List<_StaticBook> _allBooks = const [
    _StaticBook(
      id: '1',
      title: 'Clean Code (الكود النظيف)',
      author: 'Robert C. Martin',
      subCategoryId: 'sub_2',
      publishingHouse: 'دار المعارف التقنية',
      numbersPages: 464,
    ),
    _StaticBook(
      id: '2',
      title: 'احتراف تطوير تطبيقات Flutter',
      author: 'أحمد المنصور',
      subCategoryId: 'sub_1',
      publishingHouse: 'دار الحكمة للنشر',
      numbersPages: 320,
    ),
    _StaticBook(
      id: '3',
      title: 'مبادئ التصميم المعماري للأنظمة',
      author: 'Martin Fowler',
      subCategoryId: 'sub_2',
      publishingHouse: 'مكتبة جرير',
      numbersPages: 510,
    ),
    _StaticBook(
      id: '4',
      title: 'مقدمة في تعلم الآلة والذكاء الاصطناعي',
      author: 'سارة العلي',
      subCategoryId: 'sub_3',
      publishingHouse: 'دار الفكر الحديث',
      numbersPages: 280,
    ),
  ];

  List<_StaticBook> get _displayedBooks {
    if (selectedSubCategoryId == null) return _allBooks;
    return _allBooks
        .where((book) => book.subCategoryId == selectedSubCategoryId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final books = _displayedBooks;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. AppBar عصري مدمج ومتوافق مع لون الخلفية
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: const Color(0xFFF8F9FA),
            centerTitle: true,
            title: Text(
              widget.categoryName,
              style: AppTextStyles.headlineSmall.copyWith(
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
                fontSize: 18,
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
                    side: BorderSide(
                      color: AppColors.gray.withValues(alpha: 0.1),
                    ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: AppColors.gray.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  icon: Icon(
                    isGridMode
                        ? Icons.view_list_rounded
                        : Icons.grid_view_rounded,
                    color: AppColors.prim,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      isGridMode = !isGridMode;
                    });
                  },
                ),
              ),
            ],
          ),

          // 2. شريط التصنيفات الفرعية (Sub-categories Header)
          if (_subCategories.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _subCategories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final isAllSelected = selectedSubCategoryId == null;
                      return _buildSubCategoryChip(
                        title: 'الكل',
                        isSelected: isAllSelected,
                        onTap: () {
                          setState(() {
                            selectedSubCategoryId = null;
                          });
                        },
                      );
                    }

                    final subCategory = _subCategories[index - 1];
                    final isSelected = selectedSubCategoryId == subCategory.id;

                    return _buildSubCategoryChip(
                      title: subCategory.title,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          selectedSubCategoryId = subCategory.id;
                        });
                      },
                    );
                  },
                ),
              ),
            ),

          // 3. عرض الكتب (Empty أو Grid/List)
          if (books.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد كتب متاحة في هذا التصنيف حالياً',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: isGridMode
                  ? SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.60,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _buildBookGridItem(books[index], () {
                              pushTo(context, AppRoutes.bookDetails);
                            }),
                        childCount: books.length,
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _buildBookListItem(books[index], () {
                              pushTo(context, AppRoutes.bookDetails);
                            }),
                        childCount: books.length,
                      ),
                    ),
            ),
        ],
      ),
    );
  }

  // تصميم Chip التصنيف الفرعي
  Widget _buildSubCategoryChip({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppColors.prim : AppColors.white,
          border: Border.all(
            color: isSelected
                ? AppColors.prim
                : AppColors.gray.withValues(alpha: 0.15),
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: const Color(0xFF1E293B).withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : const Color(0xFF2D3436),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // تصميم عنصر الكتاب في وضع الشبكة (Grid Item)
  Widget _buildBookGridItem(_StaticBook book, void Function()? ontap) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.04),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: AppColors.gray.withValues(alpha: 0.08)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: ontap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: book.coverUrl.isNotEmpty
                          ? Image.network(
                              book.coverUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: AppColors.prim.withValues(alpha: 0.08),
                              child: const Center(
                                child: Icon(
                                  Icons.book_rounded,
                                  size: 40,
                                  color: AppColors.prim,
                                ),
                              ),
                            ),
                    ),
                    // أيقونة مفضلة ستاتيكية بدون الاعتماد على Bloc
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gray.withValues(alpha: 0.8),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${book.numbersPages} صفحة',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: AppColors.prim,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // تصميم عنصر الكتاب في وضع القائمة (List Item)
  Widget _buildBookListItem(_StaticBook book, void Function()? ontap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.04),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: AppColors.gray.withValues(alpha: 0.08)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: ontap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: book.coverUrl.isNotEmpty
                      ? Image.network(
                          book.coverUrl,
                          width: 70,
                          height: 95,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 70,
                          height: 95,
                          color: AppColors.prim.withValues(alpha: 0.08),
                          child: const Icon(
                            Icons.book_rounded,
                            color: AppColors.prim,
                            size: 30,
                          ),
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.prim.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              book.publishingHouse.isNotEmpty
                                  ? book.publishingHouse
                                  : 'دار النشر',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.prim,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${book.numbersPages} صفحة',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
