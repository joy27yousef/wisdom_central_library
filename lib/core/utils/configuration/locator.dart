import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wisdom_central_library/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:wisdom_central_library/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:wisdom_central_library/features/auth/domain/repositories/auth_repository.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/check_email_verified_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/send_password_reset_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/update_user_data_usecase.dart';
import 'package:wisdom_central_library/features/auth/presentation/managers/auth_manager.dart';
import 'package:wisdom_central_library/features/books/data/datasources/book_remote_data_source.dart';
import 'package:wisdom_central_library/features/books/data/repositories/book_repository_impl.dart';
import 'package:wisdom_central_library/features/books/domain/repositories/book_repository.dart';
import 'package:wisdom_central_library/features/books/domain/usecases/get_books_by_category_usecase.dart';
import 'package:wisdom_central_library/features/books/presentation/logic/bloc/category_books_bloc.dart';
import 'package:wisdom_central_library/features/categories/data/repositories/category_repository_impl.dart';
import 'package:wisdom_central_library/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:wisdom_central_library/features/categories/domain/repositories/category_repository.dart';
import 'package:wisdom_central_library/features/categories/domain/usecase/get_all_categories_usecase.dart';
import 'package:wisdom_central_library/features/categories/presentation/logic/bloc/category_bloc.dart';

final GetIt sl = GetIt.instance;

void setupLocator() {
  // 1. Dio Setup
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
      ),
    );

    return dio;
  });

  // ! External (Firebase)
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // ----------------- Auth Feature -----------------
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
      googleSignIn: sl<GoogleSignIn>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  // UseCases
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
    () => SendEmailVerificationUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => CheckEmailVerifiedUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => SendPasswordResetUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(() => UpdateUserDataUseCase(sl<AuthRepository>()));

  // Presentation Manager (LazySingleton للحفاظ على حالة المستخدم على مستوى التطبيق)
  sl.registerLazySingleton<AuthManager>(
    () => AuthManager(
      signInUseCase: sl<SignInUseCase>(),
      signUpUseCase: sl<SignUpUseCase>(),
      signOutUseCase: sl<SignOutUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      sendEmailVerificationUseCase: sl<SendEmailVerificationUseCase>(),
      checkEmailVerifiedUseCase: sl<CheckEmailVerifiedUseCase>(),
      sendPasswordResetUseCase: sl<SendPasswordResetUseCase>(),
      updateUserDataUseCase: sl<UpdateUserDataUseCase>(),
      signInWithGoogleUseCase: sl<SignInWithGoogleUseCase>(),
    ),
  );

  // ----------------- Categories Feature -----------------
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      remoteDataSource: sl<CategoryRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetAllCategoriesUseCase>(
    () => GetAllCategoriesUseCase(sl<CategoryRepository>()),
  );

  sl.registerLazySingleton<CategoryBloc>(
    () => CategoryBloc(getAllCategoriesUseCase: sl<GetAllCategoriesUseCase>()),
  );

  // ----------------- Books Feature -----------------
  sl.registerLazySingleton<BookRemoteDataSource>(
    () => BookRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(remoteDataSource: sl<BookRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetBooksByCategoryUseCase>(
    () => GetBooksByCategoryUseCase(sl<BookRepository>()),
  );

  sl.registerFactory<CategoryBooksBloc>(
    () => CategoryBooksBloc(
      getBooksByCategoryUseCase: sl<GetBooksByCategoryUseCase>(),
    ),
  );
}
