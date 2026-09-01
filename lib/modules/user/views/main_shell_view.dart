import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../core/responsive/responsive_layout.dart';
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

    return ResponsiveBuilder(
      mobile: (ctx) => _buildMobileLayout(ctx, authController),
      tablet: (ctx) => _buildTabletLayout(ctx, authController),
      desktop: (ctx) => _buildDesktopLayout(ctx, authController),
    );
  }

  // ==========================================
  // 1: MOBILE LAYOUT (< 768px)
  // ==========================================
  Widget _buildMobileLayout(BuildContext context, AuthController authController) {
    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final currentTab = controller.currentTabIndex.value;

      return Scaffold(
        extendBody: true,
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        drawer: _buildSideDrawer(context, authController, isDark),
        appBar: _buildTopAppBar(context, isDark, isMobile: true),
        body: _buildPageStack(currentTab),
        bottomNavigationBar: currentTab == 1 ? null : _buildFloatingBottomBar(isDark),
      );
    });
  }

  // ==========================================
  // 2: TABLET LAYOUT (768px - 1099px)
  // ==========================================
  Widget _buildTabletLayout(BuildContext context, AuthController authController) {
    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final currentTab = controller.currentTabIndex.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        drawer: _buildSideDrawer(context, authController, isDark),
        body: Row(
          children: [
            _buildTabletNavigationRail(context, isDark),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
            ),
            Expanded(
              child: Column(
                children: [
                  _buildDesktopTopBar(context, isDark, isTablet: true),
                  Expanded(child: _buildPageStack(currentTab)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==========================================
  // 3: DESKTOP LAYOUT (≥ 1100px)
  // ==========================================
  Widget _buildDesktopLayout(BuildContext context, AuthController authController) {
    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final currentTab = controller.currentTabIndex.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: Row(
          children: [
            // Permanent Full Left Sidebar
            SizedBox(
              width: 260,
              child: _buildDesktopSidebar(context, authController, isDark),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
            ),
            // Main Content Area with Header
            Expanded(
              child: Column(
                children: [
                  _buildDesktopTopBar(context, isDark, isTablet: false),
                  Expanded(
                    child: _buildPageStack(currentTab),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==========================================
  // PAGE STACK
  // ==========================================
  Widget _buildPageStack(int currentTab) {
    return IndexedStack(
      index: currentTab,
      children: const [
        DashboardView(),
        ChatView(),
        KnowledgeSourcesView(),
        LeadsView(),
        ProfileView(),
      ],
    );
  }

  // ==========================================
  // TOP BAR (MOBILE)
  // ==========================================
  PreferredSizeWidget _buildTopAppBar(BuildContext context, bool isDark, {required bool isMobile}) {
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
      title: Obx(() {
        final titles = [
          'Dashboard',
          'Chat Assistant',
          'Knowledge Sources',
          'Leads',
          'Bot Settings',
        ];
        final index = controller.currentTabIndex.value;
        final title = (index >= 0 && index < titles.length) ? titles[index] : 'AI RAG ChatBot';

        return Text(
          title,
          style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        );
      }),
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

  // ==========================================
  // TOP BAR (DESKTOP / TABLET)
  // ==========================================
  Widget _buildDesktopTopBar(BuildContext context, bool isDark, {required bool isTablet}) {
    final titles = [
      'Dashboard Overview',
      'RAG Chat Assistant',
      'Knowledge Sources & Index',
      'Leads Management',
      'Bot Configuration',
    ];
    final index = controller.currentTabIndex.value;
    final pageTitle = (index >= 0 && index < titles.length) ? titles[index] : 'AI RAG Agent';

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isTablet) ...[
                Builder(
                  builder: (ctx) => IconButton(
                    icon: Icon(
                      Icons.menu_rounded,
                      size: 22,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                    tooltip: 'All Modules',
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                pageTitle,
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.successSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'AI Agent Online',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Actions Right Side
          Row(
            children: [
              // Search / Quick Action Button
              OutlinedButton.icon(
                onPressed: () => Get.to(() => const WidgetManagerView()),
                icon: const Icon(Icons.language_rounded, size: 16, color: AppColors.primary),
                label: const Text(
                  'Embed Widget',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(width: 12),
              // Theme Toggle
              IconButton(
                icon: Icon(
                  controller.isDarkMode.value ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  size: 20,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                onPressed: controller.toggleTheme,
                tooltip: 'Toggle Theme',
              ),
              const SizedBox(width: 8),
              // User Avatar
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                ),
                child: const Center(
                  child: Text(
                    'Z',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TABLET NAVIGATION RAIL (768px - 1099px)
  // ==========================================
  Widget _buildTabletNavigationRail(BuildContext context, bool isDark) {
    return Container(
      width: 74,
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Mini Logo
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/bot_mascot.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.smart_toy_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Primary Nav Icons
            _buildRailItem(0, Icons.dashboard_rounded, 'Dashboard', isDark),
            _buildRailItem(1, Icons.chat_bubble_rounded, 'RAG Chat', isDark),
            _buildRailItem(2, Icons.folder_special_rounded, 'Sources', isDark),
            _buildRailItem(3, Icons.people_alt_rounded, 'Leads', isDark, badgeCount: 3),
            _buildRailItem(4, Icons.settings_suggest_rounded, 'Settings', isDark),
            const Spacer(),
            // Drawer Menu Opener for all secondary links
            IconButton(
              icon: Icon(
                Icons.menu_open_rounded,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: 'All Tools',
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildRailItem(int index, IconData icon, String label, bool isDark, {int? badgeCount}) {
    final isSelected = controller.currentTabIndex.value == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: () => controller.switchTab(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                if (badgeCount != null && badgeCount > 0 && !isSelected)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // DESKTOP FULL LEFT SIDEBAR (≥ 1100px)
  // ==========================================
  Widget _buildDesktopSidebar(BuildContext context, AuthController authController, bool isDark) {
    return Container(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: SafeArea(
        child: Column(
          children: [
            // App Brand Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
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
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI RAG Agent Pro',
                          style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'Enterprise v2.4',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Sidebar Menu List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                children: [
                  // 1: CORE
                  _buildSidebarSectionHeader('MAIN PLATFORM', isDark),
                  _buildSidebarNavLink(
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    isSelected: controller.currentTabIndex.value == 0,
                    onTap: () => controller.switchTab(0),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.chat_bubble_rounded,
                    title: 'RAG Assistant',
                    isSelected: controller.currentTabIndex.value == 1,
                    onTap: () => controller.switchTab(1),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.folder_special_rounded,
                    title: 'Knowledge Sources',
                    badgeText: '12',
                    isSelected: controller.currentTabIndex.value == 2,
                    onTap: () => controller.switchTab(2),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.track_changes_rounded,
                    title: 'Leads Inbox',
                    badgeText: '3 New',
                    isSelected: controller.currentTabIndex.value == 3,
                    onTap: () => controller.switchTab(3),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.settings_suggest_rounded,
                    title: 'Bot Settings',
                    isSelected: controller.currentTabIndex.value == 4,
                    onTap: () => controller.switchTab(4),
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  // 2: BOT & EMBED TOOLS
                  _buildSidebarSectionHeader('TOOLS & INTEGRATIONS', isDark),
                  _buildSidebarNavLink(
                    icon: Icons.language_rounded,
                    title: 'Widget Manager',
                    onTap: () => Get.to(() => const WidgetManagerView()),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.show_chart_rounded,
                    title: 'Live Activity',
                    badgeText: '25 Live',
                    onTap: () => Get.to(() => const LiveActivityView()),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.groups_rounded,
                    title: 'Visitors',
                    badgeText: '301',
                    onTap: () => Get.to(() => const VisitorsView()),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.receipt_long_rounded,
                    title: 'Transcripts',
                    onTap: () => Get.to(() => const TranscriptsView()),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.sentiment_satisfied_alt_rounded,
                    title: 'Feedback',
                    badgeText: '4.8 ★',
                    onTap: () => Get.to(() => const FeedbackView()),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.notifications_active_rounded,
                    title: 'Escalations',
                    badgeText: '1 Open',
                    onTap: () => Get.to(() => const EscalationsView()),
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  // 3: DATA & SYNC
                  _buildSidebarSectionHeader('DATA & SYNC', isDark),
                  _buildSidebarNavLink(
                    icon: Icons.sync_rounded,
                    title: 'Sync Jobs',
                    badgeText: '100',
                    onTap: () => Get.to(() => const SyncJobsView()),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.hub_rounded,
                    title: 'Vector Ingestion',
                    onTap: () => Get.to(() => const IngestionView()),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.error_outline_rounded,
                    title: 'Crawl Failures',
                    onTap: () => Get.to(() => const CrawlFailuresView()),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.lightbulb_outline_rounded,
                    title: 'Knowledge Gaps',
                    badgeText: '2 New',
                    onTap: () => Get.to(() => const KnowledgeGapsView()),
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  // 4: GOVERNANCE & TELEMETRY
                  _buildSidebarSectionHeader('ANALYTICS & GOVERNANCE', isDark),
                  _buildSidebarNavLink(
                    icon: Icons.policy_rounded,
                    title: 'Governance',
                    onTap: () => Get.to(() => const GovernanceView()),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.rate_review_rounded,
                    title: 'My Reviews',
                    badgeText: '1 QA',
                    onTap: () => Get.to(() => const MyReviewsView()),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.data_usage_rounded,
                    title: 'Token Usage',
                    onTap: () => Get.to(() => const TokenUsageView()),
                    isDark: isDark,
                  ),
                  _buildSidebarNavLink(
                    icon: Icons.mark_chat_read_rounded,
                    title: 'Messages Telemetry',
                    badgeText: '168 msgs',
                    onTap: () => Get.to(() => const MessagesAnalyticsView()),
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            // User Info & Sign Out Footer
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
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                    child: const Center(
                      child: Text(
                        'Z',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'zia@excels-tech.com',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const Text(
                          'Workspace Admin',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
                    onPressed: () => authController.logout(),
                    tooltip: 'Sign Out',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
      ),
    );
  }

  Widget _buildSidebarNavLink({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
    bool isSelected = false,
    String? badgeText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () {
          PlatformHelper.lightHaptic();
          onTap();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  ),
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withValues(alpha: 0.25) : AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primaryLight,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // FLOATING BOTTOM NAV BAR (MOBILE ONLY)
  // ==========================================
  Widget _buildFloatingBottomBar(bool isDark) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: (isDark ? AppColors.darkSurface : AppColors.lightSurface).withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.06),
                  width: 1.2,
                ),
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
          ),
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

  // ==========================================
  // MOBILE DRAWER
  // ==========================================
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
