import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // PageView Content
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),

                        // 3D Illustration Hero Card with Floating Animation
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
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
                                  Icons.smart_toy_rounded,
                                  color: AppColors.primary,
                                  size: 80,
                                ),
                              ),
                            ),
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .moveY(begin: 0, end: -6, duration: 2200.ms, curve: Curves.easeInOut),

                        const SizedBox(height: 28),

                        // Step Pill Badge (Placement from screenshot)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            item.stepNumber,
                            style: AppTextStyles.labelMedium(isDark: true, color: AppColors.primaryLight)
                                .copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.8, fontSize: 11),
                          ),
                        ).animate().fadeIn(duration: 350.ms).scale(begin: const Offset(0.9, 0.9)),

                        const SizedBox(height: 18),

                        // Title with Highlighted Word
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: item.title,
                            style: AppTextStyles.displaySmall(isDark: true, color: Colors.white).copyWith(fontSize: 24),
                            children: [
                              TextSpan(
                                text: item.highlightWord,
                                style: AppTextStyles.displaySmall(
                                  isDark: true,
                                  color: AppColors.primaryLight,
                                ).copyWith(fontSize: 24),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                        const SizedBox(height: 12),

                        // Description
                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium(
                            isDark: true,
                            color: AppColors.darkTextSecondary,
                          ).copyWith(fontSize: 13.5, height: 1.5),
                        ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

                        const SizedBox(height: 18),

                        // Feature Badges
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: item.featureBadges.map((badge) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.darkCard,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.darkBorder, width: 0.8),
                              ),
                              child: Text(
                                badge,
                                style: const TextStyle(
                                  color: AppColors.darkTextPrimary,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation Controls (Placement matching reference screenshot)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
              child: Column(
                children: [
                  // Page Indicators
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.items.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 6,
                          width: controller.currentPage.value == index ? 22 : 6,
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

                  const SizedBox(height: 20),

                  // Primary Button (Continue → / Get Started →)
                  Obx(
                    () => CustomButton(
                      text: controller.isLastPage ? 'Get Started' : 'Continue',
                      icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                      onPressed: () {
                        PlatformHelper.lightHaptic();
                        controller.nextPage();
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Secondary Button (Skip ⏭) positioned at bottom
                  Obx(
                    () => AnimatedOpacity(
                      opacity: controller.isLastPage ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.darkCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.darkBorder, width: 1.2),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: controller.isLastPage
                                ? null
                                : () {
                                    PlatformHelper.lightHaptic();
                                    controller.finishOnboarding();
                                  },
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Skip',
                                    style: TextStyle(
                                      color: AppColors.darkTextPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(Icons.skip_next_rounded, color: AppColors.darkTextPrimary, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ),
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
