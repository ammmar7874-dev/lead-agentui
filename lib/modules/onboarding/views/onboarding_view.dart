import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../widgets/custom_auth_background.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomAuthBackground(
        child: Column(
          children: [
            const SizedBox(height: 20),

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
                        const SizedBox(height: 10),

                        // Center Glow Hero Badge with Satellite Floating Badges
                        _buildHeroAvatar(item.mainIcon),

                        const SizedBox(height: 32),

                        // Step Pill Badge (e.g. 01 · AUTOMATION)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFBAE6FD), width: 1),
                          ),
                          child: Text(
                            item.stepNumber,
                            style: const TextStyle(
                              color: Color(0xFF0284C7),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              fontSize: 11,
                            ),
                          ),
                        ).animate().fadeIn(duration: 350.ms).scale(begin: const Offset(0.9, 0.9)),

                        const SizedBox(height: 18),

                        // Title with Blue + Navy Words
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: item.titlePrefix,
                            style: const TextStyle(
                              color: Color(0xFF0EA5E9),
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Inter',
                              height: 1.25,
                            ),
                            children: [
                              TextSpan(
                                text: item.titleSuffix,
                                style: const TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Inter',
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                        const SizedBox(height: 12),

                        // Subtitle in Sky Blue
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF0284C7),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

                        const SizedBox(height: 14),

                        // Paragraph Description
                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 13.5,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                        const SizedBox(height: 20),

                        // Feature Pills Chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: item.featureBadges.map((badge) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDF5FF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFD4E6FA), width: 1),
                              ),
                              child: Text(
                                badge,
                                style: const TextStyle(
                                  color: Color(0xFF0369A1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation Controls with Page Indicators and Buttons
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
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Primary Button (Continue → / Get Started →)
                  Obx(
                    () => Container(
                      width: double.infinity,
                      height: 52,
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
                          onTap: () {
                            PlatformHelper.lightHaptic();
                            controller.nextPage();
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.isLastPage ? 'Get Started' : 'Continue',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Skip Button (Outlined / Soft Rounded Container)
                  Obx(
                    () => AnimatedOpacity(
                      opacity: controller.isLastPage ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF5FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFD4E6FA), width: 1.2),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
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
                                      color: Color(0xFF0F172A),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(Icons.skip_next_rounded, color: Color(0xFF0F172A), size: 18),
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

  Widget _buildHeroAvatar(IconData mainIcon) {
    return SizedBox(
      width: 170,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center Big Glow Ring
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF38BDF8), Color(0xFF0EA5E9), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.45),
                  blurRadius: 28,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 92,
                height: 92,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF0B132B),
                ),
                child: Center(
                  child: Icon(
                    mainIcon,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.96, 0.96), end: const Offset(1.02, 1.02), duration: 2000.ms),

          // Satellite 1: Top Right (Sparkle)
          Positioned(
            top: 6,
            right: 18,
            child: _buildSatelliteBadge(Icons.auto_awesome, const Color(0xFF38BDF8))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: 0, end: -5, duration: 1600.ms),
          ),

          // Satellite 2: Top Left (Check/Mail)
          Positioned(
            top: 10,
            left: 20,
            child: _buildSatelliteBadge(Icons.mark_email_read_rounded, const Color(0xFF0EA5E9))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: 0, end: -4, duration: 1900.ms),
          ),

          // Satellite 3: Bottom Left (Send)
          Positioned(
            bottom: 12,
            left: 14,
            child: _buildSatelliteBadge(Icons.send_rounded, const Color(0xFF0284C7))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: 0, end: 4, duration: 1700.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildSatelliteBadge(IconData icon, Color color) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}
