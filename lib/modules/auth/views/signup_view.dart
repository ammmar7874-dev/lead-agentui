import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/auth_controller.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () {
            PlatformHelper.lightHaptic();
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Create Account',
                style: AppTextStyles.displaySmall(isDark: true, color: Colors.white).copyWith(fontSize: 24),
              ).animate().fadeIn(duration: 400.ms).moveY(begin: 10, end: 0),
              const SizedBox(height: 4),
              Text(
                'Get started with your custom AI knowledge agent',
                style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.darkTextSecondary),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

              const SizedBox(height: 24),

              // Social Sign Ups (Google & Apple)
              Row(
                children: [
                  Expanded(
                    child: _buildSocialButton(
                      icon: Icons.g_mobiledata_rounded,
                      label: 'Google',
                      isGoogle: true,
                      onPressed: () {
                        PlatformHelper.lightHaptic();
                        controller.signInWithGoogle();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSocialButton(
                      icon: Icons.apple_rounded,
                      label: 'Apple',
                      onPressed: () {
                        PlatformHelper.lightHaptic();
                        controller.signInWithApple();
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

              const SizedBox(height: 20),

              // "OR SIGN UP WITH EMAIL" Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.darkBorderSubtle, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'OR SIGN UP WITH EMAIL',
                      style: TextStyle(
                        color: AppColors.darkTextMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.darkBorderSubtle, thickness: 1)),
                ],
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

              const SizedBox(height: 20),

              // Full Name
              CustomTextField(
                label: 'Name',
                hint: 'Your full name',
                controller: controller.signupNameController,
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ).animate().fadeIn(duration: 400.ms, delay: 250.ms),

              const SizedBox(height: 14),

              // Email
              CustomTextField(
                label: 'Email',
                hint: 'you@example.com',
                controller: controller.signupEmailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

              const SizedBox(height: 14),

              // Password
              CustomTextField(
                label: 'Password',
                hint: 'Choose a strong password',
                controller: controller.signupPasswordController,
                isPassword: true,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
              ).animate().fadeIn(duration: 400.ms, delay: 350.ms),

              const SizedBox(height: 14),

              // Confirm Password
              CustomTextField(
                label: 'Confirm Password',
                hint: 'Re-enter your password',
                controller: controller.signupConfirmPasswordController,
                isPassword: true,
                prefixIcon: const Icon(Icons.lock_reset_rounded),
              ).animate().fadeIn(duration: 400.ms, delay: 400.ms),

              const SizedBox(height: 16),

              // Terms & Conditions Checkbox
              Obx(
                () => GestureDetector(
                  onTap: () {
                    PlatformHelper.lightHaptic();
                    controller.acceptTerms.toggle();
                  },
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: controller.acceptTerms.value ? AppColors.primary : AppColors.darkCard,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: controller.acceptTerms.value ? AppColors.primary : AppColors.darkBorder,
                            width: 1.5,
                          ),
                        ),
                        child: controller.acceptTerms.value
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'I agree to the Terms of Service & Privacy Policy',
                          style: AppTextStyles.bodySmall(isDark: true, color: AppColors.darkTextSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 450.ms),

              const SizedBox(height: 20),

              // Create Account Button
              Obx(
                () => CustomButton(
                  text: 'Create Account',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.signup,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 500.ms).scale(begin: const Offset(0.95, 0.95)),

              const SizedBox(height: 20),

              // Switch to Login
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.darkTextSecondary),
                    ),
                    GestureDetector(
                      onTap: () {
                        PlatformHelper.lightHaptic();
                        Get.back();
                      },
                      child: Text(
                        'Sign In',
                        style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.primaryLight)
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 550.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isGoogle = false,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorderSubtle, width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isGoogle)
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    'G',
                    style: TextStyle(
                      color: Color(0xFF4285F4),
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                )
              else
                Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
