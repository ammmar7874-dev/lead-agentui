import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/animated_stat_counter.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/user_shared_controller.dart';

class TokenUsageView extends StatelessWidget {
  const TokenUsageView({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedController = Get.find<UserSharedController>();

    return Obx(() {
      final isDark = sharedController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Get.back(),
          ),
          title: Text('Token Usage & Analytics', style: AppTextStyles.titleMedium(isDark: isDark)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1: Monthly Token Consumption Progress Card
              _buildConsumptionBanner(isDark),

              const SizedBox(height: 20),

              // 2: Daily Token Analytics Line Chart
              _buildDailyTokenChartCard(isDark),

              const SizedBox(height: 20),

              // 3: Model Breakdown Distribution
              _buildModelBreakdownCard(isDark),

              const SizedBox(height: 20),

              // 4: API Keys Management Card
              _buildApiKeysCard(isDark),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildConsumptionBanner(bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
      borderColor: AppColors.primary.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Monthly Allocation', style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
              CustomBadge(
                text: 'Enterprise Tier',
                backgroundColor: AppColors.primarySoft,
                textColor: AppColors.primaryLight,
                fontSize: 10,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedStatCounter(
                    value: 184200,
                    style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tokens used of 500,000 limit',
                    style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  ),
                ],
              ),
              Text(
                '36.8%',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.368,
              minHeight: 8,
              backgroundColor: AppColors.darkBorderSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildDailyTokenChartCard(bool isDark) {
    final spots = const [
      FlSpot(0, 12),
      FlSpot(1, 18),
      FlSpot(2, 14),
      FlSpot(3, 32),
      FlSpot(4, 28),
      FlSpot(5, 45),
      FlSpot(6, 35),
    ];
    final days = ['Fri', 'Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu'];

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
                  Text('Daily Token Volume (k)', style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text('Last 7 days consumption curve', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                ],
              ),
              CustomBadge(
                text: 'Avg 26.3k/day',
                backgroundColor: AppColors.secondarySoft,
                textColor: AppColors.secondaryLight,
                fontSize: 10,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 20,
                      getTitlesWidget: (val, meta) => Text(
                        '${val.toInt()}k',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        final i = val.toInt();
                        if (i >= 0 && i < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              days[i],
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
                    spots: spots,
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
                          AppColors.primary.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
  }

  Widget _buildModelBreakdownCard(bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Model Distribution', style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildModelRow('GPT-4o (RAG Generation)', '142,000 tokens', '77.1%', AppColors.primary, isDark),
          const Divider(height: 16, color: AppColors.darkBorderSubtle),
          _buildModelRow('text-embedding-3-small', '32,200 tokens', '17.4%', AppColors.secondary, isDark),
          const Divider(height: 16, color: AppColors.darkBorderSubtle),
          _buildModelRow('Claude 3.5 Sonnet (Fallback)', '10,000 tokens', '5.5%', AppColors.success, isDark),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }

  Widget _buildModelRow(String name, String tokens, String pct, Color color, bool isDark) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ),
        Text(
          tokens,
          style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
        ),
        const SizedBox(width: 8),
        Text(
          pct,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildApiKeysCard(bool isDark) {
    const key = 'sk_live_rag_8f93j2091jd09j2389fdj23';

    return CustomCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('API Keys', style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.primaryLight),
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: key));
                  Get.snackbar('Copied', 'API Key copied to clipboard', snackPosition: SnackPosition.BOTTOM);
                },
                tooltip: 'Copy API Key',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightCardHover,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.key_rounded, size: 16, color: AppColors.warning),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'sk_live_••••••••••••••••fdj23',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
                CustomBadge(
                  text: 'Active',
                  backgroundColor: AppColors.successSoft,
                  textColor: AppColors.success,
                  fontSize: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
