import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/animated_stat_counter.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/user_shared_controller.dart';
import 'messages_analytics_view.dart';
import 'transcripts_view.dart';
import 'visitors_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedController = Get.find<UserSharedController>();

    return Obx(() {
      final isDark = sharedController.isDarkMode.value;

      return RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        color: AppColors.primary,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1: Hero Welcome Banner with 3D Mascot & Live Visitors Stat
              _buildHeroWelcomeCard(isDark, sharedController),

              const SizedBox(height: 20),

              // 2: Section Header for Statistics Overview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Real-Time Analytics',
                    style: AppTextStyles.titleLarge(isDark: isDark),
                  ),
                  CustomBadge(
                    text: 'Updated Just Now',
                    backgroundColor: AppColors.primarySoft,
                    textColor: AppColors.primaryLight,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    fontSize: 10,
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 12),

              // 3: 5 Animated Stat Cards Grid (Horizontal scroll / 2-column layout)
              _buildStatCardsGrid(isDark),

              const SizedBox(height: 24),

              // 4: Weekly Conversations Interactive Bar Chart (fl_chart)
              _buildWeeklyConversationsChartCard(isDark),

              const SizedBox(height: 24),

              // 5: Recent Leads & Live Visitor Activity Stream
              _buildRecentLeadsPreviewCard(isDark, sharedController),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeroWelcomeCard(bool isDark, UserSharedController sharedController) {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
      borderColor: AppColors.primary.withValues(alpha: 0.3),
      child: Row(
        children: [
          // 3D Mascot Avatar with glowing aura
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.1, 1.1),
                    duration: 2000.ms,
                  ),
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/bot_mascot.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI RAG Agent Active',
                  style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '12 connected knowledge sources are indexed and live.',
                  style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.successSoft,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '25 live on site',
                            style: AppTextStyles.labelSmall(color: AppColors.success).copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => sharedController.switchTab(1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.chat_bubble_outline, size: 12, color: AppColors.primaryLight),
                            const SizedBox(width: 4),
                            Text(
                              'Test Chat',
                              style: AppTextStyles.labelSmall(color: AppColors.primaryLight)
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).moveY(begin: 10, end: 0);
  }

  Widget _buildStatCardsGrid(bool isDark) {
    final metrics = controller.statMetrics;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final item = metrics[index];

        return GestureDetector(
          onTap: () {
            PlatformHelper.lightHaptic();
            final titleLower = item.title.toLowerCase();
            if (titleLower.contains('visitor')) {
              Get.to(() => const VisitorsView());
            } else if (titleLower.contains('conversation')) {
              Get.to(() => const TranscriptsView());
            } else if (titleLower.contains('message')) {
              Get.to(() => const MessagesAnalyticsView());
            } else if (titleLower.contains('lead')) {
              Get.find<UserSharedController>().switchTab(3); // Leads Tab
            } else if (titleLower.contains('source') || titleLower.contains('knowledge')) {
              Get.find<UserSharedController>().switchTab(2); // Sources Tab
            }
          },
          child: CustomCard(
            padding: const EdgeInsets.all(14),
            backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
            borderColor: item.color.withValues(alpha: 0.25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item.icon, size: 18, color: item.color),
                    ),
                    if (item.trend != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.successSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.trend!,
                          style: const TextStyle(
                            color: AppColors.success,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedStatCounter(
                      value: item.value,
                      style: AppTextStyles.titleLarge(isDark: isDark).copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.title,
                      style: AppTextStyles.labelSmall(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ).copyWith(fontSize: 10, letterSpacing: 0.5, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: (index * 60).ms).scale(begin: const Offset(0.95, 0.95));
      },
    );
  }

  Widget _buildWeeklyConversationsChartCard(bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
      borderColor: AppColors.darkBorderSubtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conversations This Week',
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '7 total sessions across 7 days',
                    style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondarySoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '7 Days',
                  style: AppTextStyles.labelSmall(color: AppColors.secondaryLight).copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Bar Chart
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 5,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.darkSurface,
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.round()} Chats\n${controller.weekDays[group.x.toInt()]}',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 1,
                      getTitlesWidget: (val, meta) {
                        if (val % 2 == 0) {
                          return Text(
                            val.toInt().toString(),
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              fontSize: 10,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        final index = val.toInt();
                        if (index >= 0 && index < controller.weekDays.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              controller.weekDays[index],
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  controller.weeklyConversationCounts.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: controller.weeklyConversationCounts[index],
                        width: 18,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryLight, AppColors.primary],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 5,
                          color: isDark ? AppColors.darkSurface : AppColors.lightCardHover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }


  Widget _buildRecentLeadsPreviewCard(bool isDark, UserSharedController sharedController) {
    return CustomCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest Captured Leads',
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Automatic AI conversation extractions',
                    style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => sharedController.switchTab(3), // switch to leads tab
                child: Text(
                  'View All',
                  style: AppTextStyles.labelMedium(color: AppColors.primaryLight).copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildLeadItem(
            name: 'Robert Fox (Enterprise)',
            email: 'r.fox@logistics-corp.com',
            service: 'Supply Chain Software',
            budget: '\$12,000',
            tag: 'QUALIFIED',
            isDark: isDark,
          ),
          const Divider(height: 16, color: AppColors.darkBorderSubtle),
          _buildLeadItem(
            name: 'Sarah Jenkins',
            email: 'sarah.j@designerly.io',
            service: 'MVP Development',
            budget: '\$5,000',
            tag: 'NEW',
            isDark: isDark,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms);
  }

  Widget _buildLeadItem({
    required String name,
    required String email,
    required String service,
    required String budget,
    required String tag,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.secondarySoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.person_rounded, color: AppColors.secondaryLight, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                '$service • $budget',
                style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: tag == 'NEW' ? AppColors.warningSoft : AppColors.successSoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tag,
            style: TextStyle(
              color: tag == 'NEW' ? AppColors.warning : AppColors.success,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
