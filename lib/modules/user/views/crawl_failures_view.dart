import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/user_shared_controller.dart';

class CrawlFailureModel {
  final String url;
  final String errorCode;
  final String reason;
  final int retryCount;
  final String lastAttempt;
  final RxString status;

  CrawlFailureModel({
    required this.url,
    required this.errorCode,
    required this.reason,
    required this.retryCount,
    required this.lastAttempt,
    required String status,
  }) : status = status.obs;
}

class CrawlFailuresView extends StatefulWidget {
  const CrawlFailuresView({super.key});

  @override
  State<CrawlFailuresView> createState() => _CrawlFailuresViewState();
}

class _CrawlFailuresViewState extends State<CrawlFailuresView> {
  final List<CrawlFailureModel> _failures = [
    CrawlFailureModel(
      url: 'https://excelstech.ai/old-pricing-v1',
      errorCode: '404',
      reason: 'Page Not Found / Dead Link',
      retryCount: 3,
      lastAttempt: 'Aug 27, 2026 11:20 PM',
      status: 'IGNORED',
    ),
    CrawlFailureModel(
      url: 'https://excelstech.ai/admin/private-portal',
      errorCode: '403',
      reason: 'Protected Behind Cloudflare Authentication',
      retryCount: 2,
      lastAttempt: 'Aug 26, 2026 09:12 PM',
      status: 'BLOCKED',
    ),
  ];

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
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Get.back(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Crawl Failures',
                style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 18),
              ),
              Text(
                'Website crawler diagnostics & 404/403 URL errors',
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
                text: '0 Critical',
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
              // Summary Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.primaryLight, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'The crawler automatically ignores 404s and respects robots.txt restrictions. You can manually retry or exclude specific endpoints.',
                        style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 20),

              Text(
                'Recorded Crawl Exceptions',
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _failures.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _failures[index];

                  return Obx(() {
                    final status = item.status.value;
                    final isResolved = status == 'RESOLVED';

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
                                  color: AppColors.errorSoft,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'HTTP ${item.errorCode}',
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isResolved ? AppColors.successSoft : AppColors.darkBorderSubtle,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: isResolved ? AppColors.success : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.url,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.primaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Reason: ${item.reason}',
                            style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Retries: ${item.retryCount} • Last: ${item.lastAttempt}',
                            style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  PlatformHelper.lightHaptic();
                                  item.status.value = 'RESOLVED';
                                  Get.snackbar('Crawled', 'URL retry scheduled successfully', snackPosition: SnackPosition.BOTTOM);
                                },
                                icon: const Icon(Icons.refresh_rounded, size: 14),
                                label: const Text('Retry Crawl', style: TextStyle(fontSize: 11)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
