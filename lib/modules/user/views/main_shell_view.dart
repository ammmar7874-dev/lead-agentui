import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_badge.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/knowledge_controller.dart';
import '../controllers/user_shared_controller.dart';
import 'bot_settings_view.dart';
import 'chat_view.dart';
import 'dashboard_view.dart';
import 'knowledge_sources_view.dart';
import 'leads_view.dart';
import 'profile_view.dart';
import 'token_usage_view.dart';

class MainShellView extends GetView<UserSharedController> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final currentTab = controller.currentTabIndex.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        drawer: _buildSideDrawer(context, authController, isDark),
        appBar: _buildTopAppBar(context, isDark),
        body: IndexedStack(
          index: currentTab,
          children: const [
            DashboardView(),
            ChatView(),
            KnowledgeSourcesView(),
            LeadsView(),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: _buildFloatingBottomBar(isDark),
      );
    });
  }

  PreferredSizeWidget _buildTopAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu_rounded, size: 24),
          onPressed: () {
            PlatformHelper.lightHaptic();
            Scaffold.of(ctx).openDrawer();
          },
        ),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.5),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/bot_mascot.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.smart_toy_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Excels Tech RAG',
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 1),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Bot Online • v2.4',
                    style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                      fontSize: 10,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Live Data Pulse Pill
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: CustomBadge(
            text: 'Live Data',
            isPulsing: true,
            backgroundColor: AppColors.successSoft,
            textColor: AppColors.success,
            borderColor: AppColors.success.withValues(alpha: 0.3),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            fontSize: 10,
          ),
        ),
        const SizedBox(width: 6),
        // Theme toggle quick button
        IconButton(
          icon: Icon(
            controller.isDarkMode.value ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            size: 20,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
          onPressed: controller.toggleTheme,
          tooltip: 'Toggle Theme',
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  Widget _buildFloatingBottomBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            (isDark ? AppColors.darkBackground : AppColors.lightBackground).withValues(alpha: 0.8),
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
          ],
        ),
      ),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface.withValues(alpha: 0.92) : AppColors.lightSurface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? AppColors.darkBorder.withValues(alpha: 0.6) : AppColors.lightBorder,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.dashboard_rounded, Icons.dashboard_outlined, 'Dashboard', isDark),
            _buildNavItem(1, Icons.chat_bubble_rounded, Icons.chat_bubble_outline_rounded, 'RAG Chat', isDark),
            _buildNavItem(2, Icons.folder_special_rounded, Icons.folder_special_outlined, 'Sources', isDark),
            _buildNavItem(3, Icons.people_alt_rounded, Icons.people_alt_outlined, 'Leads', isDark, badgeCount: 3),
            _buildNavItem(4, Icons.settings_suggest_rounded, Icons.settings_suggest_outlined, 'Settings', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label, bool isDark, {int? badgeCount}) {
    final isSelected = controller.currentTabIndex.value == index;

    return GestureDetector(
      onTap: () => controller.switchTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  color: isSelected
                      ? AppColors.primaryLight
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  size: 22,
                ),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primaryLight
                    : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideDrawer(BuildContext context, AuthController authController, bool isDark) {
    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header with 3D Mascot & Workspace Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/bot_mascot.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI RAG Platform',
                          style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Enterprise Plan • Active',
                          style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Modules Scroll List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  _buildDrawerSectionTitle('CORE MODULES', isDark),
                  _buildDrawerTile(
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard Overview',
                    onTap: () => controller.navigateFromDrawer('dashboard'),
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.forum_outlined,
                    title: 'Live RAG AI Chat',
                    onTap: () => controller.navigateFromDrawer('chat'),
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.analytics_outlined,
                    title: 'Token Usage & Analytics',
                    onTap: () {
                      Get.back();
                      Get.to(() => const TokenUsageView());
                    },
                    isDark: isDark,
                  ),

                  const SizedBox(height: 12),
                  _buildDrawerSectionTitle('KNOWLEDGE ENGINE', isDark),
                  _buildDrawerTile(
                    icon: Icons.source_outlined,
                    title: 'Sources & Documents (12)',
                    onTap: () => controller.navigateFromDrawer('sources'),
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.sync_problem_outlined,
                    title: 'Sync Jobs History (100)',
                    onTap: () {
                      controller.navigateFromDrawer('sync_jobs');
                      Get.find<KnowledgeController>().setSubTab('sync_jobs');
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.saved_search_rounded,
                    title: 'Vector Search Tester',
                    onTap: () {
                      controller.navigateFromDrawer('sources');
                      Get.find<KnowledgeController>().setSubTab('test_search');
                    },
                    isDark: isDark,
                  ),

                  const SizedBox(height: 12),
                  _buildDrawerSectionTitle('GROWTH & LEADS', isDark),
                  _buildDrawerTile(
                    icon: Icons.contacts_outlined,
                    title: 'Leads & Inquiries',
                    badgeText: '18 Total',
                    onTap: () => controller.navigateFromDrawer('leads'),
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.insights_outlined,
                    title: 'Live Visitors Stream',
                    badgeText: '25 Online',
                    onTap: () => controller.navigateFromDrawer('visitors'),
                    isDark: isDark,
                  ),

                  const SizedBox(height: 12),
                  _buildDrawerSectionTitle('BOT CUSTOMIZATION', isDark),
                  _buildDrawerTile(
                    icon: Icons.tune_rounded,
                    title: 'Bot Configurator & Preview',
                    onTap: () {
                      Get.back();
                      Get.to(() => const BotSettingsView());
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.integration_instructions_outlined,
                    title: 'Widget Embed Code',
                    onTap: () {
                      Get.back();
                      Get.to(() => const BotSettingsView());
                    },
                    isDark: isDark,
                  ),

                  const SizedBox(height: 12),
                  _buildDrawerSectionTitle('SECURITY & SETTINGS', isDark),
                  _buildDrawerTile(
                    icon: Icons.manage_accounts_outlined,
                    title: 'Account Profile',
                    onTap: () => controller.navigateFromDrawer('profile'),
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.security_rounded,
                    title: 'API Keys & MFA Security',
                    onTap: () => controller.navigateFromDrawer('profile'),
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            // Bottom Logout & Version
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => authController.logout(),
                      icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
                      label: const Text('Sign Out', style: TextStyle(color: AppColors.error, fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
    String? badgeText,
  }) {
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        size: 20,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      trailing: badgeText != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(color: AppColors.primaryLight, fontSize: 10, fontWeight: FontWeight.w700),
              ),
            )
          : const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.darkTextMuted),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    );
  }
}
