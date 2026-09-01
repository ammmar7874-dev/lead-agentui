import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/user_shared_controller.dart';

// ==========================================
// MODELS
// ==========================================
class QuickActionToggleItem {
  final String id;
  final String icon;
  final String title;
  final String description;
  final RxBool isShown;

  QuickActionToggleItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    bool isShown = true,
  }) : isShown = isShown.obs;
}

class QuickActionSiteGroup {
  final String siteName;
  final String domain;
  final List<QuickActionToggleItem> items;

  QuickActionSiteGroup({
    required this.siteName,
    required this.domain,
    required this.items,
  });

  int get shownCount => items.where((i) => i.isShown.value).length;
}

// ==========================================
// CONTROLLER
// ==========================================
class BotSettingsController extends GetxController {
  static BotSettingsController get to => Get.find();

  final RxString activeSubTab = 'customization'.obs;

  // 1: Customization Form State
  final assistantNameController = TextEditingController(text: 'Support Team');
  final welcomeMessageController = TextEditingController(text: 'Hi! How can I help you today?');
  final RxString welcomeMode = 'Custom'.obs; // 'Templates' | 'Custom'
  final RxString selectedThemeColor = '#E60000'.obs;
  final RxString selectedBotIcon = '🤖'.obs;
  final RxBool hasCustomIcon = false.obs;

  // 2: Live Test Chat State
  final testInputController = TextEditingController();
  final ScrollController testScrollController = ScrollController();
  final RxList<Map<String, dynamic>> testMessages = <Map<String, dynamic>>[
    {
      'sender': 'assistant',
      'text': 'Hi! How can I help you today?',
      'time': 'Just now',
    },
  ].obs;
  final RxBool isTestBotTyping = false.obs;

  // 3: Quick Action Functionality Cards Data
  late final List<QuickActionSiteGroup> quickActionGroups;
  final RxString quickActionFilter = 'all'.obs; // 'all' | 'shown' | 'hidden'

  // 4: Integration State
  final String embedSnippet = '<script src="https://airagchatbot.com/widget.js" data-org="cmmqn8lrb0021gxkdt3yvr5um"></script>';
  final String widgetApiKey = 'pub_cmmqn8lrb0021gxk';
  final String widgetSiteName = 'Excels_Tech Widget';
  final List<String> allowedWebsites = const [
    'https://excelstech.ai', 'https://www.excelstech.ai', 'http://excelstech.ai',
    'https://excelscrm.com', 'https://aicallsagent.com', 'https://www.excelscrm.com',
    'http://excelscrm.com', 'https://www.aicallsagent.com', 'http://aicallsagent.com',
    'https://aipoweremail.com', 'https://www.aipoweremail.com', 'http://aipoweremail.com',
    'https://myleadsagent.com', 'https://www.myleadsagent.com', 'http://myleadsagent.com',
    'https://excelsdigital.com', 'https://www.excelsdigital.com', 'http://excelsdigital.com',
    'https://aisocialhubs.com', 'https://www.aisocialhubs.com', 'http://aisocialhubs.com',
    'https://aidesignerly.com', 'https://www.aidesignerly.com', 'http://aidesignerly.com',
    'https://aiwebsitesbuild.com', 'https://www.aiwebsitesbuild.com', 'http://aiwebsitesbuild.com',
    'https://excelstechnology.com', 'https://www.excelstechnology.com', 'http://excelstechnology.com',
    'https://airagchatbot.com', 'https://www.airagchatbot.com', 'http://airagchatbot.com',
    'https://univenture.it.com', 'https://www.univenture.it.com', 'http://univenture.it.com',
  ];

  // 5: Notifications State
  final RxBool enableLeadNotifications = true.obs;
  final notificationEmailController = TextEditingController(text: 'alerts@company.com');

  // 6: Placement State
  final RxString selectedPosition = 'Bottom Right'.obs;
  final List<String> positionOptions = const ['Bottom Right', 'Bottom Left', 'Top Right', 'Top Left'];
  final zIndexController = TextEditingController(text: '9999');
  final offsetXController = TextEditingController(text: '20');
  final offsetYController = TextEditingController(text: '20');
  final RxString selectedAutoOpenMode = 'Homepage Only'.obs;
  final List<String> autoOpenOptions = const ['Homepage Only', 'All Pages', 'Disabled'];
  final autoOpenDelayController = TextEditingController(text: '3000');
  final hiddenPagesController = TextEditingController(
    text: 'https://excelsdigital.com/login\nhttps://excelsdigital.com/hr\nhttps://aipoweremail.com/files\nhttps://aipoweremail.com/inbox',
  );

  // 7: Privacy State
  final privacyPolicyUrlController = TextEditingController(text: 'https://yoursite.com/privacy');
  final visitorRetentionController = TextEditingController(text: '0');
  final conversationRetentionController = TextEditingController(text: '0');
  final transcriptRetentionController = TextEditingController(text: '365');
  final RxBool enableTranscriptEmails = true.obs;
  final RxBool requireOptInTranscripts = true.obs;

  // 24 Bot Icons Grid
  final List<String> availableBotIcons = const [
    '💬', '🎧', '🤖', '🛍️', '🏪', '✈️',
    '🏨', '🍽️', '🎓', '🏠', '💎', '❤️',
    '⭐', '👑', '🚀', '📞', '📦', '🏢',
    '👤', '🦾', '🏛️', '⚖️', '💵', '🎵',
  ];

  // Theme Colors
  final List<String> availableColors = const [
    '#E60000', // Crimson Red
    '#0284C7', // Ocean Sapphire
    '#10B981', // Emerald
    '#8B5CF6', // Royal Purple
    '#F59E0B', // Amber
    '#EC4899', // Hot Pink
    '#06B6D4', // Cyan
    '#111827', // Obsidian Black
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeQuickActions();
  }

  void _initializeQuickActions() {
    quickActionGroups = [
      QuickActionSiteGroup(
        siteName: 'Migrated Source',
        domain: 'excelstech.ai',
        items: [
          QuickActionToggleItem(id: 'mvp', icon: '🚀', title: 'MVP Development', description: 'How can you help me with MVP development?', isShown: true),
          QuickActionToggleItem(id: 'prop', icon: '🏢', title: 'Property Management Software', description: 'What property management software solutions do you offer?', isShown: false),
          QuickActionToggleItem(id: 'ai_dev', icon: '🤖', title: 'AI Development Services', description: 'What AI development services do you provide?', isShown: false),
          QuickActionToggleItem(id: 'health', icon: '🏥', title: 'Healthcare Software Development', description: 'How do you handle healthcare software development?', isShown: false),
          QuickActionToggleItem(id: 'supply', icon: '🚚', title: 'Supply Chain Software', description: 'What solutions do you have for supply chain software?', isShown: true),
          QuickActionToggleItem(id: 'hosp', icon: '🏨', title: 'Hospitality Software Development', description: 'What hospitality software services do you offer?', isShown: true),
          QuickActionToggleItem(id: 'retail', icon: '🛒', title: 'Retail & E-Commerce Software', description: 'Can you help with retail and e-commerce software?', isShown: true),
          QuickActionToggleItem(id: 'odoo_train', icon: '📊', title: 'Odoo Training Programs', description: 'What Odoo training programs are available?', isShown: true),
          QuickActionToggleItem(id: 'odoo_int', icon: '🔗', title: 'Odoo Integration Services', description: 'How can you assist with Odoo integration?', isShown: true),
          QuickActionToggleItem(id: 'odoo_cust', icon: '⚙️', title: 'Odoo Customization Services', description: 'What customization services do you offer for Odoo?', isShown: true),
          QuickActionToggleItem(id: 'gen_ai', icon: '🧠', title: 'Generative AI Development', description: 'What generative AI development services are available?', isShown: true),
          QuickActionToggleItem(id: 'staff', icon: '👥', title: 'Staff Augmentation', description: 'How can you assist with staff augmentation?', isShown: true),
          QuickActionToggleItem(id: 'soft_dev', icon: '💻', title: 'Software Development Services', description: 'What software development services do you provide?', isShown: true),
          QuickActionToggleItem(id: 'web_dev', icon: '🌐', title: 'Web Development', description: 'What web development services do you offer?', isShown: true),
          QuickActionToggleItem(id: 'design', icon: '🎨', title: 'Design Services', description: 'What design services are available?', isShown: true),
          QuickActionToggleItem(id: 'social', icon: '📱', title: 'Social Media Management', description: 'How can you help with social media management?', isShown: true),
          QuickActionToggleItem(id: 'consult', icon: '📞', title: 'Free AI Consultation', description: 'How can I book a free AI consultation?', isShown: true),
          QuickActionToggleItem(id: 'case_studies', icon: '📖', title: 'Case Studies', description: 'Can you share case studies of your work?', isShown: false),
        ],
      ),
      QuickActionSiteGroup(
        siteName: 'Power Email',
        domain: 'aipoweremail.com',
        items: [
          QuickActionToggleItem(id: 'power_email', icon: '📧', title: 'AI Power Email', description: 'How can AI Power Email help me with email marketing?', isShown: true),
        ],
      ),
      QuickActionSiteGroup(
        siteName: 'AI Call Agent',
        domain: 'aicallsagent.com',
        items: [
          QuickActionToggleItem(id: 'call_agent', icon: '🤖', title: 'AI Calls Agent', description: 'What is the AI Calls Agent and how can it help my sales?', isShown: false),
        ],
      ),
      QuickActionSiteGroup(
        siteName: 'AI Cloud CRM',
        domain: 'excelscrm.com',
        items: [
          QuickActionToggleItem(id: 'cloud_crm', icon: '☁️', title: 'AI Cloud CRM', description: 'What features does your AI Cloud CRM offer?', isShown: true),
        ],
      ),
      QuickActionSiteGroup(
        siteName: 'AI Lead Gen',
        domain: 'myleadsagent.com',
        items: [
          QuickActionToggleItem(id: 'leads_agent_1', icon: '📈', title: 'My Leads Agent', description: 'What is My Leads Agent?', isShown: true),
          QuickActionToggleItem(id: 'leads_agent_2', icon: '🤝', title: 'My Lead Agent', description: 'What is My Lead Agent?', isShown: true),
        ],
      ),
      QuickActionSiteGroup(
        siteName: 'Excels Digital',
        domain: 'excelsdigital.com',
        items: [
          QuickActionToggleItem(id: 'talent_match', icon: '🤖', title: 'TalentMatch AI', description: 'What is TalentMatch AI?', isShown: true),
        ],
      ),
      QuickActionSiteGroup(
        siteName: 'AI Social Hub',
        domain: 'aisocialhubs.com',
        items: [
          QuickActionToggleItem(id: 'social_manager', icon: '🤖', title: 'AI Social Media Manager', description: 'How can the AI Social Media Manager help my business?', isShown: true),
        ],
      ),
      QuickActionSiteGroup(
        siteName: 'AI Designerly',
        domain: 'aidesignerly.com',
        items: [
          QuickActionToggleItem(id: 'prod_designer', icon: '✏️', title: 'AI Product Designer', description: 'How can I use the AI Product Designer to create and design?', isShown: true),
        ],
      ),
    ];
  }

  void selectSubTab(String tabKey) {
    PlatformHelper.selectionHaptic();
    activeSubTab.value = tabKey;
  }

  void selectBotIcon(String icon) {
    PlatformHelper.selectionHaptic();
    selectedBotIcon.value = icon;
    hasCustomIcon.value = false;
  }

  void selectThemeColor(String hex) {
    PlatformHelper.selectionHaptic();
    selectedThemeColor.value = hex;
  }

  void toggleQuickAction(QuickActionToggleItem item) {
    PlatformHelper.selectionHaptic();
    item.isShown.toggle();
  }

  void applyWelcomeTemplate(String template) {
    PlatformHelper.selectionHaptic();
    welcomeMessageController.text = template;
    welcomeMode.value = 'Templates';
  }

  void saveConfiguration() {
    PlatformHelper.mediumHaptic();
    Get.snackbar(
      'Changes Saved Live ✨',
      'Bot customizations, theme accents, and widget integrations updated.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  void saveNotifications() {
    PlatformHelper.mediumHaptic();
    Get.snackbar(
      'Notification Preferences Saved 📧',
      'Lead notifications will be routed to ${notificationEmailController.text}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF0284C7),
      colorText: Colors.white,
      icon: const Icon(Icons.mark_email_read_rounded, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void savePlacement() {
    PlatformHelper.mediumHaptic();
    Get.snackbar(
      'Placement Settings Saved 📐',
      'Widget positioning set to ${selectedPosition.value}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF0284C7),
      colorText: Colors.white,
      icon: const Icon(Icons.layers_rounded, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void savePrivacy() {
    PlatformHelper.mediumHaptic();
    Get.snackbar(
      'Privacy Settings Updated 🔒',
      'Data retention policies updated successfully.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      icon: const Icon(Icons.security_rounded, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> sendTestMessage([String? customPrompt]) async {
    final text = (customPrompt ?? testInputController.text).trim();
    if (text.isEmpty || isTestBotTyping.value) return;

    PlatformHelper.lightHaptic();
    testMessages.add({'sender': 'user', 'text': text, 'time': 'Just now'});
    testInputController.clear();
    _scrollTestToBottom();

    isTestBotTyping.value = true;
    await Future.delayed(const Duration(milliseconds: 700));

    String botReply = 'I am connected to all your synced data sources. For "$text", our team delivers end-to-end intelligent AI solutions with 99.9% uptime.';
    final lower = text.toLowerCase();
    if (lower.contains('service') || lower.contains('help') || lower.contains('what')) {
      botReply = 'Of course! We provide MVP development, custom AI chatbots, RAG search systems, and automated lead capture workflows.';
    } else if (lower.contains('pricing') || lower.contains('cost') || lower.contains('plan')) {
      botReply = 'We offer transparent tiered plans tailored to your traffic volume. You can also book a free 30-minute consultation with our engineers!';
    } else if (lower.contains('demo') || lower.contains('book') || lower.contains('consult')) {
      botReply = 'Great! Please share your work email or click "Book a Consultation" on the home screen to pick a convenient time slot.';
    }

    testMessages.add({'sender': 'assistant', 'text': botReply, 'time': 'Just now'});
    isTestBotTyping.value = false;
    _scrollTestToBottom();
    PlatformHelper.lightHaptic();
  }

  void resetTestChat() {
    PlatformHelper.mediumHaptic();
    testMessages.assignAll([
      {
        'sender': 'assistant',
        'text': welcomeMessageController.text.isNotEmpty ? welcomeMessageController.text : 'Hi! How can I help you today?',
        'time': 'Just now',
      }
    ]);
  }

  void _scrollTestToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (testScrollController.hasClients) {
        testScrollController.animateTo(
          testScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  Color get currentColor {
    try {
      final hex = selectedThemeColor.value.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return const Color(0xFFE60000);
    }
  }

  @override
  void onClose() {
    assistantNameController.dispose();
    welcomeMessageController.dispose();
    testInputController.dispose();
    testScrollController.dispose();
    notificationEmailController.dispose();
    zIndexController.dispose();
    offsetXController.dispose();
    offsetYController.dispose();
    autoOpenDelayController.dispose();
    hiddenPagesController.dispose();
    privacyPolicyUrlController.dispose();
    visitorRetentionController.dispose();
    conversationRetentionController.dispose();
    transcriptRetentionController.dispose();
    super.onClose();
  }
}

// ==========================================
// VIEW
// ==========================================
class BotSettingsView extends StatelessWidget {
  const BotSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BotSettingsController());
    final sharedController = Get.find<UserSharedController>();

    return Obx(() {
      final isDark = sharedController.isDarkMode.value;
      final activeTab = controller.activeSubTab.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
        appBar: _buildAppBar(controller, isDark),
        body: Column(
          children: [
            // 1: Hero Bot Summary Banner
            _buildHeroBanner(controller, isDark),

            // 2: Animated Floating Sub-Tabs Navigation Bar
            _buildSubTabsBar(controller, isDark),

            // 3: Animated Tab Content with Smooth Transitions
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.02, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: SingleChildScrollView(
                  key: ValueKey<String>(activeTab),
                  padding: EdgeInsets.fromLTRB(
                    Responsive.value(context, mobile: 16, tablet: 24, desktop: 32),
                    Responsive.value(context, mobile: 16, tablet: 20, desktop: 24),
                    Responsive.value(context, mobile: 16, tablet: 24, desktop: 32),
                    40,
                  ),
                  child: ResponsiveContainer(
                    maxWidth: 1400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (activeTab == 'customization') _buildCustomizationTab(controller, isDark),
                        if (activeTab == 'test_bot') _buildTestBotTab(controller, isDark),
                        if (activeTab == 'quick_actions') _buildQuickActionsTab(controller, isDark),
                        if (activeTab == 'integration') _buildIntegrationTab(controller, isDark),
                        if (activeTab == 'notifications') _buildNotificationsTab(controller, isDark),
                        if (activeTab == 'placement') _buildPlacementTab(controller, isDark),
                        if (activeTab == 'privacy') _buildPrivacyTab(controller, isDark),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==========================================
  // APP BAR
  // ==========================================
  PreferredSizeWidget _buildAppBar(BotSettingsController controller, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      leading: IconButton(
        icon: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF334155),
          ),
        ),
        onPressed: () => Get.back(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [controller.currentColor, controller.currentColor.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.smart_toy_rounded, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bot Configuration',
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'Live Widget & AI Agent Settings',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Save Changes Glowing Action Button
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ElevatedButton.icon(
            onPressed: controller.saveConfiguration,
            icon: const Icon(Icons.cloud_done_rounded, size: 15, color: Colors.white),
            label: const Text(
              'Save',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.currentColor,
              elevation: 2,
              shadowColor: controller.currentColor.withValues(alpha: 0.4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // HERO BOT SUMMARY RIBBON
  // ==========================================
  Widget _buildHeroBanner(BotSettingsController controller, bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Live Avatar Circle with Glow
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: controller.currentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: controller.currentColor, width: 1.5),
            ),
            child: Text(
              controller.selectedBotIcon.value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        controller.assistantNameController.text.isNotEmpty
                            ? controller.assistantNameController.text
                            : 'Support Team',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Connected to ${controller.allowedWebsites.length} domains • Instant CDN Sync',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Theme Hex Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: controller.currentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: controller.currentColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: controller.currentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  controller.selectedThemeColor.value,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: controller.currentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ANIMATED SUB-TABS NAVIGATION BAR
  // ==========================================
  Widget _buildSubTabsBar(BotSettingsController controller, bool isDark) {
    final tabs = [
      {'key': 'customization', 'label': 'Customization', 'icon': Icons.palette_outlined},
      {'key': 'test_bot', 'label': 'Test Your Bot', 'icon': Icons.chat_bubble_outline_rounded},
      {'key': 'quick_actions', 'label': 'Quick Actions', 'icon': Icons.grid_view_rounded},
      {'key': 'integration', 'label': 'Integration', 'icon': Icons.code_rounded},
      {'key': 'notifications', 'label': 'Notifications', 'icon': Icons.mail_outline_rounded},
      {'key': 'placement', 'label': 'Placement', 'icon': Icons.layers_outlined},
      {'key': 'privacy', 'label': 'Privacy', 'icon': Icons.security_outlined},
    ];

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: tabs.map((tab) {
            final isSelected = controller.activeSubTab.value == tab['key'];
            final icon = tab['icon'] as IconData;
            final label = tab['label'] as String;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.selectSubTab(tab['key'] as String),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? controller.currentColor.withValues(alpha: isDark ? 0.18 : 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? controller.currentColor.withValues(alpha: 0.3)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedScale(
                          scale: isSelected ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            icon,
                            size: 15,
                            color: isSelected
                                ? controller.currentColor
                                : (isDark ? AppColors.darkTextMuted : const Color(0xFF64748B)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? Colors.white : controller.currentColor)
                                : (isDark ? AppColors.darkTextSecondary : const Color(0xFF475569)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: CUSTOMIZATION (DESIGN & CONTENT)
  // ==========================================
  Widget _buildCustomizationTab(BotSettingsController controller, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 850;

        final formSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              icon: Icons.tune_rounded,
              title: 'Design & Content',
              subtitle: 'Customize how your AI assistant appears to visitors on your websites.',
              isDark: isDark,
              accentColor: controller.currentColor,
            ),
            const SizedBox(height: 18),

            // Assistant Name Card
            _buildCardContainer(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assistant Name',
                    style: _labelStyle(isDark),
                  ),
                  const SizedBox(height: 6),
                  CustomTextField(
                    controller: controller.assistantNameController,
                    hint: 'e.g. Support Team, Eva AI',
                    onChanged: (_) => controller.update(),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'This name is displayed in the widget top header and live bubble responses.',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Welcome Message & Quick Preset Templates
            _buildCardContainer(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: AppColors.secondary),
                          const SizedBox(width: 6),
                          Text('Welcome Message', style: _labelStyle(isDark)),
                        ],
                      ),
                      // Templates vs Custom Toggle
                      Container(
                        height: 26,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            _buildPillToggle(
                              'Templates',
                              controller.welcomeMode.value == 'Templates',
                              () => controller.welcomeMode.value = 'Templates',
                              isDark,
                              controller.currentColor,
                            ),
                            _buildPillToggle(
                              'Custom',
                              controller.welcomeMode.value == 'Custom',
                              () => controller.welcomeMode.value = 'Custom',
                              isDark,
                              controller.currentColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Quick Template Suggestion Chips
                  if (controller.welcomeMode.value == 'Templates') ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildTemplateChip('👋 Friendly', 'Hi! How can I help you today?', controller, isDark),
                        _buildTemplateChip('🚀 Sales & Leads', 'Welcome! Interested in growing your business with our AI tools?', controller, isDark),
                        _buildTemplateChip('🛠️ Technical Support', 'Hello! Need help troubleshooting or configuring an integration?', controller, isDark),
                        _buildTemplateChip('🏢 Enterprise', 'Welcome to ExcelsTech. Ask us anything about our software solutions!', controller, isDark),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],

                  TextField(
                    controller: controller.welcomeMessageController,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Hi! How can I help you today?',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
                      ),
                      filled: true,
                      fillColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: controller.currentColor, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Theme Color Swatches & Custom Palette
            _buildCardContainer(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.color_lens_outlined, size: 15, color: AppColors.secondary),
                          const SizedBox(width: 6),
                          Text('Theme Color', style: _labelStyle(isDark)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: controller.currentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          controller.selectedThemeColor.value,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            color: controller.currentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: controller.availableColors.map((hex) {
                      final isSel = controller.selectedThemeColor.value == hex;
                      final color = Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));

                      return GestureDetector(
                        onTap: () => controller.selectThemeColor(hex),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSel ? Colors.white : Colors.transparent,
                              width: 2.5,
                            ),
                            boxShadow: [
                              if (isSel)
                                BoxShadow(
                                  color: color.withValues(alpha: 0.6),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                            ],
                          ),
                          child: isSel
                              ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Bot Icon Grid (24 Icons)
            _buildCardContainer(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.face_retouching_natural_rounded, size: 15, color: AppColors.secondary),
                          const SizedBox(width: 6),
                          Text('Bot Avatar Icon', style: _labelStyle(isDark)),
                        ],
                      ),
                      Text(
                        'Selected: ${controller.selectedBotIcon.value}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: controller.availableBotIcons.length,
                    itemBuilder: (context, index) {
                      final icon = controller.availableBotIcons[index];
                      final isSelected = controller.selectedBotIcon.value == icon && !controller.hasCustomIcon.value;

                      return InkWell(
                        onTap: () => controller.selectBotIcon(icon),
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? controller.currentColor.withValues(alpha: 0.15)
                                : (isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC)),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? controller.currentColor
                                  : (isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0)),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: controller.currentColor.withValues(alpha: 0.25),
                                      blurRadius: 6,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(icon, style: const TextStyle(fontSize: 20)),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 14),
                  Divider(height: 1, color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0)),
                  const SizedBox(height: 12),

                  // Custom Mascot Upload
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          PlatformHelper.lightHaptic();
                          controller.hasCustomIcon.value = true;
                          Get.snackbar(
                            'Image Uploaded ✨',
                            'Custom mascot icon applied live.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        icon: const Icon(Icons.file_upload_outlined, size: 14),
                        label: const Text('Upload Custom Mascot', style: TextStyle(fontSize: 11)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          controller.hasCustomIcon.value ? 'mascot.png' : 'PNG or SVG (1:1 ratio)',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Save Configuration Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: controller.saveConfiguration,
                icon: const Icon(Icons.check_circle_outline_rounded, size: 16, color: Colors.white),
                label: const Text(
                  'Save Customizations',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.currentColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        );

        final previewSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.preview_rounded, size: 16, color: AppColors.secondary),
                const SizedBox(width: 6),
                Text(
                  'Live Widget Preview',
                  style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Interactive real-time preview of how visitors see your widget.',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 14),
            _buildLiveWidgetPreviewBox(controller, isDark),
          ],
        );

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: formSection),
              const SizedBox(width: 24),
              Expanded(flex: 4, child: previewSection),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            formSection,
            const SizedBox(height: 30),
            previewSection,
          ],
        );
      },
    );
  }

  Widget _buildTemplateChip(String label, String template, BotSettingsController controller, bool isDark) {
    return InkWell(
      onTap: () => controller.applyWelcomeTemplate(template),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextSecondary : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // LIVE WIDGET PREVIEW MOCKUP
  // ==========================================
  Widget _buildLiveWidgetPreviewBox(BotSettingsController controller, bool isDark) {
    final themeColor = controller.currentColor;
    final botName = controller.assistantNameController.text.isNotEmpty
        ? controller.assistantNameController.text
        : 'Support Team';
    final welcome = controller.welcomeMessageController.text.isNotEmpty
        ? controller.welcomeMessageController.text
        : 'Hi! How can I help you today?';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dynamic Widget Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [themeColor, themeColor.withValues(alpha: 0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      shape: BoxShape.circle,
                    ),
                    child: Text(controller.selectedBotIcon.value, style: const TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          botName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF22C55E),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Always active',
                              style: TextStyle(fontSize: 10, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
                    onPressed: () {},
                    tooltip: 'Minimize',
                  ),
                ],
              ),
            ),

            // Live Chat Bubbles
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Assistant Welcome Bubble
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Text(
                        welcome,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // User Response Bubble
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Tell me about your services?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Assistant Response Bubble
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Text(
                        "Of course! We'd be happy to help you with MVP development and automated AI agents.",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Input Box Simulation
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Type a message...',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: themeColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.send_rounded, size: 12, color: Colors.white),
                        ),
                      ],
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

  // ==========================================
  // TAB 2: TEST YOUR BOT (LIVE SANDBOX)
  // ==========================================
  Widget _buildTestBotTab(BotSettingsController controller, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;

        final chatTester = Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                // Top Header (Reactive colored header with Reset icon)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: controller.currentColor,
                  child: Row(
                    children: [
                      Text(controller.selectedBotIcon.value, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.assistantNameController.text.isNotEmpty
                                  ? controller.assistantNameController.text
                                  : 'Support Team',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF22C55E),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Live Sandbox • Ready',
                                  style: TextStyle(fontSize: 10, color: Colors.white70),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, size: 20, color: Colors.white),
                        onPressed: controller.resetTestChat,
                        tooltip: 'Reset Conversation',
                      ),
                    ],
                  ),
                ),

                // Quick Prompt Suggestion Chips
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildPromptSuggestion('What services do you offer?', controller, isDark),
                        const SizedBox(width: 6),
                        _buildPromptSuggestion('Pricing plans', controller, isDark),
                        const SizedBox(width: 6),
                        _buildPromptSuggestion('Book a consultation', controller, isDark),
                      ],
                    ),
                  ),
                ),

                // Messages Stream
                Container(
                  height: 320,
                  padding: const EdgeInsets.all(16),
                  color: isDark ? AppColors.darkBackground : const Color(0xFFFAFAFA),
                  child: Obx(() {
                    return ListView.builder(
                      controller: controller.testScrollController,
                      itemCount: controller.testMessages.length + (controller.isTestBotTyping.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.testMessages.length) {
                          // Typing Indicator Bubble
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurface : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('Bot is typing...', style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                          );
                        }

                        final msg = controller.testMessages[index];
                        final isUser = msg['sender'] == 'user';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(
                                color: isUser ? controller.currentColor : (isDark ? AppColors.darkSurface : Colors.white),
                                borderRadius: BorderRadius.circular(12),
                                border: isUser
                                    ? null
                                    : Border.all(
                                        color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                                      ),
                              ),
                              child: Text(
                                msg['text'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isUser
                                      ? Colors.white
                                      : (isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B)),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),

                // Bottom Input Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.testInputController,
                          onSubmitted: (_) => controller.sendTestMessage(),
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type a message to test bot...',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            filled: true,
                            fillColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => controller.sendTestMessage(),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: controller.currentColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        final instructionsCard = _buildCardContainer(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'How to Test Your Agent',
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Use this live chat console to test your bot\'s grounded responses in real-time. Messages are evaluated through your synced website knowledge base.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 16),
              _buildBulletItem('Test service queries & pricing questions', isDark),
              _buildBulletItem('Verify welcome message trigger behavior', isDark),
              _buildBulletItem('Check accuracy of grounded answers', isDark),
              _buildBulletItem('Try edge cases or missing domain links', isDark),
            ],
          ),
        );

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: chatTester),
              const SizedBox(width: 20),
              Expanded(flex: 4, child: instructionsCard),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            instructionsCard,
            const SizedBox(height: 16),
            chatTester,
          ],
        );
      },
    );
  }

  Widget _buildPromptSuggestion(String prompt, BotSettingsController controller, bool isDark) {
    return InkWell(
      onTap: () => controller.sendTestMessage(prompt),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          prompt,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 3: QUICK ACTIONS (FUNCTIONALITY CARDS)
  // ==========================================
  Widget _buildQuickActionsTab(BotSettingsController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.grid_view_rounded,
          title: 'Quick Actions (Functionality Cards)',
          subtitle: 'Main services detected on your crawled websites are shown on the widget\'s home screen. Turn off any card you want to hide.',
          isDark: isDark,
          accentColor: controller.currentColor,
        ),

        const SizedBox(height: 16),

        // Filter Pills Row
        Row(
          children: [
            _buildFilterPill('all', 'All (${controller.quickActionGroups.fold<int>(0, (sum, g) => sum + g.items.length)})', controller, isDark),
            const SizedBox(width: 8),
            _buildFilterPill('shown', 'Shown Only', controller, isDark),
            const SizedBox(width: 8),
            _buildFilterPill('hidden', 'Hidden Only', controller, isDark),
          ],
        ),

        const SizedBox(height: 16),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.quickActionGroups.length,
          separatorBuilder: (context, index) => const SizedBox(height: 18),
          itemBuilder: (context, index) {
            final group = controller.quickActionGroups[index];

            return _buildCardContainer(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.secondarySoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.language_rounded, size: 16, color: AppColors.secondary),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                group.siteName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                group.domain,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${group.shownCount}/${group.items.length} shown',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Divider(height: 1, color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0)),
                  const SizedBox(height: 8),

                  // Action Items
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: group.items.length,
                    separatorBuilder: (context, idx) => Divider(
                      height: 1,
                      color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFF1F5F9),
                    ),
                    itemBuilder: (context, idx) {
                      final item = group.items[idx];

                      return Obx(() {
                        final isShown = item.isShown.value;
                        final filter = controller.quickActionFilter.value;

                        if (filter == 'shown' && !isShown) return const SizedBox.shrink();
                        if (filter == 'hidden' && isShown) return const SizedBox.shrink();

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Text(item.icon, style: const TextStyle(fontSize: 16)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isShown
                                            ? (isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A))
                                            : (isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8)),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isShown ? 'Shown' : 'Hidden',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isShown
                                      ? const Color(0xFF0284C7)
                                      : (isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8)),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: isShown,
                                  onChanged: (_) => controller.toggleQuickAction(item),
                                  activeTrackColor: const Color(0xFF0284C7),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterPill(String key, String label, BotSettingsController controller, bool isDark) {
    return Obx(() {
      final isSel = controller.quickActionFilter.value == key;

      return InkWell(
        onTap: () {
          PlatformHelper.selectionHaptic();
          controller.quickActionFilter.value = key;
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSel
                ? controller.currentColor
                : (isDark ? AppColors.darkSurface : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSel
                  ? controller.currentColor
                  : (isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0)),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
              color: isSel
                  ? Colors.white
                  : (isDark ? AppColors.darkTextSecondary : const Color(0xFF475569)),
            ),
          ),
        ),
      );
    });
  }

  // ==========================================
  // TAB 4: INTEGRATION (EMBED CODE & DOMAINS)
  // ==========================================
  Widget _buildIntegrationTab(BotSettingsController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.code_rounded,
          title: 'Widget Embed Code',
          subtitle: 'Copy and paste this script before the closing </body> tag in your website\'s HTML.',
          isDark: isDark,
          accentColor: controller.currentColor,
        ),
        const SizedBox(height: 16),

        // Embed Code Terminal Card
        _buildCardContainer(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metadata Row: Active Badge, Site, Key (Responsive Wrap)
              Wrap(
                spacing: 10,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Text(
                    'Site: ${controller.widgetSiteName}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Key: ${controller.widgetApiKey}',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Code Snippet Box with Copy Button
              Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF080C14) : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorderSubtle : const Color(0xFF334155),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        controller.embedSnippet,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: controller.embedSnippet));
                        PlatformHelper.lightHaptic();
                        Get.snackbar(
                          'Copied to Clipboard! ✨',
                          'Paste this script before </body> on your website.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFF10B981),
                          colorText: Colors.white,
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 13, color: Colors.white),
                      label: const Text(
                        'Copy',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Allowed Websites Tag Cloud
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🌐', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Allowed Websites',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                        ),
                        children: [
                          TextSpan(
                            text: ' — added automatically when you crawl a website',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Domain Pill Badges
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.allowedWebsites.map((url) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Text(
                      url,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : const Color(0xFF334155),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),
              Text(
                'This widget works across all configured domains — one script, everywhere. No manual setup needed.',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Installation Steps Pipeline
        _buildCardContainer(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🔧', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    '5-Step Installation Guide',
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildStepItem('1', 'Copy the script tag above (key is already included!)', isDark),
              _buildStepItem('2', 'Open your website\'s index.html or theme template file', isDark),
              _buildStepItem('3', 'Paste the code inside the <body> tag (before </body>)', isDark),
              _buildStepItem('4', 'Save changes and reload your live website', isDark),
              _buildStepItem('5', 'The chat widget will appear in the designated corner 🎉', isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(String num, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              num,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 5: NOTIFICATIONS (EMAIL ALERTS)
  // ==========================================
  Widget _buildNotificationsTab(BotSettingsController controller, bool isDark) {
    return _buildCardContainer(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.mark_email_read_rounded,
            title: 'Lead Notification Email',
            subtitle: 'Get notified immediately via email whenever a visitor submits an order or lead.',
            isDark: isDark,
            accentColor: controller.currentColor,
          ),
          const SizedBox(height: 18),

          // Order/Lead Email Notifications Toggle
          Text('Order & Lead Email Alerts', style: _labelStyle(isDark)),
          const SizedBox(height: 8),
          Obx(() {
            final isEnabled = controller.enableLeadNotifications.value;

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 0.85,
                    child: Switch(
                      value: isEnabled,
                      onChanged: (val) => controller.enableLeadNotifications.value = val,
                      activeTrackColor: const Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isEnabled
                          ? '✅ ON — Instant emails sent when orders/leads are captured'
                          : 'OFF — Email notifications are disabled',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isEnabled
                            ? const Color(0xFF16A34A)
                            : (isDark ? AppColors.darkTextMuted : const Color(0xFF64748B)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 18),

          // Email Address Input
          Text('Recipient Email Address', style: _labelStyle(isDark)),
          const SizedBox(height: 6),
          TextField(
            controller: controller.notificationEmailController,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: 'alerts@company.com',
              filled: true,
              fillColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                ),
              ),
              prefixIcon: const Icon(Icons.email_outlined, size: 18),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Multiple email addresses can be separated by commas.',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 22),

          // Save Button
          SizedBox(
            width: 140,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: controller.saveNotifications,
              icon: const Icon(Icons.save_rounded, size: 15, color: Colors.white),
              label: const Text(
                'Save Alerts',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 6: PLACEMENT (POSITION & ROUTING)
  // ==========================================
  Widget _buildPlacementTab(BotSettingsController controller, bool isDark) {
    return _buildCardContainer(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.layers_outlined,
            title: 'Widget Placement & Screen Behavior',
            subtitle: 'Choose where the chat bubble appears on visitor screens and configure route rules.',
            isDark: isDark,
            accentColor: controller.currentColor,
          ),
          const SizedBox(height: 18),

          // Interactive 2x2 Screen Placement Corner Selector
          Text('Screen Corner Position', style: _labelStyle(isDark)),
          const SizedBox(height: 8),
          Obx(() {
            final sel = controller.selectedPosition.value;

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildCornerPositionBtn('Top Left', sel == 'Top Left', controller, isDark),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCornerPositionBtn('Top Right', sel == 'Top Right', controller, isDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCornerPositionBtn('Bottom Left', sel == 'Bottom Left', controller, isDark),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCornerPositionBtn('Bottom Right', sel == 'Bottom Right', controller, isDark),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 18),

          // Offset X, Offset Y & Z-Index
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Offset X (px)', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.offsetXController, isDark),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Offset Y (px)', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.offsetYController, isDark),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Z-Index', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.zIndexController, isDark),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Auto-Open Mode & Delay
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Auto-Open Mode', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    Obx(
                      () => Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: _dropdownContainerDecoration(isDark),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.selectedAutoOpenMode.value,
                            isExpanded: true,
                            dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                            items: controller.autoOpenOptions.map((opt) {
                              return DropdownMenuItem<String>(
                                value: opt,
                                child: Text(opt, style: const TextStyle(fontSize: 13)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) controller.selectedAutoOpenMode.value = val;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delay (ms)', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.autoOpenDelayController, isDark),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Route Exclusions: Hide widget on internal pages
          Row(
            children: [
              const Text('🚫', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Hide widget on these pages (internal panels)',
                  style: _labelStyle(isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller.hiddenPagesController,
            maxLines: 4,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'One per line. The widget won\'t load on these paths (e.g. /login, /dashboard, /admin).',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 22),

          // Save Placement Button
          SizedBox(
            width: 170,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: controller.savePlacement,
              icon: const Icon(Icons.layers_rounded, size: 15, color: Colors.white),
              label: const Text(
                'Save Placement',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerPositionBtn(String label, bool isSel, BotSettingsController controller, bool isDark) {
    return InkWell(
      onTap: () {
        PlatformHelper.selectionHaptic();
        controller.selectedPosition.value = label;
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSel
              ? controller.currentColor.withValues(alpha: 0.15)
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSel
                ? controller.currentColor
                : (isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0)),
            width: isSel ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
            color: isSel
                ? controller.currentColor
                : (isDark ? AppColors.darkTextSecondary : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 7: PRIVACY & COMPLIANCE
  // ==========================================
  Widget _buildPrivacyTab(BotSettingsController controller, bool isDark) {
    return _buildCardContainer(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.security_rounded,
            title: 'Privacy & Data Retention',
            subtitle: 'Configure GDPR & data compliance retention policies for conversation transcripts.',
            isDark: isDark,
            accentColor: controller.currentColor,
          ),
          const SizedBox(height: 18),

          // Privacy Policy URL
          Text('Privacy Policy URL', style: _labelStyle(isDark)),
          const SizedBox(height: 6),
          _buildSettingsTextField(controller.privacyPolicyUrlController, isDark),

          const SizedBox(height: 16),

          // Retention Controls
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Visitor Retention (days, 0 = ∞)', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.visitorRetentionController, isDark),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transcript Retention (days)', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.transcriptRetentionController, isDark),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Enable Transcript Emails
          Row(
            children: [
              Obx(
                () => Transform.scale(
                  scale: 0.85,
                  child: Switch(
                    value: controller.enableTranscriptEmails.value,
                    onChanged: (val) => controller.enableTranscriptEmails.value = val,
                    activeTrackColor: const Color(0xFF0284C7),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enable Transcript Emails to Visitors', style: _labelStyle(isDark)),
                    Text(
                      'Allows visitors to email themselves the complete chat transcript after the conversation.',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Require Opt-In for Transcripts
          Row(
            children: [
              Obx(
                () => Transform.scale(
                  scale: 0.85,
                  child: Switch(
                    value: controller.requireOptInTranscripts.value,
                    onChanged: (val) => controller.requireOptInTranscripts.value = val,
                    activeTrackColor: const Color(0xFF0284C7),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Require Explicit GDPR Opt-In', style: _labelStyle(isDark)),
                    Text(
                      'Displays a cookie/privacy consent banner before recording chat histories.',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Save Privacy Button
          SizedBox(
            width: 190,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: controller.savePrivacy,
              icon: const Icon(Icons.shield_rounded, size: 15, color: Colors.white),
              label: const Text(
                'Save Privacy Settings',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // REUSABLE UI BUILDERS & HELPERS
  // ==========================================
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required Color accentColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: accentColor),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            height: 1.4,
            color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContainer({required bool isDark, required Widget child}) {
    return CustomCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      borderColor: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
      child: child,
    );
  }

  Widget _buildPillToggle(
    String label,
    bool isSelected,
    VoidCallback onTap,
    bool isDark,
    Color activeColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14, color: AppColors.secondary)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle(bool isDark) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF334155),
    );
  }

  BoxDecoration _dropdownContainerDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
      ),
    );
  }

  Widget _buildSettingsTextField(TextEditingController ctrl, bool isDark) {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: ctrl,
        style: TextStyle(
          fontSize: 13,
          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE2E8F0),
            ),
          ),
        ),
      ),
    );
  }
}
