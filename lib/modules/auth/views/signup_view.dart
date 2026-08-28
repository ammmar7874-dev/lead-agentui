import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../widgets/custom_auth_background.dart';
import '../../../widgets/custom_social_button.dart';
import '../controllers/auth_controller.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final AuthController controller = Get.find<AuthController>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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
      body: CustomAuthBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Glowing Squircle App Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF38BDF8), Color(0xFF6366F1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.mark_email_read_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(begin: const Offset(0.96, 0.96), end: const Offset(1.02, 1.02), duration: 2200.ms),

                const SizedBox(height: 16),

                // Title & Subtitle
                const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Inter',
                  ),
                ).animate().fadeIn(duration: 400.ms).moveY(begin: 10, end: 0),

                const SizedBox(height: 4),

                const Text(
                  'Get started with your AI Power Email account',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                const SizedBox(height: 22),

                // White Elevated Card Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      const Text(
                        'Full Name',
                        style: TextStyle(color: Color(0xFF334155), fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _nameError != null ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0),
                            width: 1.2,
                          ),
                        ),
                        child: TextField(
                          controller: controller.signupNameController,
                          onChanged: (_) {
                            if (_nameError != null) setState(() => _nameError = null);
                          },
                          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                            hintText: 'John Doe',
                            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                            prefixIcon: Icon(Icons.person_outline_rounded, color: Color(0xFF475569), size: 19),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      if (_nameError != null) ...[
                        const SizedBox(height: 4),
                        Text(_nameError!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 11)),
                      ],

                      const SizedBox(height: 12),

                      // Email
                      const Text(
                        'Email',
                        style: TextStyle(color: Color(0xFF334155), fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _emailError != null ? const Color(0xFFEF4444) : const Color(0xFF38BDF8),
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: controller.signupEmailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) {
                            if (_emailError != null) setState(() => _emailError = null);
                          },
                          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                            hintText: 'you@company.com',
                            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                            prefixIcon: Icon(Icons.mail_outline_rounded, color: Color(0xFF0EA5E9), size: 19),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      if (_emailError != null) ...[
                        const SizedBox(height: 4),
                        Text(_emailError!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 11)),
                      ],

                      const SizedBox(height: 12),

                      // Password
                      const Text(
                        'Password',
                        style: TextStyle(color: Color(0xFF334155), fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _passwordError != null ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0),
                            width: 1.2,
                          ),
                        ),
                        child: TextField(
                          controller: controller.signupPasswordController,
                          obscureText: _obscurePassword,
                          onChanged: (_) {
                            if (_passwordError != null) setState(() => _passwordError = null);
                          },
                          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                            prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF475569), size: 19),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: const Color(0xFF64748B),
                                size: 19,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      if (_passwordError != null) ...[
                        const SizedBox(height: 4),
                        Text(_passwordError!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 11)),
                      ],

                      const SizedBox(height: 12),

                      // Confirm Password
                      const Text(
                        'Confirm Password',
                        style: TextStyle(color: Color(0xFF334155), fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _confirmPasswordError != null ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0),
                            width: 1.2,
                          ),
                        ),
                        child: TextField(
                          controller: controller.signupConfirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          onChanged: (_) {
                            if (_confirmPasswordError != null) setState(() => _confirmPasswordError = null);
                          },
                          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                            prefixIcon: const Icon(Icons.lock_reset_rounded, color: Color(0xFF475569), size: 19),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: const Color(0xFF64748B),
                                size: 19,
                              ),
                              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      if (_confirmPasswordError != null) ...[
                        const SizedBox(height: 4),
                        Text(_confirmPasswordError!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 11)),
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
                                  color: controller.acceptTerms.value ? const Color(0xFF38BDF8) : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: controller.acceptTerms.value ? const Color(0xFF38BDF8) : const Color(0xFFCBD5E1),
                                    width: 1.5,
                                  ),
                                ),
                                child: controller.acceptTerms.value
                                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'I agree to the Terms of Service & Privacy Policy',
                                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Create Account Button
                      Obx(
                        () => Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF38BDF8), Color(0xFF6366F1)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: controller.isLoading.value ? null : _validateAndSignup,
                              child: Center(
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2),
                                      )
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Create Account',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 17),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 150.ms).scale(begin: const Offset(0.98, 0.98)),

                const SizedBox(height: 20),

                // "OR SIGN UP WITH" Divider
                const Row(
                  children: [
                    Expanded(child: Divider(color: Color(0xFFCBD5E1), thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'OR SIGN UP WITH',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Color(0xFFCBD5E1), thickness: 1)),
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
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Color(0xFF475569), fontSize: 13.5, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () {
                        PlatformHelper.lightHaptic();
                        Get.back();
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              color: Color(0xFF0EA5E9),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.arrow_forward_rounded, color: Color(0xFF0EA5E9), size: 14),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                const SizedBox(height: 14),

                // Footer (Privacy Policy · Terms · Support)
                const Text(
                  'Privacy Policy   Terms   Support',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 350.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
