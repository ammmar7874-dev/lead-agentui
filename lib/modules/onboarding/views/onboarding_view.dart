import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => controller.finishOnboarding(),
            child: Text(
              'Skip',
              style: AppTextStyles.labelMedium(
                isDark: true,
                color: AppColors.darkTextMuted,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // PageView with 3D Illustrations
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            item.badgeText,
                            style: AppTextStyles.labelMedium(isDark: true, color: AppColors.primaryLight)
                                .copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5, fontSize: 11),
                          ),
                        ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),

                        const SizedBox(height: 24),

                        // 3D Illustration Card with Floating Animation
                        Container(
                          height: 280,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.18),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.darkCard,
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: AppColors.primary,
                                  size: 80,
                                ),
                              ),
                            ),
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .moveY(begin: 0, end: -8, duration: 2200.ms, curve: Curves.easeInOut),

                        const SizedBox(height: 32),

                        // Title with Highlighted Word
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: item.title,
                            style: AppTextStyles.displaySmall(isDark: true, color: Colors.white),
                            children: [
                              TextSpan(
                                text: item.highlightWord,
                                style: AppTextStyles.displaySmall(
                                  isDark: true,
                                  color: AppColors.primaryLight,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 500.ms, delay: 100.ms).moveY(begin: 10, end: 0),

                        const SizedBox(height: 12),

                        // Description
                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium(
                            isDark: true,
                            color: AppColors.darkTextSecondary,
                          ),
                        ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation Controls
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Row(
                children: [
                  // Animated Page Indicator Pills
                  Obx(
                    () => Row(
                      children: List.generate(
                        controller.items.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 6),
                          height: 8,
                          width: controller.currentPage.value == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == index
                                ? AppColors.primary
                                : AppColors.darkCard,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Next / Get Started Button
                  Obx(
                    () => SizedBox(
                      width: controller.isLastPage ? 160 : 60,
                      height: 52,
                      child: CustomButton(
                        text: controller.isLastPage ? 'Get Started' : '',
                        icon: controller.isLastPage
                            ? const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18)
                            : const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                        onPressed: controller.nextPage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
