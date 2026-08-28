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
  final String publicId;
  final int origins;
  final String design;
  final RxBool isActive;

  WidgetSiteModel({
    required this.name,
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
  final List<WidgetSiteModel> _sites = [
    WidgetSiteModel(
      name: 'Excels_Tech Widget',
      publicId: 'pub_cmmqn81rb0021gxk',
      origins: 36,
      design: 'Legacy/default v0',
      isActive: true,
    ),
    WidgetSiteModel(
      name: 'aipoweremail',
      publicId: 'wgt_0ugHMAu_idwp_vXA',
      origins: 37,
      design: 'Legacy/default v0',
      isActive: false,
    ),
    WidgetSiteModel(
      name: 'Branding Test',
      publicId: 'wgt_branding_test',
      origins: 37,
      design: 'Legacy/default v0',
      isActive: false,
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
                'Widget Manager',
                style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 18),
              ),
              Text(
                'Manage embeddable widgets & multi-site configurations',
                style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with "+ New Site" button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language_rounded, size: 22, color: AppColors.primaryLight),
                      const SizedBox(width: 8),
                      Text(
                        'Widget Sites',
                        style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showNewSiteDialog(context, isDark),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('New site', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Widget Sites List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _sites.length,
                separatorBuilder: (context, index) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final site = _sites[index];

                  return Obx(() {
                    final active = site.isActive.value;

                    return CustomCard(
                      padding: const EdgeInsets.all(18),
                      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                      borderColor: active ? AppColors.primary.withValues(alpha: 0.4) : AppColors.darkBorderSubtle,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                site.name,
                                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: active ? AppColors.successSoft : AppColors.darkBorderSubtle,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  active ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    color: active ? AppColors.success : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Public ID Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : AppColors.lightCardHover,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Public ID: ',
                                  style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
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
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Text(
                                'Origins: ${site.origins}',
                                style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 12),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Design: ${site.design}',
                                style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 12),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          const Divider(height: 1, color: AppColors.darkBorderSubtle),
                          const SizedBox(height: 12),

                          // Action Buttons
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
                                color: active ? AppColors.error : AppColors.success,
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
                },
              ),
            ],
          ),
        ),
      );
    });
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
      icon: Icon(icon, size: 14, color: color ?? (isPrimary ? AppColors.primaryLight : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary))),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color ?? (isPrimary ? AppColors.primaryLight : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.primarySoft : Colors.transparent,
        side: BorderSide(
          color: color?.withValues(alpha: 0.5) ?? (isPrimary ? AppColors.primary.withValues(alpha: 0.5) : (isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Add New Widget Site', style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(controller: nameCtrl, hint: 'e.g. My SaaS Store', label: 'Site Name'),
              const SizedBox(height: 12),
              CustomTextField(controller: urlCtrl, hint: 'https://mysaas.com', label: 'Domain URL'),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  setState(() {
                    _sites.add(
                      WidgetSiteModel(
                        name: nameCtrl.text.trim(),
                        publicId: 'pub_${DateTime.now().millisecondsSinceEpoch}',
                        origins: 1,
                        design: 'Legacy/default v0',
                        isActive: true,
                      ),
                    );
                  });
                  Get.back();
                  Get.snackbar('Success', 'New widget site added!', snackPosition: SnackPosition.BOTTOM);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
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
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                  Text('Widget Embed Code', style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Get.back()),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Copy and paste this script right before the closing </body> tag on ${site.name}',
                style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 12),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.lightCardHover,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        snippet,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: AppColors.primaryLight),
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
