import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/user_shared_controller.dart';
import 'bot_settings_view.dart';
import 'chat_view.dart';
import 'crawl_failures_view.dart';
import 'dashboard_view.dart';
import 'escalations_view.dart';
import 'feedback_view.dart';
import 'governance_view.dart';
import 'ingestion_view.dart';
import 'knowledge_gaps_view.dart';
import 'knowledge_sources_view.dart';
import 'leads_view.dart';
import 'live_activity_view.dart';
import 'messages_analytics_view.dart';
import 'my_reviews_view.dart';
import 'profile_view.dart';
import 'sync_jobs_view.dart';
import 'token_usage_view.dart';
import 'transcripts_view.dart';
import 'visitors_view.dart';
import 'widget_manager_view.dart';

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
          icon: Icon(
            Icons.menu_rounded,
            size: 24,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          onPressed: () {
            PlatformHelper.lightHaptic();
            Scaffold.of(ctx).openDrawer();
          },
        ),
      ),
      title: Text(
        'AI RAG ChatBot',
        style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            controller.isDarkMode.value ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            size: 22,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          onPressed: controller.toggleTheme,
          tooltip: 'Toggle Theme',
        ),
        const SizedBox(width: 8),
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
                    width: 50,
                    height: 50,
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
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.smart_toy_rounded,
                          color: AppColors.primary,
                          size: 28,
                        ),
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
                          'zia@excels-tech.com • Admin',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Modules Scroll List matching exact web sidebar
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  // 1: CORE
                  _buildDrawerSectionTitle('• CORE', isDark),
                  _buildDrawerTile(
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    onTap: () => controller.navigateFromDrawer('dashboard'),
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.chat_bubble_rounded,
                    title: 'Chat',
                    onTap: () => controller.navigateFromDrawer('chat'),
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.show_chart_rounded,
                    title: 'Live Activity',
                    badgeText: '25 Live',
                    onTap: () {
                      Get.back();
                      Get.to(() => const LiveActivityView());
                    },
                    isDark: isDark,
                  ),

                  const SizedBox(height: 12),
                  // 2: BOT
                  _buildDrawerSectionTitle('• BOT', isDark),
                  _buildDrawerTile(
                    icon: Icons.settings_suggest_rounded,
                    title: 'Bot Settings',
                    onTap: () {
                      Get.back();
                      Get.to(() => const BotSettingsView());
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.language_rounded,
                    title: 'Widget Manager',
                    onTap: () {
                      Get.back();
                      Get.to(() => const WidgetManagerView());
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.track_changes_rounded,
                    title: 'Leads',
                    badgeText: '3 Total',
                    onTap: () => controller.navigateFromDrawer('leads'),
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.groups_rounded,
                    title: 'Visitors',
                    badgeText: '301',
                    onTap: () {
                      Get.back();
                      Get.to(() => const VisitorsView());
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.receipt_long_rounded,
                    title: 'Transcripts',
                    onTap: () {
                      Get.back();
                      Get.to(() => const TranscriptsView());
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.sentiment_satisfied_alt_rounded,
                    title: 'Feedback',
                    badgeText: '4.8 ★',
                    onTap: () {
                      Get.back();
                      Get.to(() => const FeedbackView());
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.notifications_active_rounded,
                    title: 'Escalations',
                    badgeText: '1 Open',
                    onTap: () {
                      Get.back();
                      Get.to(() => const EscalationsView());
                    },
                    isDark: isDark,
                  ),

                  const SizedBox(height: 12),
                  // 3: KNOWLEDGE
                  _buildDrawerSectionTitle('• KNOWLEDGE', isDark),
                  _buildDrawerTile(
                    icon: Icons.library_books_rounded,
                    title: 'Sources',
                    badgeText: '12',
                    onTap: () => controller.navigateFromDrawer('sources'),
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.sync_rounded,
                    title: 'Sync Jobs',
                    badgeText: '100',
                    onTap: () {
                      Get.back();
                      Get.to(() => const SyncJobsView());
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.hub_rounded,
                    title: 'Ingestion (Vector DB)',
                    onTap: () {
                      Get.back();
                      Get.to(() => const IngestionView());
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.error_outline_rounded,
                    title: 'Crawl Failures',
                    onTap: () {
                      Get.back();
                      Get.to(() => const CrawlFailuresView());
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.lightbulb_outline_rounded,
                    title: 'Knowledge Gaps',
                    badgeText: '2 New',
                    onTap: () {
                      Get.back();
                      Get.to(() => const KnowledgeGapsView());
                    },
                    isDark: isDark,
                  ),

                  const SizedBox(height: 12),
                  // 4: ANALYTICS
                  _buildDrawerSectionTitle('• ANALYTICS', isDark),
                  _buildDrawerTile(
                    icon: Icons.policy_rounded,
                    title: 'Governance',
                    onTap: () {
                      Get.back();
                      Get.to(() => const GovernanceView());
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.rate_review_rounded,
                    title: 'My Reviews',
                    badgeText: '1 QA',
                    onTap: () {
                      Get.back();
                      Get.to(() => const MyReviewsView());
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.data_usage_rounded,
                    title: 'Token Usage',
                    onTap: () {
                      Get.back();
                      Get.to(() => const TokenUsageView());
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerTile(
                    icon: Icons.mark_chat_read_rounded,
                    title: 'Messages Telemetry',
                    badgeText: '168 msgs',
                    onTap: () {
                      Get.back();
                      Get.to(() => const MessagesAnalyticsView());
                    },
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            // Bottom Logout
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
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: isDark ? AppColors.primaryLight : AppColors.primary,
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
