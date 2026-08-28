import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1: Top Hero Brand Header with 3D Bot Avatar
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/bot_mascot.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.smart_toy_rounded,
                              color: AppColors.primary,
                              size: 48,
                            ),
                          ),
                        ),
                      )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .moveY(begin: 0, end: -6, duration: 1800.ms, curve: Curves.easeInOut),
                      const SizedBox(height: 16),
                      Text(
                        'AI RAG ChatBot',
                        style: AppTextStyles.displaySmall(isDark: true, color: Colors.white),
                      ).animate().fadeIn(duration: 400.ms).moveY(begin: 10, end: 0),
                      const SizedBox(height: 4),
                      Text(
                        'Enterprise-grade conversational AI',
                        style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.darkTextSecondary),
                      ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // 2: Feature Bullets Card (From Web Screenshot)
                CustomCard(
                  padding: const EdgeInsets.all(14),
                  backgroundColor: AppColors.darkCard.withValues(alpha: 0.7),
                  child: Column(
                    children: [
                      _buildFeatureRow(
                        icon: '🧠',
                        title: 'RAG-powered answers from your documents',
                      ),
                      const Divider(height: 16, color: AppColors.darkBorderSubtle),
                      _buildFeatureRow(
                        icon: '📊',
                        title: 'Real-time visitor analytics & lead capture',
                      ),
                      const Divider(height: 16, color: AppColors.darkBorderSubtle),
                      _buildFeatureRow(
                        icon: '🔒',
                        title: 'Enterprise security with MFA & SSO',
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms, delay: 150.ms).scale(begin: const Offset(0.96, 0.96)),

                const SizedBox(height: 28),

                // 3: Form Card
                Text(
                  'Welcome Back',
                  style: AppTextStyles.titleLarge(isDark: true, color: Colors.white),
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                const SizedBox(height: 4),
                Text(
                  'Login to access your bot workspace',
                  style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.darkTextMuted),
                ).animate().fadeIn(duration: 400.ms, delay: 250.ms),

                const SizedBox(height: 20),

                // Email Input
                CustomTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms).moveX(begin: -10, end: 0),

                const SizedBox(height: 16),

                // Password Input
                CustomTextField(
                  label: 'Password',
                  hint: 'Your password',
                  controller: controller.passwordController,
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                ).animate().fadeIn(duration: 400.ms, delay: 350.ms).moveX(begin: -10, end: 0),

                const SizedBox(height: 8),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                    child: Text(
                      'Forgot password?',
                      style: AppTextStyles.bodySmall(isDark: true, color: AppColors.secondaryLight),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 4: Login Action Button
                Obx(
                  () => CustomButton(
                    text: 'Login',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.login,
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),

                const SizedBox(height: 24),

                // 5: Switch to Sign Up
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.darkTextSecondary),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.signup),
                        child: Text(
                          'Create Account',
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
      ),
    );
  }

  Widget _buildFeatureRow({required String icon, required String title}) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.darkBorder, width: 0.8),
          ),
          child: Text(icon, style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.darkTextPrimary)
                .copyWith(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
