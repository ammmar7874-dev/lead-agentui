import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/native/platform_helper.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../theme/app_colors.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final RxBool isLoading = false.obs;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  // Login Controllers
  final emailController = TextEditingController(text: 'zia@excels-tech.com');
  final passwordController = TextEditingController(text: 'Password@123');

  // Signup Controllers
  final signupNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmPasswordController = TextEditingController();
  final RxBool acceptTerms = true.obs;

  // Forgot Password Controller
  final forgotEmailController = TextEditingController();
  final RxBool isResetSent = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadExistingUser();
  }

  void _loadExistingUser() {
    final userData = SecureStorageService.to.getUserData();
    if (userData != null) {
      currentUser.value = UserModel.fromJson(userData);
    }
  }

  bool get isAuthenticated => currentUser.value != null;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      _showSnackbar('Invalid Email', 'Please enter a valid email address', isError: true);
      return;
    }
    if (password.length < 6) {
      _showSnackbar('Invalid Password', 'Password must be at least 6 characters', isError: true);
      return;
    }

    isLoading.value = true;
    PlatformHelper.mediumHaptic();

    try {
      // Simulate API verification
      await Future.delayed(const Duration(milliseconds: 900));

      final user = UserModel(
        id: 'user_001',
        name: email.contains('@') ? email.split('@')[0].capitalizeFirst ?? 'User' : 'Admin User',
        email: email,
        role: 'ADMIN',
        organizationName: 'Excels Tech RAG',
        token: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      currentUser.value = user;
      await SecureStorageService.to.saveUserData(user.toJson());
      await SecureStorageService.to.saveToken(user.token!);
      await SecureStorageService.to.setIsLoggedIn(true);

      PlatformHelper.heavyHaptic();
      _showSnackbar('Welcome back!', 'Successfully authenticated as ${user.name}');

      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      _showSnackbar('Login Failed', e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup() async {
    final name = signupNameController.text.trim();
    final email = signupEmailController.text.trim();
    final password = signupPasswordController.text.trim();
    final confirmPassword = signupConfirmPasswordController.text.trim();

    if (name.isEmpty) {
      _showSnackbar('Name Required', 'Please enter your full name', isError: true);
      return;
    }
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      _showSnackbar('Invalid Email', 'Please enter a valid email address', isError: true);
      return;
    }
    if (password.length < 6) {
      _showSnackbar('Weak Password', 'Password must be at least 6 characters', isError: true);
      return;
    }
    if (password != confirmPassword) {
      _showSnackbar('Password Mismatch', 'Passwords do not match', isError: true);
      return;
    }
    if (!acceptTerms.value) {
      _showSnackbar('Terms Required', 'Please accept the Terms of Service to continue', isError: true);
      return;
    }

    isLoading.value = true;
    PlatformHelper.mediumHaptic();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      final user = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        role: 'ADMIN',
        organizationName: '$name Team',
        token: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      currentUser.value = user;
      await SecureStorageService.to.saveUserData(user.toJson());
      await SecureStorageService.to.saveToken(user.token!);
      await SecureStorageService.to.setIsLoggedIn(true);

      PlatformHelper.heavyHaptic();
      _showSnackbar('Account Created!', 'Welcome to AI RAG ChatBot, $name');

      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      _showSnackbar('Signup Failed', e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPasswordReset() async {
    final email = forgotEmailController.text.trim();
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      _showSnackbar('Invalid Email', 'Please enter a valid email address', isError: true);
      return;
    }

    isLoading.value = true;
    PlatformHelper.mediumHaptic();

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      isResetSent.value = true;
      PlatformHelper.lightHaptic();
      _showSnackbar('Reset Link Sent', 'Check your inbox for password reset instructions');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    PlatformHelper.mediumHaptic();
    isLoading.value = true;
    try {
      await SecureStorageService.to.removeToken();
      await SecureStorageService.to.removeUserData();
      await SecureStorageService.to.setIsLoggedIn(false);
      currentUser.value = null;
      Get.offAllNamed(AppRoutes.login);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? AppColors.error : AppColors.darkCard,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
      duration: const Duration(seconds: 3),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    signupNameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();
    forgotEmailController.dispose();
    super.onClose();
  }
}
