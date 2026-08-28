import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/storage/secure_storage_service.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find();

  final RxDouble opacity = 0.0.obs;
  final RxDouble scale = 0.8.obs;
  final RxString statusText = 'Initializing AI Engine...'.obs;

  @override
  void onInit() {
    super.onInit();
    _startAnimationAndNavigate();
  }

  Future<void> _startAnimationAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 300));
    opacity.value = 1.0;
    scale.value = 1.0;

    await Future.delayed(const Duration(milliseconds: 1000));
    statusText.value = 'Connecting to RAG Knowledge Base...';

    await Future.delayed(const Duration(milliseconds: 1000));
    statusText.value = 'Ready';

    await Future.delayed(const Duration(milliseconds: 500));
    _checkNavigation();
  }

  void _checkNavigation() {
    final storage = SecureStorageService.to;
    final bool hasSeenOnboarding = storage.hasSeenOnboarding();
    final bool isLoggedIn = storage.isLoggedIn();

    if (!hasSeenOnboarding) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
