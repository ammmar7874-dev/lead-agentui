import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/animated_stat_counter.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/user_shared_controller.dart';

class MessagesAnalyticsView extends StatefulWidget {
  const MessagesAnalyticsView({super.key});

  @override
  State<MessagesAnalyticsView> createState() => _MessagesAnalyticsViewState();
}

class _MessagesAnalyticsViewState extends State<MessagesAnalyticsView> {
  final String _selectedRange = '7 Days';

  @override
  Widget build(BuildContext context) {
    final sharedController = Get.find<UserSharedController>();

    return Obx(() {
      final isDark = sharedController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Messages Analytics',
            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                size: 22,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              onPressed: () {
                PlatformHelper.lightHaptic();
                Get.snackbar('Refreshed', 'Telemetry metrics updated', snackPosition: SnackPosition.BOTTOM);
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 4 Stat Cards
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile('Total Messages', 168, Icons.mark_chat_read_rounded, AppColors.primary, isDark),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile('Avg Latency', 180, Icons.speed_rounded, AppColors.secondary, isDark, suffix: 'ms'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile('AI Responses', 84, Icons.smart_toy_rounded, AppColors.success, isDark),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile('Visitor Queries', 84, Icons.person_search_rounded, AppColors.warning, isDark),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Hourly Message Activity Line Chart
              CustomCard(
                padding: const EdgeInsets.all(18),
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Exchanged Messages Volume',
                          style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _selectedRange,
                            style: const TextStyle(color: AppColors.primaryLight, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Message throughput over last 7 days',
                      style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 180,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 10,
                            getDrawingHorizontalLine: (val) => FlLine(
                              color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                              strokeWidth: 1,
                            ),
                          ),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                interval: 10,
                                getTitlesWidget: (val, meta) => Text(
                                  val.toInt().toString(),
                                  style: TextStyle(
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (val, meta) {
                                  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                  final idx = val.toInt();
                                  if (idx >= 0 && idx < days.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        days[idx],
                                        style: TextStyle(
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                          fontSize: 10,
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
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              color: AppColors.primary,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary.withValues(alpha: 0.3),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              spots: const [
                                FlSpot(0, 12),
                                FlSpot(1, 24),
                                FlSpot(2, 18),
                                FlSpot(3, 35),
                                FlSpot(4, 42),
                                FlSpot(5, 20),
                                FlSpot(6, 17),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 24),

              // Top Inquired Categories
              Text(
                'Top Visitor Topic Inquiries',
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              _buildTopicProgress('Pricing & Enterprise Plans', 0.42, '71 inquiries', AppColors.primary, isDark),
              const SizedBox(height: 10),
              _buildTopicProgress('Custom RAG & Vector Integrations', 0.28, '47 inquiries', AppColors.secondary, isDark),
              const SizedBox(height: 10),
              _buildTopicProgress('Website Embed Widget Installation', 0.18, '30 inquiries', AppColors.success, isDark),
              const SizedBox(height: 10),
              _buildTopicProgress('Refunds & Cancellation Policy', 0.12, '20 inquiries', AppColors.warning, isDark),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMetricTile(String title, int value, IconData icon, Color color, bool isDark, {String suffix = ''}) {
    return CustomCard(
      padding: const EdgeInsets.all(14),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
      borderColor: color.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              AnimatedStatCounter(
                value: value,
                style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (suffix.isNotEmpty)
                Text(
                  ' $suffix',
                  style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 13),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicProgress(String topic, double progress, String count, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                topic,
                style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Text(
                count,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightCardHover,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
