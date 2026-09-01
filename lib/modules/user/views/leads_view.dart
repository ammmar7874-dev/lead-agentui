import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/native/platform_helper.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/user_shared_controller.dart';
import '../models/lead_model.dart';

class LeadsViewController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString selectedFilter = 'ALL'.obs;

  final RxList<LeadModel> allLeads = <LeadModel>[
    LeadModel(
      id: 'lead_1',
      name: 'Robert Fox (Enterprise)',
      email: 'r.fox@logistics-corp.com',
      phone: '+1 (555) 234-8901',
      productOrService: 'Supply Chain Software',
      status: 'QUALIFIED',
      tag: 'ORDER INQUIRY',
      budget: '\$12,000',
      site: 'Excels_Tech Widget',
      capturedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    LeadModel(
      id: 'lead_2',
      name: 'Sarah Jenkins',
      email: 'sarah.j@designerly.io',
      phone: '+1 (555) 876-1234',
      productOrService: 'MVP Development',
      status: 'NEW',
      tag: 'FEATURE REQUEST',
      budget: '\$5,000',
      site: 'Landing Page Chat',
      capturedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    LeadModel(
      id: 'lead_3',
      name: 'Dr. Arthur Campbell',
      email: 'a.campbell@healthtech.org',
      phone: '+1 (555) 432-9876',
      productOrService: 'Healthcare Software',
      status: 'IN_PROGRESS',
      tag: 'ORDER INQUIRY',
      budget: '\$25,000',
      site: 'Excels_Tech Widget',
      capturedAt: DateTime.now().subtract(const Duration(hours: 18)),
    ),
    LeadModel(
      id: 'lead_4',
      name: 'Michael Chang',
      email: 'm.chang@resortsuites.com',
      phone: '+1 (555) 678-3456',
      productOrService: 'Hospitality Software',
      status: 'CLOSED',
      tag: 'ORDER INQUIRY',
      budget: '\$8,500',
      site: 'Main Website Bot',
      capturedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ].obs;

  List<LeadModel> get filteredLeads {
    final filter = selectedFilter.value;
    final query = searchController.text.trim().toLowerCase();

    return allLeads.where((l) {
      final matchesFilter = (filter == 'ALL') || (l.status == filter);
      final matchesQuery = query.isEmpty ||
          l.name.toLowerCase().contains(query) ||
          l.email.toLowerCase().contains(query) ||
          l.productOrService.toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();
  }

  void setFilter(String f) {
    selectedFilter.value = f;
    PlatformHelper.selectionHaptic();
  }

  void exportLeads() {
    PlatformHelper.mediumHaptic();
    Get.snackbar(
      'Export Successful',
      'Downloaded leads_export_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv (${allLeads.length} records)',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

class LeadsView extends StatelessWidget {
  const LeadsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeadsViewController());
    final sharedController = Get.find<UserSharedController>();

    return Obx(() {
      final isDark = sharedController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            Responsive.value(context, mobile: 16, tablet: 24, desktop: 32),
            Responsive.value(context, mobile: 12, tablet: 18, desktop: 24),
            Responsive.value(context, mobile: 16, tablet: 24, desktop: 32),
            Responsive.isMobile(context) ? 110 : 40,
          ),
          child: ResponsiveContainer(
            maxWidth: 1400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Summary Card
                _buildSummaryHeader(controller, isDark),

                const SizedBox(height: 20),

                // Search Bar & Export Button
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: TextField(
                          controller: controller.searchController,
                          onChanged: (_) => controller.allLeads.refresh(),
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search by lead name, email, or service...',
                            hintStyle: TextStyle(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              fontSize: 12,
                            ),
                            prefixIcon: const Icon(Icons.search_rounded, size: 18),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: controller.exportLeads,
                      icon: const Icon(Icons.download_rounded, size: 16),
                      label: const Text('Export CSV', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Filter Chips (ALL, NEW, QUALIFIED, IN_PROGRESS, CLOSED)
                _buildFilterChips(controller, isDark),

                const SizedBox(height: 20),

                // Filtered Leads List/Grid
                _buildResponsiveLeadsList(controller, isDark),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSummaryHeader(LeadsViewController controller, bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
      borderColor: AppColors.primary.withValues(alpha: 0.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLeadStatPill('TOTAL LEADS', '${controller.allLeads.length}', AppColors.secondary, isDark),
          Container(height: 36, width: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          _buildLeadStatPill('NEW INQUIRIES', '1', AppColors.warning, isDark),
          Container(height: 36, width: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          _buildLeadStatPill('EST. VALUE', '\$50,500', AppColors.success, isDark),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildLeadStatPill(String title, String val, Color color, bool isDark) {
    return Column(
      children: [
        Text(val, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(LeadsViewController controller, bool isDark) {
    final filters = ['ALL', 'NEW', 'QUALIFIED', 'IN_PROGRESS', 'CLOSED'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = controller.selectedFilter.value == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                f.replaceAll('_', ' '),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
              selected: isSelected,
              onSelected: (_) => controller.setFilter(f),
              selectedColor: AppColors.primary,
              backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCardHover,
              side: BorderSide(
                color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResponsiveLeadsList(LeadsViewController controller, bool isDark) {
    final leads = controller.filteredLeads;

    if (leads.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(Icons.person_search_rounded, size: 48, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              const SizedBox(height: 12),
              Text('No leads match the selected filter.', style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth >= 900) {
          crossAxisCount = 2;
        }

        if (crossAxisCount == 1) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leads.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lead = leads[index];
              return _buildLeadCard(lead, isDark);
            },
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 170,
          ),
          itemCount: leads.length,
          itemBuilder: (context, index) {
            final lead = leads[index];
            return _buildLeadCard(lead, isDark);
          },
        );
      },
    );
  }

  Widget _buildLeadCard(LeadModel lead, bool isDark) {
    Color statusColor = AppColors.secondary;
    if (lead.status == 'NEW') statusColor = AppColors.warning;
    if (lead.status == 'QUALIFIED') statusColor = AppColors.success;
    if (lead.status == 'CLOSED') statusColor = AppColors.darkTextMuted;

    return CustomCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
      borderColor: statusColor.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.person_rounded, color: statusColor, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lead.name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('MMM dd, yyyy • HH:mm').format(lead.capturedAt),
                            style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              CustomBadge(
                text: lead.status,
                backgroundColor: statusColor.withValues(alpha: 0.15),
                textColor: statusColor,
                fontSize: 10,
              ),
            ],
          ),

          const Divider(height: 14, color: AppColors.darkBorderSubtle),

          // Lead Attributes
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLeadMetaRow(Icons.email_outlined, lead.email, isDark, onCopy: () {
                      Clipboard.setData(ClipboardData(text: lead.email));
                      Get.snackbar('Copied', 'Email copied to clipboard', snackPosition: SnackPosition.BOTTOM);
                    }),
                    const SizedBox(height: 4),
                    _buildLeadMetaRow(Icons.phone_outlined, lead.phone, isDark),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightCardHover,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      lead.budget,
                      style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lead.productOrService,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeadMetaRow(IconData icon, String text, bool isDark, {VoidCallback? onCopy}) {
    return GestureDetector(
      onTap: onCopy,
      child: Row(
        children: [
          Icon(icon, size: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
