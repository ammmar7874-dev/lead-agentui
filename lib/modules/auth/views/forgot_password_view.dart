import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Header
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: const Icon(
                  Icons.lock_reset_rounded,
                  color: AppColors.primaryLight,
                  size: 32,
                ),
              ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),

              const SizedBox(height: 24),

              Text(
                'Reset Password',
                style: AppTextStyles.displaySmall(isDark: true, color: Colors.white),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms).moveY(begin: 10, end: 0),

              const SizedBox(height: 8),

              Text(
                'Enter the email address associated with your account and we will send you instructions to reset your password.',
                style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.darkTextSecondary),
              ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

              const SizedBox(height: 32),

              Obx(() {
                if (controller.isResetSent.value) {
                  return CustomCard(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: AppColors.successSoft,
                    borderColor: AppColors.success.withValues(alpha: 0.4),
                    child: Column(
                      children: [
                        const Icon(Icons.mark_email_read_outlined, color: AppColors.success, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          'Check Your Inbox',
                          style: AppTextStyles.titleMedium(isDark: true, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'We sent a reset link to ${controller.forgotEmailController.text}. Follow the instructions to reset your password.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.darkTextSecondary),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Back to Login',
                          isOutlined: true,
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
                }

                return Column(
                  children: [
                    CustomTextField(
                      label: 'Email',
                      hint: 'you@example.com',
                      controller: controller.forgotEmailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                    const SizedBox(height: 24),

                    CustomButton(
                      text: 'Send Reset Link',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.sendPasswordReset,
                    ).animate().fadeIn(duration: 400.ms, delay: 250.ms).scale(begin: const Offset(0.95, 0.95)),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
