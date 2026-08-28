import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Background subtle ambient radial glow
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Central Animated Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1 & 2: 3D Mascot with Pulsing Halo & Floating Animation
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Halo glow
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 36,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1.15, 1.15),
                          duration: 2000.ms,
                          curve: Curves.easeInOut,
                        ),

                    // 3D Mascot Image
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/bot_mascot.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppColors.darkCard,
                            child: const Icon(
                              Icons.smart_toy_rounded,
                              color: AppColors.primary,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveY(
                          begin: 0,
                          end: -12,
                          duration: 1800.ms,
                          curve: Curves.easeInOut,
                        ),
                  ],
                ),

                const SizedBox(height: 32),

                // 3: App Name with Staggered Slide & Fade
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'AI RAG ',
                      style: AppTextStyles.displayMedium(
                        isDark: true,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'ChatBot',
                      style: AppTextStyles.displayMedium(
                        isDark: true,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 800.ms, delay: 200.ms)
                    .moveY(begin: 15, end: 0, duration: 800.ms, curve: Curves.easeOutCubic),

                const SizedBox(height: 8),

                // 4: Subtitle Tagline
                Text(
                  'Train AI on your business. Capture leads 24/7.',
                  style: AppTextStyles.bodyMedium(
                    isDark: true,
                    color: AppColors.darkTextSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 800.ms, delay: 400.ms)
                    .moveY(begin: 10, end: 0, duration: 800.ms),

                const SizedBox(height: 48),

                // 5: Animated Status and Loading Bar
                SizedBox(
                  width: 220,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          minHeight: 4,
                          backgroundColor: AppColors.darkCard,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => Text(
                          controller.statusText.value,
                          style: AppTextStyles.bodySmall(
                            isDark: true,
                            color: AppColors.darkTextMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
              ],
            ),
          ),

          // Bottom Version Info
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'v1.0.0 • Enterprise Edition',
                style: AppTextStyles.bodySmall(
                  isDark: true,
                  color: AppColors.darkTextMuted.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
