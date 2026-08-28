import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_social_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController controller = Get.find<AuthController>();
  String? _emailError;
  String? _passwordError;

  void _validateAndLogin() {
    final email = controller.emailController.text.trim();
    final password = controller.passwordController.text.trim();

    setState(() {
      _emailError = (email.isEmpty || !GetUtils.isEmail(email))
          ? 'Please enter a valid work email'
          : null;
      _passwordError = password.length < 6
          ? 'Password must be at least 6 characters'
          : null;
    });

    if (_emailError == null && _passwordError == null) {
      controller.login();
    } else {
      PlatformHelper.lightHaptic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1: Top Hero Brand Mascot with Glowing Halo
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 26,
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
                    .moveY(begin: 0, end: -6, duration: 2000.ms, curve: Curves.easeInOut),

                const SizedBox(height: 18),

                // 2: Title & Subtitle
                Text(
                  'Welcome Back',
                  style: AppTextStyles.displaySmall(isDark: true, color: Colors.white).copyWith(fontSize: 26),
                ).animate().fadeIn(duration: 400.ms).moveY(begin: 10, end: 0),

                const SizedBox(height: 4),

                Text(
                  'Sign in to access your AI RAG workspace',
                  style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.darkTextSecondary),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                const SizedBox(height: 28),

                // 3: Form Card Container (Element placement from reference screenshot)
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: AppColors.darkCard,
                  borderColor: AppColors.darkBorder,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Input
                      CustomTextField(
                        label: 'Email',
                        hint: 'you@company.com',
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.mail_outline_rounded, color: AppColors.primaryLight),
                        onChanged: (_) {
                          if (_emailError != null) setState(() => _emailError = null);
                        },
                      ),

                      if (_emailError != null) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            _emailError!,
                            style: const TextStyle(color: AppColors.error, fontSize: 11.5, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Password Input
                      CustomTextField(
                        label: 'Password',
                        hint: '••••••••',
                        controller: controller.passwordController,
                        isPassword: true,
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.darkTextMuted),
                        onChanged: (_) {
                          if (_passwordError != null) setState(() => _passwordError = null);
                        },
                      ),

                      if (_passwordError != null) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            _passwordError!,
                            style: const TextStyle(color: AppColors.error, fontSize: 11.5, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],

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

                      const SizedBox(height: 8),

                      // Sign In Button
                      Obx(
                        () => CustomButton(
                          text: 'Sign In',
                          icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                          isLoading: controller.isLoading.value,
                          onPressed: _validateAndLogin,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 150.ms).scale(begin: const Offset(0.98, 0.98)),

                const SizedBox(height: 24),

                // 4: "OR CONTINUE WITH" Divider
                const Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.darkBorder, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'OR CONTINUE WITH',
                        style: TextStyle(
                          color: AppColors.darkTextMuted,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.darkBorder, thickness: 1)),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                const SizedBox(height: 20),

                // 5: Google & Apple Social Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomSocialButton(
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
                      child: CustomSocialButton(
                        label: 'Apple',
                        onPressed: () {
                          PlatformHelper.lightHaptic();
                          controller.signInWithApple();
                        },
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 250.ms),

                const SizedBox(height: 24),

                // 6: Create Account Switch Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.darkTextSecondary),
                    ),
                    GestureDetector(
                      onTap: () {
                        PlatformHelper.lightHaptic();
                        Get.toNamed(AppRoutes.signup);
                      },
                      child: Row(
                        children: [
                          Text(
                            'Create Account',
                            style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.primaryLight)
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 3),
                          const Icon(Icons.arrow_forward_rounded, color: AppColors.primaryLight, size: 14),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                const SizedBox(height: 18),

                // 7: Footer (Privacy Policy · Terms · Support)
                Text(
                  'Privacy Policy   Terms   Support',
                  style: AppTextStyles.bodySmall(isDark: true, color: AppColors.darkTextMuted),
                ).animate().fadeIn(duration: 400.ms, delay: 350.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
