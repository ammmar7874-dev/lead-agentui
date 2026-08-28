import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/user_shared_controller.dart';

class WidgetSiteModel {
  final String name;
  final String domain;
  final String publicId;
  final int origins;
  final String design;
  final RxBool isActive;

  WidgetSiteModel({
    required this.name,
    required this.domain,
    required this.publicId,
    required this.origins,
    required this.design,
    required bool isActive,
  }) : isActive = isActive.obs;
}

class WidgetManagerView extends StatefulWidget {
  const WidgetManagerView({super.key});

  @override
  State<WidgetManagerView> createState() => _WidgetManagerViewState();
}

class _WidgetManagerViewState extends State<WidgetManagerView> {
  final TextEditingController _searchController = TextEditingController();
  final RxString _selectedFilter = 'all'.obs;

  final List<WidgetSiteModel> _sites = [
    WidgetSiteModel(
      name: 'Excels_Tech Widget',
      domain: 'excelstech.ai',
      publicId: 'pub_cmmqn81rb0021gxk',
      origins: 36,
      design: 'Production v1.2',
      isActive: true,
    ),
    WidgetSiteModel(
      name: 'aipoweremail',
      domain: 'aipoweremail.com',
      publicId: 'wgt_0ugHMAu_idwp_vXA',
      origins: 37,
      design: 'Legacy/default v0',
      isActive: false,
    ),
    WidgetSiteModel(
      name: 'Branding Test',
      domain: 'staging.excelscrm.com',
      publicId: 'wgt_branding_test_99x',
      origins: 12,
      design: 'Preview Beta',
      isActive: false,
    ),
  ];

  List<WidgetSiteModel> get _filteredSites {
    final query = _searchController.text.trim().toLowerCase();
    return _sites.where((site) {
      final matchesQuery = query.isEmpty ||
          site.name.toLowerCase().contains(query) ||
          site.domain.toLowerCase().contains(query) ||
          site.publicId.toLowerCase().contains(query);

      if (!matchesQuery) return false;

      if (_selectedFilter.value == 'active') return site.isActive.value;
      if (_selectedFilter.value == 'inactive') return !site.isActive.value;
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            'Widget Manager',
            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add_rounded,
                size: 24,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              onPressed: () => _showNewSiteDialog(context, isDark),
              tooltip: 'Add Site',
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1: Top Metrics Grid
              _buildMetricsOverview(isDark),

              const SizedBox(height: 20),

              // 2: Header & "+ New Site" Action Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language_rounded, size: 20, color: AppColors.primaryLight),
                      const SizedBox(width: 8),
                      Text(
                        'Widget Sites (${_sites.length})',
                        style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showNewSiteDialog(context, isDark),
                    icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                    label: const Text(
                      'New site',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 3: Search & Filter Chips Row
              _buildSearchAndFilters(isDark),

              const SizedBox(height: 16),

              // 4: Widget Sites List
              if (_filteredSites.isEmpty)
                _buildEmptyState(isDark)
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredSites.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final site = _filteredSites[index];
                    return _buildSiteCard(context, site, isDark);
                  },
                ),
            ],
          ),
        ),
      );
    });
  }

  // ==========================================
  // METRICS OVERVIEW (3 Glass Cards)
  // ==========================================
  Widget _buildMetricsOverview(bool isDark) {
    final activeCount = _sites.where((s) => s.isActive.value).length;
    final totalOrigins = _sites.fold<int>(0, (sum, s) => sum + s.origins);

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Managed Sites',
            value: '${_sites.length}',
            subtitle: '$activeCount active',
            icon: Icons.language_rounded,
            color: AppColors.primaryLight,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Origins Allowed',
            value: '$totalOrigins',
            subtitle: 'Auto whitelisted',
            icon: Icons.security_rounded,
            color: const Color(0xFF0284C7),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Live Uptime',
            value: '99.9%',
            subtitle: 'Edge CDN',
            icon: Icons.speed_rounded,
            color: const Color(0xFF16A34A),
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return CustomCard(
      padding: const EdgeInsets.all(14),
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SEARCH & FILTER CHIPS
  // ==========================================
  Widget _buildSearchAndFilters(bool isDark) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          decoration: InputDecoration(
            hintText: 'Search site name, domain, or key...',
            hintStyle: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
            prefixIcon: const Icon(Icons.search_rounded, size: 18),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 16),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                : null,
            filled: true,
            fillColor: isDark ? AppColors.darkCard : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB))),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildFilterChip('all', 'All (${_sites.length})', isDark),
            const SizedBox(width: 8),
            _buildFilterChip('active', 'Active (${_sites.where((s) => s.isActive.value).length})', isDark),
            const SizedBox(width: 8),
            _buildFilterChip('inactive', 'Inactive (${_sites.where((s) => !s.isActive.value).length})', isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String key, String label, bool isDark) {
    final isSelected = _selectedFilter.value == key;

    return GestureDetector(
      onTap: () {
        PlatformHelper.selectionHaptic();
        _selectedFilter.value = key;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primary : AppColors.primary)
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : (isDark ? AppColors.darkTextSecondary : const Color(0xFF4B5563)),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SITE CARD
  // ==========================================
  Widget _buildSiteCard(BuildContext context, WidgetSiteModel site, bool isDark) {
    return Obx(() {
      final active = site.isActive.value;

      return CustomCard(
        padding: const EdgeInsets.all(18),
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        borderColor: active ? AppColors.primary.withValues(alpha: 0.4) : (isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Site Header Row: Globe, Name, Domain, Status Badge
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primarySoft : (isDark ? AppColors.darkSurface : const Color(0xFFF3F4F6)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.language_rounded, size: 20, color: active ? AppColors.primaryLight : Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        site.name,
                        style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        site.domain,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextMuted : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFFDCFCE7) : (isDark ? AppColors.darkSurface : const Color(0xFFF3F4F6)),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? const Color(0xFF16A34A).withValues(alpha: 0.3) : (isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB)),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active ? const Color(0xFF16A34A) : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        active ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: active ? const Color(0xFF16A34A) : (isDark ? AppColors.darkTextMuted : const Color(0xFF6B7280)),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Public ID Pill with One-Click Copy
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: site.publicId));
                PlatformHelper.lightHaptic();
                Get.snackbar('Copied', 'Public Key copied to clipboard', snackPosition: SnackPosition.BOTTOM);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Public ID: ',
                      style: TextStyle(color: isDark ? AppColors.darkTextMuted : const Color(0xFF6B7280), fontSize: 11),
                    ),
                    Text(
                      site.publicId,
                      style: const TextStyle(
                        color: AppColors.primaryLight,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.copy_rounded, size: 12, color: AppColors.primaryLight),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Origins & Design Engine Info Badges
            Row(
              children: [
                _buildInfoBadge(Icons.security_rounded, '${site.origins} Allowed Origins', isDark),
                const SizedBox(width: 10),
                _buildInfoBadge(Icons.layers_outlined, site.design, isDark),
              ],
            ),

            const SizedBox(height: 16),
            Divider(height: 1, color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB)),
            const SizedBox(height: 12),

            // Action Toolbar
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildActionBtn(
                  icon: Icons.code_rounded,
                  label: 'Embed Code',
                  onPressed: () => _showEmbedDialog(context, site, isDark),
                  isDark: isDark,
                ),
                _buildActionBtn(
                  icon: Icons.publish_rounded,
                  label: 'Publish Design',
                  isPrimary: true,
                  onPressed: () {
                    PlatformHelper.lightHaptic();
                    Get.snackbar('Published', '${site.name} design published live!', snackPosition: SnackPosition.BOTTOM);
                  },
                  isDark: isDark,
                ),
                _buildActionBtn(
                  icon: Icons.refresh_rounded,
                  label: 'Rotate Key',
                  onPressed: () {
                    PlatformHelper.lightHaptic();
                    Get.snackbar('Key Rotated', 'New public key assigned to ${site.name}', snackPosition: SnackPosition.BOTTOM);
                  },
                  isDark: isDark,
                ),
                _buildActionBtn(
                  icon: active ? Icons.power_settings_new_rounded : Icons.check_circle_outline_rounded,
                  label: active ? 'Deactivate' : 'Activate',
                  color: active ? AppColors.error : const Color(0xFF16A34A),
                  onPressed: () {
                    PlatformHelper.lightHaptic();
                    site.isActive.toggle();
                  },
                  isDark: isDark,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoBadge(IconData icon, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: isDark ? AppColors.darkTextMuted : const Color(0xFF6B7280)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextMuted : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isDark,
    bool isPrimary = false,
    Color? color,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 13,
        color: color ?? (isPrimary ? AppColors.primaryLight : (isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2937))),
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color ?? (isPrimary ? AppColors.primaryLight : (isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2937))),
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.primarySoft : Colors.transparent,
        side: BorderSide(
          color: color?.withValues(alpha: 0.5) ?? (isPrimary ? AppColors.primary.withValues(alpha: 0.5) : (isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB))),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 40, color: isDark ? AppColors.darkTextMuted : Colors.grey),
            const SizedBox(height: 12),
            Text(
              'No widget sites found',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              'Try changing your search query or filter chip',
              style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewSiteDialog(BuildContext context, bool isDark) {
    final nameCtrl = TextEditingController();
    final urlCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Add New Widget Site',
            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: nameCtrl,
                hint: 'e.g. My SaaS Store',
                label: 'Site Name',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: urlCtrl,
                hint: 'https://mysaas.com',
                label: 'Domain URL',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  setState(() {
                    _sites.add(
                      WidgetSiteModel(
                        name: nameCtrl.text.trim(),
                        domain: urlCtrl.text.isNotEmpty ? urlCtrl.text.trim() : 'custom.app',
                        publicId: 'pub_${DateTime.now().millisecondsSinceEpoch}',
                        origins: 1,
                        design: 'Production v1.2',
                        isActive: true,
                      ),
                    );
                  });
                  Get.back();
                  Get.snackbar('Success', 'New widget site added!', snackPosition: SnackPosition.BOTTOM);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create Site'),
            ),
          ],
        );
      },
    );
  }

  void _showEmbedDialog(BuildContext context, WidgetSiteModel site, bool isDark) {
    final snippet = '<script src="https://airagchatbot.com/widget.js" data-org="${site.publicId}"></script>';

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('📑', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Widget Embed Code',
                        style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Copy and paste this script right before the closing </body> tag on ${site.name}',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextMuted : const Color(0xFF4B5563),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        snippet,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, color: AppColors.primaryLight, size: 20),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: snippet));
                        Get.snackbar('Copied', 'Embed snippet copied to clipboard', snackPosition: SnackPosition.BOTTOM);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(text: 'Done', onPressed: () => Get.back()),
            ],
          ),
        );
      },
    );
  }
}
