import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:wisdom_central_library/core/const/app_endpoints.dart';
import 'package:wisdom_central_library/core/utils/configuration/locator.dart';
import 'package:wisdom_central_library/features/auth/presentation/managers/auth_manager.dart';
import 'package:wisdom_central_library/features/auth/presentation/screen/edit_profile_page.dart';
import 'package:wisdom_central_library/features/auth/presentation/screen/forget_pass_page.dart';
import 'package:wisdom_central_library/features/auth/presentation/screen/login_page.dart';
import 'package:wisdom_central_library/features/auth/presentation/screen/signup_page.dart';
import 'package:wisdom_central_library/features/auth/presentation/screen/verify_email_page.dart';
import 'package:wisdom_central_library/features/books/presentation/screens/category_books_screen.dart';
import 'package:wisdom_central_library/features/categories/presentation/screens/all_categories_page.dart';
import 'package:wisdom_central_library/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:wisdom_central_library/features/home/presentation/screens/home_page.dart';
import 'package:wisdom_central_library/features/main_page.dart';

class AppRoutes {
  //! Auth
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgetPass = '/forgetPassPage';
  static const String verifyEmail = '/verify-email';
  static const String editProfilePage = '/editProfilePage';

  //! Home & Features
  static const String main = '/mainPage';
  static const String home = '/homePage';
  static const String categoryBooks = '/categoryBooks';
  static const String allCategoriesPage = '/allCategoriesPage';
  static const String bookDetails = '/bookDetails';
  static const String favorites = '/favorites';

  static GoRouter? _router;

  static bool get _hasValidSession {
    final authManager = sl<AuthManager>();
    if (authManager.isAuthenticated.value) return true;

    final firebaseUser = sl<FirebaseAuth>().currentUser;
    if (firebaseUser != null && firebaseUser.emailVerified) {
      // تشغيل جلب بيانات المستخدم في الخلفية لتحديث AuthManager تلقائياً
      if (!authManager.checkAuthStatusCommand.isExecuting.value &&
          authManager.currentUser.value == null) {
        authManager.checkAuthStatusCommand.execute();
      }
      return true;
    }
    return false;
  }

  static GoRouter get routes {
    _router ??= GoRouter(
      // تحديد نقطة البداية مباشرة بناءً على الجلسة المحفوظة
      initialLocation: _hasValidSession ? main : login,
      // الاستماع لأي تغيير في AuthManager أو FirebaseAuth تلقائياً
      refreshListenable: _AuthRouterRefreshListenable(
        authManager: sl<AuthManager>(),
        firebaseAuth: sl<FirebaseAuth>(),
      ),
      redirect: (context, state) {
        final bool isLoggedIn = _hasValidSession;
        final String path = state.uri.path;
        final bool isAuthRoute =
            path == login ||
            path == signup ||
            path == forgetPass ||
            path == verifyEmail;

        if (!isLoggedIn && !isAuthRoute) {
          return login;
        }

        if (isLoggedIn && isAuthRoute) {
          return main;
        }

        return null;
      },
      routes: [
        // Auth
        GoRoute(path: login, builder: (context, state) => const LoginPage()),
        GoRoute(path: signup, builder: (context, state) => const SignupPage()),
        GoRoute(
          path: forgetPass,
          builder: (context, state) => const ForgetPassPage(),
        ),
        GoRoute(
          path: verifyEmail,
          builder: (context, state) => const VerifyEmailPage(),
        ),
        GoRoute(
          path: editProfilePage,
          builder: (context, state) => const EditProfilePage(),
        ),

        // Home
        GoRoute(path: home, builder: (context, state) => const HomePage()),
        GoRoute(path: main, builder: (context, state) => MainPage()),

        // Category
        GoRoute(
          path: allCategoriesPage,
          builder: (context, state) => const AllCategoriesPage(),
        ),
        GoRoute(
          path: '/categoryBooks/:categoryId',
          builder: (context, state) {
            final categoryId =
                state.pathParameters[ApiKey.categoryId] ?? 'cat_1';
            final categoryName = state.extra as String? ?? 'الكتب';

            return CategoryBooksScreen(
              categoryId: categoryId,
              categoryName: categoryName,
            );
          },
        ),

        // Book
        GoRoute(
          path: bookDetails,
          builder: (context, state) => const CategoryBooksScreen(),
        ),

        // Favorites
        GoRoute(
          path: favorites,
          builder: (context, state) {
            final userId =
                sl<AuthManager>().currentUser.value?.uid ??
                sl<FirebaseAuth>().currentUser?.uid ??
                (state.extra as String? ?? 'static_user');
            return FavoritesScreen(userId: userId);
          },
        ),
      ],
    );
    return _router!;
  }
}

/// مستمع موحّد يربط GoRouter مع AuthManager وتدفق FirebaseAuth
class _AuthRouterRefreshListenable extends ChangeNotifier {
  late final StreamSubscription<User?> _authSub;
  final AuthManager authManager;

  _AuthRouterRefreshListenable({
    required this.authManager,
    required FirebaseAuth firebaseAuth,
  }) {
    authManager.isAuthenticated.addListener(notifyListeners);
    _authSub = firebaseAuth.authStateChanges().listen((user) {
      if (user != null &&
          user.emailVerified &&
          authManager.currentUser.value == null &&
          !authManager.checkAuthStatusCommand.isExecuting.value) {
        authManager.checkAuthStatusCommand.execute();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    authManager.isAuthenticated.removeListener(notifyListeners);
    _authSub.cancel();
    super.dispose();
  }
}
