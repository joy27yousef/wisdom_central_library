import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/themes/app_responsive.dart';

// نماذج بيانات مبسطة للعرض الستاتيكي فقط
class _StaticBook {
  final String id;
  final String title;
  final String author;
  final String categoryId;
  final String description;
  final String coverUrl;
  final String pdfUrl;

  const _StaticBook({
    required this.id,
    required this.title,
    required this.author,
    required this.categoryId,
    this.description = '',
    this.coverUrl = '',
    this.pdfUrl = '',
  });
}

class _StaticCategory {
  final String id;
  final String title;

  const _StaticCategory({required this.id, required this.title});
}

class AdminBooksScreen extends StatefulWidget {
  const AdminBooksScreen({super.key});

  @override
  State<AdminBooksScreen> createState() => _AdminBooksScreenState();
}

class _AdminBooksScreenState extends State<AdminBooksScreen> {
  // بيانات تجريبية للتصنيفات
  final List<_StaticCategory> _categories = const [
    _StaticCategory(id: 'cat_1', title: 'الأدب والرواية'),
    _StaticCategory(id: 'cat_2', title: 'البرمجة والتقنية'),
    _StaticCategory(id: 'cat_3', title: 'التاريخ والحضارة'),
    _StaticCategory(id: 'cat_4', title: 'تطوير الذات'),
  ];

  // بيانات تجريبية للكتب
  final List<_StaticBook> _books = const [
    _StaticBook(
      id: '1',
      title: 'Clean Code (الكود النظيف)',
      author: 'Robert C. Martin',
      categoryId: 'البرمجة والتقنية',
      description: 'دليل شامل لكتابة كود برمجي نظيف وقابل للصيانة.',
    ),
    _StaticBook(
      id: '2',
      title: 'مقدمة ابن خلدون',
      author: 'عبد الرحمن بن خلدون',
      categoryId: 'التاريخ والحضارة',
      description: 'كتاب في علم الاجتماع والتاريخ وفلسفة العمران.',
    ),
    _StaticBook(
      id: '3',
      title: 'البؤساء',
      author: 'فيكتور هوجو',
      categoryId: 'الأدب والرواية',
      description: 'رواية عالمية خالدة تتناول العدالة الاجتماعية.',
    ),
    _StaticBook(
      id: '4',
      title: 'العادات الذرية',
      author: 'جيمس كلير',
      categoryId: 'تطوير الذات',
      description: 'طريقة سهلة ومثبتة لبناء عادات جيدة والتخلص من السيئة.',
    ),
  ];

  String? _selectedCategoryTitle;
  String _searchQuery = '';

  List<_StaticBook> get _filteredBooks {
    return _books.where((book) {
      final matchesCategory =
          _selectedCategoryTitle == null ||
          book.categoryId == _selectedCategoryTitle;
      final matchesSearch =
          _searchQuery.isEmpty ||
          book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayedBooks = _filteredBooks;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إدارة الكتب والتحكم',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF1E293B),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.refresh_rounded,
                color: Color(0xFF475569),
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _selectedCategoryTitle = null;
                  _searchQuery = '';
                });
              },
              tooltip: 'تحديث البيانات',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBookDialog(context),
        backgroundColor: const Color(0xFF2563EB),
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'إضافة كتاب جديد',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // قسم البحث والفلاتر العلوي بتصميم فاخر
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // شريط البحث المطور
                TextField(
                  onChanged: (query) => setState(() => _searchQuery = query),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن اسم الكتاب أو المؤلف...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF2563EB),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF2563EB),
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // أزرار الفلترة الأفقية
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        final isSelected = _selectedCategoryTitle == null;
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: _buildCategoryChip(
                            label: 'جميع التصنيفات',
                            isSelected: isSelected,
                            onTap: () =>
                                setState(() => _selectedCategoryTitle = null),
                          ),
                        );
                      }
                      final category = _categories[index - 1];
                      final isSelected =
                          _selectedCategoryTitle == category.title;
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: _buildCategoryChip(
                          label: category.title,
                          isSelected: isSelected,
                          onTap: () => setState(
                            () => _selectedCategoryTitle = category.title,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // شريط معلومات النتائج
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'إجمالي الكتب: ${displayedBooks.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
                if (_selectedCategoryTitle != null)
                  InkWell(
                    onTap: () => setState(() => _selectedCategoryTitle = null),
                    child: const Text(
                      'إلغاء الفلترة ×',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // عرض القائمة أو الشبكة حسب نوع الشاشة (موبايل / تابلت)
          Expanded(
            child: displayedBooks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد كتب مطابقة لبحثك',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildResponsiveBooksView(context, displayedBooks),
                  ),
          ),
        ],
      ),
    );
  }

  // التبديل التلقائي بين الموبايل والتابلت
  Widget _buildResponsiveBooksView(
    BuildContext context,
    List<_StaticBook> books,
  ) {
    if (Responsive.isMobile(context)) {
      return ListView.builder(
        itemCount: books.length,
        padding: const EdgeInsets.only(bottom: 90, top: 4),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildBookCardItem(context, books[index], isGrid: false),
        ),
      );
    }

    // تصميم شبكي للتابلت (Grid View)
    return GridView.builder(
      itemCount: books.length,
      padding: const EdgeInsets.only(bottom: 90, top: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) =>
          _buildBookCardItem(context, books[index], isGrid: true),
    );
  }

  // تصميم بطاقة الكتاب
  Widget _buildBookCardItem(
    BuildContext context,
    _StaticBook book, {
    required bool isGrid,
  }) {
    return Container(
      height: isGrid ? null : 95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // غلاف الكتاب
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: book.coverUrl.isNotEmpty
                ? Image.network(
                    book.coverUrl,
                    width: isGrid ? 55 : 60,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildCoverPlaceholder(),
                  )
                : _buildCoverPlaceholder(),
          ),
          const SizedBox(width: 14),

          // تفاصيل الكتاب
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'المؤلف: ${book.author}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'التصنيف: ${book.categoryId}',
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // أزرار التعديل والحذف
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                icon: Icons.edit_rounded,
                color: const Color(0xFF2563EB),
                bgColor: const Color(0xFFEFF6FF),
                onTap: () => _showBookDialog(context, book: book),
              ),
              const SizedBox(height: 8),
              _buildActionButton(
                icon: Icons.delete_outline_rounded,
                color: const Color(0xFFDC2626),
                bgColor: const Color(0xFFFEF2F2),
                onTap: () => _showDeleteConfirmDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildCoverPlaceholder() {
    return Container(
      width: 55,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(Icons.book_rounded, color: Color(0xFF94A3B8), size: 24),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
                : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF475569),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // نافذة الحوار للإضافة أو التعديل (ستاتيكية)
  void _showBookDialog(BuildContext context, {_StaticBook? book}) {
    final isEditing = book != null;
    final titleController = TextEditingController(text: book?.title ?? '');
    final authorController = TextEditingController(text: book?.author ?? '');
    final descController = TextEditingController(text: book?.description ?? '');
    final coverUrlController = TextEditingController(
      text: book?.coverUrl ?? '',
    );
    final pdfUrlController = TextEditingController(text: book?.pdfUrl ?? '');

    String? selectedCategory = book?.categoryId ?? _categories.first.title;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                isEditing ? 'تعديل بيانات الكتاب' : 'إضافة كتاب جديد',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTextField(
                        controller: titleController,
                        label: 'عنوان الكتاب',
                        icon: Icons.title_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: authorController,
                        label: 'اسم المؤلف',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'التصنيف',
                          prefixIcon: const Icon(
                            Icons.category_outlined,
                            color: Color(0xFF2563EB),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category.title,
                            child: Text(category.title),
                          );
                        }).toList(),
                        onChanged: (newValue) =>
                            setStateDialog(() => selectedCategory = newValue),
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: descController,
                        label: 'وصف الكتاب',
                        icon: Icons.description_outlined,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: coverUrlController,
                        label: 'رابط الغلاف (Cover URL)',
                        icon: Icons.image_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: pdfUrlController,
                        label: 'رابط ملف PDF',
                        icon: Icons.picture_as_pdf_outlined,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(isEditing ? 'حفظ التعديلات' : 'إضافة الكتاب'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFF2563EB), size: 20),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
      ),
    );
  }

  // نافذة تأكيد الحذف (ستاتيكية)
  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'حذف الكتاب',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text(
            'هل أنت متأكد من رغبتك في حذف هذا الكتاب؟ لا يمكن التراجع عن هذا الإجراء.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'تراجع',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('حذف نهائي'),
            ),
          ],
        );
      },
    );
  }
}
