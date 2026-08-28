import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/knowledge_controller.dart';
import '../controllers/user_shared_controller.dart';

class SyncJobsView extends StatelessWidget {
  const SyncJobsView({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedController = Get.find<UserSharedController>();
    final knowledgeController = Get.find<KnowledgeController>();

    return Obx(() {
      final isDark = sharedController.isDarkMode.value;
      final jobs = knowledgeController.syncJobs;

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
            'Sync Jobs History',
            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.sync_rounded,
                size: 22,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              onPressed: () {
                PlatformHelper.lightHaptic();
                if (knowledgeController.sources.isNotEmpty) {
                  knowledgeController.triggerSync(knowledgeController.sources.first.id);
                }
              },
              tooltip: 'Trigger Sync',
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Stats Card
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile('100', 'Total Syncs', AppColors.primary, isDark),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricTile('100%', 'Success Rate', AppColors.success, isDark),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricTile('4.2s', 'Avg Duration', AppColors.secondary, isDark),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sync Execution Logs',
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                  ),
                  CustomBadge(
                    text: 'Auto-Sync Every 6h',
                    backgroundColor: AppColors.primarySoft,
                    textColor: AppColors.primaryLight,
                    fontSize: 10,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Sync Jobs List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: jobs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  final isCompleted = job.status.toLowerCase() == 'succeeded' || job.status.toLowerCase() == 'completed';

                  return CustomCard(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isCompleted ? AppColors.successSoft : AppColors.warningSoft,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                job.status.toUpperCase(),
                                style: TextStyle(
                                  color: isCompleted ? AppColors.success : AppColors.warning,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '${job.executedAt.hour}:${job.executedAt.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          job.sourceTitle,
                          style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${job.chunks} chunks vectorized • Duration: ${job.duration}',
                          style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, fontSize: 12),
                        ),
                        if (!isCompleted) ...[
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              minHeight: 4,
                            ),
                          ),
                        ],
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

  Widget _buildMetricTile(String value, String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
