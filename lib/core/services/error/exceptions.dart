import 'package:cloud_firestore/cloud_firestore.dart';

class ServerException implements Exception {
  final String message;
  final String? code;
  const ServerException({this.message = 'حدث خطأ في الخادم', this.code});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'لا يوجد اتصال بالإنترنت']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'حدث خطأ في التخزين المؤقت']);
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([
    this.message = 'غير مصرح لك بالقيام بهذا الإجراء',
  ]);
}

String mapFirebaseExceptionMessage(dynamic error) {
  final String code = error is FirebaseException
      ? error.code
      : error.toString();

  switch (code) {
    // أكواد تسجيل الدخول الحديثة والقديمة
    case 'invalid-credential':
    case 'INVALID_LOGIN_CREDENTIALS':
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
    case 'user-not-found':
      return 'لا يوجد حساب مسجل بهذا البريد الإلكتروني.';
    case 'wrong-password':
      return 'كلمة المرور غير صحيحة، يرجى المحاولة مرة أخرى.';
    case 'invalid-email':
      return 'صيغة البريد الإلكتروني غير صحيحة.';
    case 'user-disabled':
      return 'تم تعطيل هذا الحساب، يرجى التواصل مع الإدارة.';

    // أكواد إنشاء الحساب
    case 'email-already-in-use':
      return 'هذا البريد الإلكتروني مستخدم بالفعل في حساب آخر.';
    case 'weak-password':
      return 'كلمة المرور ضعيفة جداً، يجب أن تكون 6 أحرف على الأقل.';
    case 'operation-not-allowed':
      return 'تسجيل الدخول بالبريد الإلكتروني غير مفعّل حالياً.';

    // أكواد الشبكة والضغط والحقول الفارغة
    case 'channel-error':
      return 'يرجى ملء جميع الحقول المطلوبة بشكل صحيح.';
    case 'network-request-failed':
      return 'تعذر الاتصال بالإنترنت، تحقق من الشبكة وحاول مجدداً.';
    case 'too-many-requests':
      return 'تم حظر المحاولات مؤقتاً لكثرة الطلبات، انتظر قليلاً ثم حاول.';
    case 'requires-recent-login':
      return 'يرجى تسجيل الدخول مجدداً لإتمام هذه العملية.';

    // أكواد Firestore
    case 'permission-denied':
      return 'ليس لديك صلاحية للوصول إلى هذه البيانات.';
    case 'unavailable':
      return 'الخدمة غير متوفرة حالياً، حاول لاحقاً.';
    case 'not-found':
      return 'البيانات المطلوبة غير موجودة.';

    default:
      return 'حدث خطأ غير متوقع ($code)، يرجى المحاولة لاحقاً.';
  }
}
