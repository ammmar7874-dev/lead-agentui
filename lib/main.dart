import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'core/storage/secure_storage_service.dart';
import 'modules/auth/controllers/auth_controller.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Storage Service
  final storage = await SecureStorageService().init();
  Get.put<SecureStorageService>(storage, permanent: true);

  // Global Auth Controller
  Get.put<AuthController>(AuthController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = SecureStorageService.to;
    final savedTheme = storage.getThemeMode();
    return GetMaterialApp(
      title: 'AI RAG ChatBot',

      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: savedTheme == 'light' ? ThemeMode.light : ThemeMode.dark,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
