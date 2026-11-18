import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/const/app_string.dart';
import 'package:wisdom_central_library/core/shared/widgets/custom_button.dart';
import 'package:wisdom_central_library/core/shared/widgets/custom_text_form.dart';
import 'package:wisdom_central_library/core/shared/widgets/message.dart';
import 'package:wisdom_central_library/core/shared/widgets/simple_appbar.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/features/auth/domain/entities/user_entity.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/update_user_data_usecase.dart';
import 'package:wisdom_central_library/features/auth/presentation/managers/auth_manager.dart';

class EditProfilePage extends WatchingStatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  String? _selectedBranch;
  String? _selectedStage;
  bool _isDataInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();

    final authManager = di<AuthManager>();
    // تعبئة البيانات فوراً إذا كانت محملة مسبقاً في الذاكرة، أو جلبها من السيرفر
    final cachedUser = authManager.currentUser.value;
    if (cachedUser != null && cachedUser.uid.isNotEmpty) {
      _initializeFields(cachedUser);
    } else {
      authManager.checkAuthStatusCommand.execute();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _initializeFields(UserEntity? user) {
    if (user != null && user.uid.isNotEmpty && !_isDataInitialized) {
      _nameController.text = user.name;
      _phoneController.text = user.phone;

      _selectedBranch =
          (user.branch.isNotEmpty && mjoBranches.contains(user.branch))
          ? user.branch
          : null;
      _selectedStage = (user.stage.isNotEmpty && mjoStages.contains(user.stage))
          ? user.stage
          : null;

      _isDataInitialized = true;
    }
  }

  String _cleanMessage(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    final authManager = di<AuthManager>();

    // مراقبة حالتي التحميل بشكل منفصل
    final isFetching = watch(
      authManager.checkAuthStatusCommand.isExecuting,
    ).value;
    final isUpdating = watch(
      authManager.updateUserDataCommand.isExecuting,
    ).value;

    // 1. تعبئة الحقول عند وصول بيانات المستخدم
    registerHandler<AuthManager, UserEntity?>(
      select: (m) => m.currentUser,
      handler: (context, user, cancel) {
        if (!_isDataInitialized && user != null && user.uid.isNotEmpty) {
          setState(() {
            _initializeFields(user);
          });
        }
      },
    );

    // 2. الاستماع لنجاح حفظ التغييرات
    registerHandler<AuthManager, UserEntity>(
      select: (m) => m.updateUserDataCommand,
      handler: (context, updatedUser, cancel) {
        if (updatedUser.uid.isEmpty) return;
        showMessage(
          context,
          message: 'تم حفظ التغييرات بنجاح',
          isSuccess: true,
        );
      },
    );

    // 3. الاستماع لأخطاء الحفظ
    registerHandler<AuthManager, CommandError<UpdateUserParams>?>(
      select: (m) => m.updateUserDataCommand.errors,
      handler: (context, error, cancel) {
        if (error == null) return;
        showMessage(
          context,
          message: _cleanMessage(error.error),
          isSuccess: false,
        );
      },
    );

    return Scaffold(
      appBar: const SimpleAppbar(title: 'تعديل الملف الشخصي'),
      body: (isFetching && !_isDataInitialized)
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextForm(
                      hint: 'الاسم الكامل',
                      iconform: Icon(
                        Iconsax.user,
                        color: AppColors.prim.withValues(alpha: 0.7),
                      ),
                      mycontroller: _nameController,
                      typekey: TextInputType.name,
                      valid: (value) => value == null || value.trim().isEmpty
                          ? 'يرجى إدخال الاسم'
                          : null,
                    ),
                    const SizedBox(height: 18),
                    CustomTextForm(
                      hint: 'رقم الهاتف',
                      iconform: Icon(
                        Iconsax.call,
                        color: AppColors.prim.withValues(alpha: 0.7),
                      ),
                      mycontroller: _phoneController,
                      typekey: TextInputType.phone,
                      valid: (value) => value == null || value.trim().isEmpty
                          ? 'يرجى إدخال رقم الهاتف'
                          : null,
                    ),
                    const SizedBox(height: 18),
                    customDropdownField(
                      value: _selectedBranch,
                      label: 'الفرع',
                      items: mjoBranches,
                      onChanged: (val) => setState(() => _selectedBranch = val),
                      validator: (val) =>
                          val == null ? 'يرجى اختيار الفرع' : null,
                    ),
                    const SizedBox(height: 16),
                    customDropdownField(
                      value: _selectedStage,
                      label: 'المرحلة',
                      items: mjoStages,
                      onChanged: (val) => setState(() => _selectedStage = val),
                      validator: (val) =>
                          val == null ? 'يرجى اختيار المرحلة' : null,
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      color: AppColors.prim,
                      isLoading: isUpdating,
                      ontapfun: () {
                        if (_formKey.currentState!.validate()) {
                          authManager.updateUserDataCommand.execute(
                            UpdateUserParams(
                              name: _nameController.text.trim(),
                              phone: _phoneController.text.trim(),
                              branch: _selectedBranch ?? '',
                              stage: _selectedStage ?? '',
                            ),
                          );
                        }
                      },
                      text: 'حفظ التغييرات',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
