import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/user_shared_controller.dart';

class AuditLogItem {
  final String timestamp;
  final String eventType;
  final String userSession;
  final String rule;
  final String actionTaken;

  AuditLogItem({
    required this.timestamp,
    required this.eventType,
    required this.userSession,
    required this.rule,
    required this.actionTaken,
  });
}

class GovernanceView extends StatefulWidget {
  const GovernanceView({super.key});

  @override
  State<GovernanceView> createState() => _GovernanceViewState();
}

class _GovernanceViewState extends State<GovernanceView> {
  final RxBool _piiMasking = true.obs;
  final RxBool _promptInjectionShield = true.obs;
  final RxBool _toxicityFilter = true.obs;
  final RxBool _auditLogging = true.obs;

  final List<AuditLogItem> _auditLogs = [
    AuditLogItem(
      timestamp: 'Aug 27, 2026 10:24 PM',
      eventType: 'PII MASKED',
      userSession: 'sess_wgt_39182',
      rule: 'Email & Phone Regex Filter',
      actionTaken: 'Masked before vector query',
    ),
    AuditLogItem(
      timestamp: 'Aug 27, 2026 08:02 PM',
      eventType: 'PROMPT SHIELD',
      userSession: 'sess_wgt_10928',
      rule: 'System Jailbreak Heuristic',
      actionTaken: 'Blocked & logged safely',
    ),
    AuditLogItem(
      timestamp: 'Aug 26, 2026 02:15 PM',
      eventType: 'DATA RETENTION',
      userSession: 'cron_retention_job',
      rule: '365-day Auto-Purge',
      actionTaken: 'Cleaned expired visitor logs',
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
                'AI Governance & Safety',
                style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 18),
              ),
              Text(
                'Enterprise compliance, PII masking & audit trails',
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
                text: 'SOC2 / HIPAA Compliant',
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
              // Security Policy Controls
              CustomCard(
                padding: const EdgeInsets.all(18),
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active AI Guardrails',
                      style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Real-time protection layers applied to every conversation',
                      style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildPolicySwitch(
                      title: 'Automatic PII Masking',
                      subtitle: 'Redacts credit card numbers, SSNs, and private credentials',
                      value: _piiMasking,
                      isDark: isDark,
                    ),
                    const Divider(height: 16, color: AppColors.darkBorderSubtle),
                    _buildPolicySwitch(
                      title: 'Prompt Injection Defense',
                      subtitle: 'Detects and neutralizes jailbreak attempts and system prompt leaks',
                      value: _promptInjectionShield,
                      isDark: isDark,
                    ),
                    const Divider(height: 16, color: AppColors.darkBorderSubtle),
                    _buildPolicySwitch(
                      title: 'Strict Toxicity & Safety Filters',
                      subtitle: 'Ensures brand safety with zero profane or harmful content',
                      value: _toxicityFilter,
                      isDark: isDark,
                    ),
                    const Divider(height: 16, color: AppColors.darkBorderSubtle),
                    _buildPolicySwitch(
                      title: 'Immutable Audit Logging',
                      subtitle: 'Encrypts and persists all API transactions for compliance audits',
                      value: _auditLogging,
                      isDark: isDark,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 24),

              Text(
                'Security Audit Event Log',
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _auditLogs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final log = _auditLogs[index];

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
                                color: log.eventType == 'PROMPT SHIELD' ? AppColors.errorSoft : AppColors.primarySoft,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                log.eventType,
                                style: TextStyle(
                                  color: log.eventType == 'PROMPT SHIELD' ? AppColors.error : AppColors.primaryLight,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              log.timestamp,
                              style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Rule: ${log.rule}',
                          style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Action: ${log.actionTaken} (${log.userSession})',
                          style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: (index * 60).ms);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPolicySwitch({
    required String title,
    required String subtitle,
    required RxBool value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Obx(
          () => Switch(
            value: value.value,
            onChanged: (val) {
              PlatformHelper.lightHaptic();
              value.value = val;
            },
            activeThumbColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
