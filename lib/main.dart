import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/routes/app_routes.dart';
import 'package:wisdom_central_library/core/services/cache/cache_helper.dart';
import 'package:wisdom_central_library/core/services/lifecycle/app_lifecycle_handler.dart';
import 'package:wisdom_central_library/core/themes/app_thems.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/utils/configuration/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  setupLocator();

  await sl.allReady();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLifecycleObserver lifecycleObserver;

  @override
  void initState() {
    super.initState();
    lifecycleObserver = AppLifecycleObserver(context);
    WidgetsBinding.instance.addObserver(lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppThems.lightTheme,
      routerConfig: AppRoutes.routes,
      locale: const Locale('ar'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );
  }
}
