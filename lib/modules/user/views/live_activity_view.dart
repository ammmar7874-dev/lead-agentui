import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/animated_stat_counter.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/user_shared_controller.dart';

class LiveEventItem {
  final String icon;
  final String title;
  final String description;
  final String time;
  final Color color;

  LiveEventItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    required this.color,
  });
}

class LiveActivityView extends StatelessWidget {
  const LiveActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedController = Get.find<UserSharedController>();

    final List<LiveEventItem> events = [
      LiveEventItem(
        icon: '💬',
        title: 'New Chat Inquiry Started',
        description: 'Anonymous #8f921 opened widget on /pricing',
        time: 'Just now',
        color: AppColors.primary,
      ),
      LiveEventItem(
        icon: '🎯',
        title: 'Lead Captured',
        description: 'info@univenture.work requested Basic Plan details',
        time: '2m ago',
        color: AppColors.success,
      ),
      LiveEventItem(
        icon: '🌐',
        title: 'Visitor Arrived from Google',
        description: 'New session started from United States on /dashboard',
        time: '4m ago',
        color: AppColors.secondary,
      ),
      LiveEventItem(
        icon: '⚡',
        title: 'Vector Search Query',
        description: 'Retrieved 3 knowledge chunks (Pinecone: 38ms)',
        time: '6m ago',
        color: const Color(0xFFF59E0B),
      ),
      LiveEventItem(
        icon: '⭐',
        title: '5-Star Feedback Received',
        description: 'Visitor #1092 rated response: "Accurate & Fast"',
        time: '12m ago',
        color: const Color(0xFFFBBF24),
      ),
    ];

    return Obx(() {
      final isDark = sharedController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Get.back(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Live Activity Stream',
                style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 18),
              ),
              Text(
                'Real-time traffic telemetry and user interactions',
                style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CustomBadge(
                text: 'LIVE',
                isPulsing: true,
                backgroundColor: AppColors.successSoft,
                textColor: AppColors.success,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Live Active Users Card
              CustomCard(
                padding: const EdgeInsets.all(20),
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1.15, 1.15),
                              duration: 1500.ms,
                            ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.radar_rounded, color: Colors.white, size: 24),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AnimatedStatCounter(
                              value: 25,
                              style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 26, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Active Visitors Right Now',
                              style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Streaming live across 3 deployed website widgets',
                          style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 20),

              // Country Breakdown Chips
              Text(
                'Active Traffic Locations',
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildLocationChip('🇺🇸 United States (12)', isDark),
                  _buildLocationChip('🇬🇧 United Kingdom (5)', isDark),
                  _buildLocationChip('🇵🇰 Pakistan (4)', isDark),
                  _buildLocationChip('🇩🇪 Germany (2)', isDark),
                  _buildLocationChip('🇨🇦 Canada (2)', isDark),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                'Real-Time Telemetry Feed',
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final event = events[index];

                  return CustomCard(
                    padding: const EdgeInsets.all(14),
                    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: event.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(event.icon, style: const TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    event.title,
                                    style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  Text(
                                    event.time,
                                    style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 10),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                event.description,
                                style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLocationChip(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
      ),
      child: Text(
        label,
        style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
