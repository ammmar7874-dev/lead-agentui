import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/user_shared_controller.dart';

class EscalationItem {
  final String id;
  final String type;
  final String contact;
  final String notes;
  final String site;
  final RxString status;
  final String date;

  EscalationItem({
    required this.id,
    required this.type,
    required this.contact,
    required this.notes,
    required this.site,
    required String status,
    required this.date,
  }) : status = status.obs;
}

class EscalationsView extends StatefulWidget {
  const EscalationsView({super.key});

  @override
  State<EscalationsView> createState() => _EscalationsViewState();
}

class _EscalationsViewState extends State<EscalationsView> {
  final TextEditingController _searchCtrl = TextEditingController();


  final List<EscalationItem> _escalations = [
    EscalationItem(
      id: 'esc_101',
      type: 'Human Handoff',
      contact: 'david@fintech.co',
      notes: 'Visitor requested live agent regarding custom HIPAA compliance guarantee.',
      site: 'Excels_Tech Widget',
      status: 'Open',
      date: 'Aug 27, 2026 10:15 PM',
    ),
    EscalationItem(
      id: 'esc_102',
      type: 'Support Ticket',
      contact: 'sarah@designhub.io',
      notes: 'Widget failed to render on custom Webflow sub-domain.',
      site: 'aipoweremail',
      status: 'In Progress',
      date: 'Aug 27, 2026 07:30 PM',
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
                'Escalations',
                style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 18),
              ),
              Text(
                'Human handoff requests & support tickets queue',
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
                text: '${_escalations.length} Active',
                backgroundColor: AppColors.errorSoft,
                textColor: AppColors.error,
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
              // 3 Top Stat Cards (From Screenshot 223628)
              Row(
                children: [
                  Expanded(
                    child: _buildMetricBox('1', 'Open', AppColors.primary, isDark),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricBox('1', 'Tickets', const Color(0xFFF59E0B), isDark),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricBox('0', 'Handoffs', const Color(0xFF10B981), isDark),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Search & Filter
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.lightCardHover,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Search by name, email, site...',
                          hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 12),
                          prefixIcon: Icon(Icons.search_rounded, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // List of Escalations
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _escalations.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final esc = _escalations[index];

                  return Obx(() {
                    final status = esc.status.value;
                    final isResolved = status == 'Resolved';

                    return CustomCard(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                      borderColor: isResolved ? AppColors.darkBorderSubtle : AppColors.error.withValues(alpha: 0.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: esc.type == 'Human Handoff' ? AppColors.errorSoft : AppColors.warningSoft,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  esc.type,
                                  style: TextStyle(
                                    color: esc.type == 'Human Handoff' ? AppColors.error : AppColors.warning,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isResolved ? AppColors.successSoft : AppColors.primarySoft,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: isResolved ? AppColors.success : AppColors.primaryLight,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            esc.contact,
                            style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            esc.notes,
                            style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Site: ${esc.site}',
                                style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
                              ),
                              Text(
                                esc.date,
                                style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (!isResolved)
                                ElevatedButton.icon(
                                  onPressed: () {
                                    PlatformHelper.lightHaptic();
                                    esc.status.value = 'Resolved';
                                    Get.snackbar('Resolved', 'Escalation marked as completed', snackPosition: SnackPosition.BOTTOM);
                                  },
                                  icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                                  label: const Text('Mark Resolved', style: TextStyle(fontSize: 12)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.success,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  Widget _buildMetricBox(String value, String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
