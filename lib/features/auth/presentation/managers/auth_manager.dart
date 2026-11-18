import 'dart:async';
import 'package:command_it/command_it.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:listen_it/listen_it.dart';
import 'package:wisdom_central_library/features/auth/domain/entities/user_entity.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/check_email_verified_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/send_password_reset_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/update_user_data_usecase.dart';

class AuthManager implements Disposable {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SendEmailVerificationUseCase _sendEmailVerificationUseCase;
  final CheckEmailVerifiedUseCase _checkEmailVerifiedUseCase;
  final SendPasswordResetUseCase _sendPasswordResetUseCase;
  final UpdateUserDataUseCase _updateUserDataUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  final ValueNotifier<UserEntity?> _currentUser = ValueNotifier<UserEntity?>(
    null,
  );
  ValueListenable<UserEntity?> get currentUser => _currentUser;

  // سلاسل تفاعلية مشتقة باستخدام listen_it
  late final ValueListenable<bool> isAuthenticated;
  late final ValueListenable<bool> isProfileComplete;

  // الأوامر (Commands)
  late final Command<SignInParams, UserEntity> signInCommand;
  late final Command<void, UserEntity> signInWithGoogleCommand;
  late final Command<SignUpParams, UserEntity> signUpCommand;
  late final Command<void, void> signOutCommand;
  late final Command<void, UserEntity?> checkAuthStatusCommand;
  late final Command<void, String> sendEmailVerificationCommand;
  late final Command<void, bool> checkEmailVerifiedCommand;
  late final Command<String, String> sendPasswordResetCommand;
  late final Command<UpdateUserParams, UserEntity> updateUserDataCommand;

  AuthManager({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SendEmailVerificationUseCase sendEmailVerificationUseCase,
    required CheckEmailVerifiedUseCase checkEmailVerifiedUseCase,
    required SendPasswordResetUseCase sendPasswordResetUseCase,
    required UpdateUserDataUseCase updateUserDataUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
  }) : _signInUseCase = signInUseCase,
       _signUpUseCase = signUpUseCase,
       _signOutUseCase = signOutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _sendEmailVerificationUseCase = sendEmailVerificationUseCase,
       _checkEmailVerifiedUseCase = checkEmailVerifiedUseCase,
       _sendPasswordResetUseCase = sendPasswordResetUseCase,
       _updateUserDataUseCase = updateUserDataUseCase,
       _signInWithGoogleUseCase = signInWithGoogleUseCase {
    // ربط القيم المشتقة عبر listen_it
    isAuthenticated = _currentUser.map(
      (user) => user != null && user.isEmailVerified,
    );
    isProfileComplete = _currentUser.map(
      (user) => user?.isProfileComplete ?? false,
    );

    // 1. أمر تسجيل الدخول بالبريد وكلمة المرور
    signInCommand = Command.createAsync<SignInParams, UserEntity>((
      params,
    ) async {
      final result = await _signInUseCase(params);
      return result.fold((failure) => throw Exception(failure.message), (user) {
        if (!user.isEmailVerified) {
          _currentUser.value = user;
          throw Exception('البريد الإلكتروني غير موثق. يرجى التحقق من بريدك.');
        }
        _currentUser.value = user;
        return user;
      });
    }, initialValue: _emptyUser);

    // 2. أمر تسجيل الدخول عبر Google
    signInWithGoogleCommand = Command.createAsyncNoParam<UserEntity>(() async {
      final result = await _signInWithGoogleUseCase();
      return result.fold((failure) => throw Exception(failure.message), (user) {
        _currentUser.value = user;
        return user;
      });
    }, initialValue: _emptyUser);

    // 3. أمر إنشاء حساب جديد
    signUpCommand = Command.createAsync<SignUpParams, UserEntity>((
      params,
    ) async {
      final result = await _signUpUseCase(params);
      return result.fold((failure) => throw Exception(failure.message), (
        user,
      ) async {
        _currentUser.value = user;
        await _sendEmailVerificationUseCase();
        return user;
      });
    }, initialValue: _emptyUser);

    // 4. أمر تسجيل الخروج
    signOutCommand = Command.createAsyncNoParamNoResult(() async {
      final result = await _signOutUseCase();
      result.fold(
        (failure) => throw Exception(failure.message),
        (_) => _currentUser.value = null,
      );
    });

    // 5. أمر فحص الجلسة الحالية
    checkAuthStatusCommand = Command.createAsyncNoParam<UserEntity?>(() async {
      final result = await _getCurrentUserUseCase();
      return result.fold(
        (failure) {
          _currentUser.value = null;
          throw Exception(failure.message);
        },
        (user) {
          _currentUser.value = user;
          return user;
        },
      );
    }, initialValue: null);

    // 6. أمر إرسال رابط التفعيل
    sendEmailVerificationCommand = Command.createAsyncNoParam<String>(() async {
      final result = await _sendEmailVerificationUseCase();
      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) => 'تم إرسال رابط التحقق إلى بريدك الإلكتروني بنجاح.',
      );
    }, initialValue: '');

    // 7. أمر التحقق من تفعيل البريد
    checkEmailVerifiedCommand = Command.createAsyncNoParam<bool>(() async {
      final result = await _checkEmailVerifiedUseCase();
      return result.fold((failure) => throw Exception(failure.message), (
        isVerified,
      ) {
        if (!isVerified) {
          throw Exception('البريد الإلكتروني لم يتم توثيقه بعد.');
        }
        if (_currentUser.value != null) {
          _currentUser.value = _currentUser.value!.copyWith(
            isEmailVerified: true,
          );
        }
        return true;
      });
    }, initialValue: false);

    // 8. أمر استعادة كلمة المرور
    sendPasswordResetCommand = Command.createAsync<String, String>((
      email,
    ) async {
      final result = await _sendPasswordResetUseCase(email);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) => 'تم إرسال رابط استعادة كلمة المرور إلى بريدك الإلكتروني.',
      );
    }, initialValue: '');

    // 9. أمر تحديث بيانات المستخدم
    updateUserDataCommand = Command.createAsync<UpdateUserParams, UserEntity>((
      params,
    ) async {
      final result = await _updateUserDataUseCase(params);
      return result.fold((failure) => throw Exception(failure.message), (
        updatedUser,
      ) {
        _currentUser.value = updatedUser;
        return updatedUser;
      });
    }, initialValue: _emptyUser);
  }

  static const UserEntity _emptyUser = UserEntity(
    uid: '',
    email: '',
    name: '',
    role: 'user',
    phone: '',
    stage: '',
    branch: '',
  );

  @override
  FutureOr<void> onDispose() {
    signInCommand.dispose();
    signInWithGoogleCommand.dispose();
    signUpCommand.dispose();
    signOutCommand.dispose();
    checkAuthStatusCommand.dispose();
    sendEmailVerificationCommand.dispose();
    checkEmailVerifiedCommand.dispose();
    sendPasswordResetCommand.dispose();
    updateUserDataCommand.dispose();
    _currentUser.dispose();
  }
}
