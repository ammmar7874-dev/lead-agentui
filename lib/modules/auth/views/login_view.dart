import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
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
                // Top Hero Brand Header with 3D Bot Avatar
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
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
                              size: 44,
                            ),
                          ),
                        ),
                      )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .moveY(begin: 0, end: -6, duration: 1800.ms, curve: Curves.easeInOut),
                      const SizedBox(height: 16),
                      Text(
                        'AI ChatBot Platform',
                        style: AppTextStyles.displaySmall(isDark: true, color: Colors.white).copyWith(fontSize: 24),
                      ).animate().fadeIn(duration: 400.ms).moveY(begin: 10, end: 0),
                      const SizedBox(height: 4),
                      Text(
                        'Sign in to manage your AI agents and knowledge base',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.darkTextSecondary),
                      ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Social Logins (Google & Apple)
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

                const SizedBox(height: 24),

                // "OR CONTINUE WITH EMAIL" Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.darkBorderSubtle, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'OR CONTINUE WITH EMAIL',
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

                const SizedBox(height: 24),

                // Email Input
                CustomTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                ).animate().fadeIn(duration: 400.ms, delay: 250.ms).moveX(begin: -10, end: 0),

                const SizedBox(height: 16),

                // Password Input
                CustomTextField(
                  label: 'Password',
                  hint: 'Your password',
                  controller: controller.passwordController,
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms).moveX(begin: -10, end: 0),

                const SizedBox(height: 8),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                    child: Text(
                      'Forgot password?',
                      style: AppTextStyles.bodySmall(isDark: true, color: AppColors.primaryLight),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Login Action Button
                Obx(
                  () => CustomButton(
                    text: 'Sign In',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.login,
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 350.ms).scale(begin: const Offset(0.95, 0.95)),

                const SizedBox(height: 24),

                // Switch to Sign Up
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
                ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
              ],
            ),
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
