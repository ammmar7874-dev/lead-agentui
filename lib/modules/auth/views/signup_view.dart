import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
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
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Get Started',
                style: AppTextStyles.displaySmall(isDark: true, color: Colors.white),
              ).animate().fadeIn(duration: 400.ms).moveY(begin: 10, end: 0),
              const SizedBox(height: 4),
              Text(
                'Create your organization workspace to continue',
                style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.darkTextSecondary),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

              const SizedBox(height: 24),

              // Full Name
              CustomTextField(
                label: 'Name',
                hint: 'Your full name',
                controller: controller.signupNameController,
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

              const SizedBox(height: 16),

              // Email
              CustomTextField(
                label: 'Email',
                hint: 'you@example.com',
                controller: controller.signupEmailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

              const SizedBox(height: 16),

              // Password
              CustomTextField(
                label: 'Password',
                hint: 'Choose a strong password',
                controller: controller.signupPasswordController,
                isPassword: true,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
              ).animate().fadeIn(duration: 400.ms, delay: 250.ms),

              const SizedBox(height: 16),

              // Confirm Password
              CustomTextField(
                label: 'Confirm Password',
                hint: 'Re-enter your password',
                controller: controller.signupConfirmPasswordController,
                isPassword: true,
                prefixIcon: const Icon(Icons.lock_reset_rounded),
              ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

              const SizedBox(height: 18),

              // Terms & Conditions Checkbox
              Obx(
                () => GestureDetector(
                  onTap: () => controller.acceptTerms.toggle(),
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
              ).animate().fadeIn(duration: 400.ms, delay: 350.ms),

              const SizedBox(height: 24),

              // Create Account Button
              Obx(
                () => CustomButton(
                  text: 'Create Account',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.signup,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),

              const SizedBox(height: 24),

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
                      onTap: () => Get.back(),
                      child: Text(
                        'Login',
                        style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.primaryLight)
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 450.ms),
            ],
          ),
        ),
      ),
    );
  }
}
