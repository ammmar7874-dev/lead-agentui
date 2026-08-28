import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_social_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/auth_controller.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final AuthController controller = Get.find<AuthController>();
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  void _validateAndSignup() {
    final name = controller.signupNameController.text.trim();
    final email = controller.signupEmailController.text.trim();
    final password = controller.signupPasswordController.text.trim();
    final confirmPassword = controller.signupConfirmPasswordController.text.trim();

    setState(() {
      _nameError = name.isEmpty ? 'Please enter your name' : null;
      _emailError = (email.isEmpty || !GetUtils.isEmail(email))
          ? 'Please enter a valid work email'
          : null;
      _passwordError = password.length < 6
          ? 'Password must be at least 6 characters'
          : null;
      _confirmPasswordError = password != confirmPassword
          ? 'Passwords do not match'
          : null;
    });

    if (_nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null) {
      controller.signup();
    } else {
      PlatformHelper.lightHaptic();
    }
  }

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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Hero Brand Mascot
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 22,
                        offset: const Offset(0, 4),
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
                        size: 38,
                      ),
                    ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: 0, end: -5, duration: 2000.ms, curve: Curves.easeInOut),

                const SizedBox(height: 14),

                // Title & Subtitle
                Text(
                  'Create Account',
                  style: AppTextStyles.displaySmall(isDark: true, color: Colors.white).copyWith(fontSize: 26),
                ).animate().fadeIn(duration: 400.ms).moveY(begin: 10, end: 0),

                const SizedBox(height: 4),

                Text(
                  'Get started with your AI RAG ChatBot workspace',
                  style: AppTextStyles.bodyMedium(isDark: true, color: AppColors.darkTextSecondary),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                const SizedBox(height: 22),

                // White/Dark Form Card Container
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: AppColors.darkCard,
                  borderColor: AppColors.darkBorder,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      CustomTextField(
                        label: 'Full Name',
                        hint: 'John Doe',
                        controller: controller.signupNameController,
                        prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.darkTextMuted),
                        onChanged: (_) {
                          if (_nameError != null) setState(() => _nameError = null);
                        },
                      ),
                      if (_nameError != null) ...[
                        const SizedBox(height: 4),
                        Text(_nameError!, style: const TextStyle(color: AppColors.error, fontSize: 11)),
                      ],

                      const SizedBox(height: 12),

                      // Email
                      CustomTextField(
                        label: 'Email',
                        hint: 'you@company.com',
                        controller: controller.signupEmailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.mail_outline_rounded, color: AppColors.primaryLight),
                        onChanged: (_) {
                          if (_emailError != null) setState(() => _emailError = null);
                        },
                      ),
                      if (_emailError != null) ...[
                        const SizedBox(height: 4),
                        Text(_emailError!, style: const TextStyle(color: AppColors.error, fontSize: 11)),
                      ],

                      const SizedBox(height: 12),

                      // Password
                      CustomTextField(
                        label: 'Password',
                        hint: '••••••••',
                        controller: controller.signupPasswordController,
                        isPassword: true,
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.darkTextMuted),
                        onChanged: (_) {
                          if (_passwordError != null) setState(() => _passwordError = null);
                        },
                      ),
                      if (_passwordError != null) ...[
                        const SizedBox(height: 4),
                        Text(_passwordError!, style: const TextStyle(color: AppColors.error, fontSize: 11)),
                      ],

                      const SizedBox(height: 12),

                      // Confirm Password
                      CustomTextField(
                        label: 'Confirm Password',
                        hint: '••••••••',
                        controller: controller.signupConfirmPasswordController,
                        isPassword: true,
                        prefixIcon: const Icon(Icons.lock_reset_rounded, color: AppColors.darkTextMuted),
                        onChanged: (_) {
                          if (_confirmPasswordError != null) setState(() => _confirmPasswordError = null);
                        },
                      ),
                      if (_confirmPasswordError != null) ...[
                        const SizedBox(height: 4),
                        Text(_confirmPasswordError!, style: const TextStyle(color: AppColors.error, fontSize: 11)),
                      ],

                      const SizedBox(height: 14),

                      // Terms & Conditions Checkbox
                      Obx(
                        () => GestureDetector(
                          onTap: () {
                            PlatformHelper.lightHaptic();
                            controller.acceptTerms.toggle();
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: controller.acceptTerms.value ? AppColors.primary : AppColors.darkSurface,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: controller.acceptTerms.value ? AppColors.primary : AppColors.darkBorder,
                                    width: 1.5,
                                  ),
                                ),
                                child: controller.acceptTerms.value
                                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'I agree to the Terms of Service & Privacy Policy',
                                  style: AppTextStyles.bodySmall(isDark: true, color: AppColors.darkTextSecondary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Create Account Button
                      Obx(
                        () => CustomButton(
                          text: 'Create Account',
                          icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                          isLoading: controller.isLoading.value,
                          onPressed: _validateAndSignup,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 150.ms).scale(begin: const Offset(0.98, 0.98)),

                const SizedBox(height: 20),

                // "OR SIGN UP WITH" Divider
                const Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.darkBorder, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'OR SIGN UP WITH',
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

                const SizedBox(height: 16),

                // Google & Apple Social Buttons
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

                const SizedBox(height: 20),

                // Sign In Link
                Row(
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
                      child: Row(
                        children: [
                          Text(
                            'Sign In',
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

                const SizedBox(height: 14),

                // Footer (Privacy Policy · Terms · Support)
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
