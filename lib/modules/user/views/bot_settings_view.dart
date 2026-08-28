import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/user_shared_controller.dart';

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

  // 4: Integration State (Screenshot 1)
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

  // 5: Notifications State (Screenshot 2)
  final RxBool enableLeadNotifications = true.obs;
  final notificationEmailController = TextEditingController(text: 'alerts@company.com');

  // 6: Placement State (Screenshot 3)
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

  // 7: Privacy State (Screenshot 4)
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
    '#E60000', // Crimson Red (Screenshot)
    '#0284C7', // Ocean Sapphire
    '#10B981', // Emerald
    '#8B5CF6', // Royal Purple
    '#F59E0B', // Amber
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
        siteName: 'AI LEAD GEN Industry level',
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

  void saveConfiguration() {
    PlatformHelper.mediumHaptic();
    Get.snackbar(
      'Configuration Saved',
      'Bot customizations, quick actions, and integrations synced live.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void saveNotifications() {
    PlatformHelper.mediumHaptic();
    Get.snackbar(
      'Notifications Saved',
      'Lead alerts routed to ${notificationEmailController.text}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void savePlacement() {
    PlatformHelper.mediumHaptic();
    Get.snackbar(
      'Placement Saved',
      'Widget position updated to ${selectedPosition.value}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void savePrivacy() {
    PlatformHelper.mediumHaptic();
    Get.snackbar(
      'Privacy Settings Saved',
      'Data retention policies updated successfully.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> sendTestMessage() async {
    final text = testInputController.text.trim();
    if (text.isEmpty || isTestBotTyping.value) return;

    PlatformHelper.lightHaptic();
    testMessages.add({'sender': 'user', 'text': text, 'time': 'Just now'});
    testInputController.clear();
    _scrollTestToBottom();

    isTestBotTyping.value = true;
    await Future.delayed(const Duration(milliseconds: 600));

    String botReply = 'I am grounded in your connected sources. For "$text", our team delivers end-to-end AI solutions with 99.9% uptime.';
    if (text.toLowerCase().contains('service') || text.toLowerCase().contains('help')) {
      botReply = 'Of course! We would be happy to help you with MVP development, AI agents, and RAG knowledge systems.';
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
            'Bot Settings',
            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.save_rounded,
                size: 22,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              onPressed: controller.saveConfiguration,
              tooltip: 'Save Configuration',
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sub-Tabs Navigation Bar (From Screenshot)
            _buildSubTabsBar(controller, isDark),

            // Tab Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
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
          ],
        ),
      );
    });
  }

  // ==========================================
  // 1: SUB-TABS NAVIGATION BAR
  // ==========================================
  Widget _buildSubTabsBar(BotSettingsController controller, bool isDark) {
    final tabs = [
      {'key': 'customization', 'label': 'Customization', 'icon': Icons.tune_rounded},
      {'key': 'test_bot', 'label': 'Test Your Bot', 'icon': Icons.chat_bubble_outline_rounded},
      {'key': 'quick_actions', 'label': 'Quick Actions', 'icon': Icons.grid_view_rounded},
      {'key': 'integration', 'label': 'Integration', 'icon': Icons.code_rounded},
      {'key': 'notifications', 'label': 'Notifications', 'icon': Icons.mail_outline_rounded},
      {'key': 'placement', 'label': 'Placement', 'icon': Icons.layers_outlined},
      {'key': 'privacy', 'label': 'Privacy', 'icon': Icons.security_outlined},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: tabs.map((tab) {
            final isSelected = controller.activeSubTab.value == tab['key'];
            final icon = tab['icon'] as IconData;
            final label = tab['label'] as String;

            return InkWell(
              onTap: () => controller.selectSubTab(tab['key'] as String),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: isSelected
                          ? (isDark ? Colors.white : AppColors.primary)
                          : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? (isDark ? Colors.white : AppColors.primary)
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==========================================
  // 2: TAB 1 - CUSTOMIZATION (DESIGN & CONTENT)
  // ==========================================
  Widget _buildCustomizationTab(BotSettingsController controller, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 850;

        final formSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Design & Content',
              style: AppTextStyles.titleLarge(isDark: isDark).copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Assistant Name
            Text(
              'Assistant Name',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 6),
            CustomTextField(
              controller: controller.assistantNameController,
              hint: 'Support Team',
              onChanged: (_) => controller.update(),
            ),

            const SizedBox(height: 16),

            // Welcome Message & Mode Pill Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: AppColors.primaryLight),
                    const SizedBox(width: 6),
                    Text(
                      'Welcome Message',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                // Templates vs Custom Toggle Pills
                Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      _buildPillTab('Templates', controller.welcomeMode.value == 'Templates', () {
                        controller.welcomeMode.value = 'Templates';
                        controller.welcomeMessageController.text = 'Hello! Welcome to ExcelsTech. How can our AI assistant assist you today?';
                      }, isDark),
                      _buildPillTab('Custom', controller.welcomeMode.value == 'Custom', () {
                        controller.welcomeMode.value = 'Custom';
                      }, isDark),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            TextField(
              controller: controller.welcomeMessageController,
              maxLines: 3,
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              decoration: InputDecoration(
                hintText: 'Hi! How can I help you today?',
                hintStyle: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                filled: true,
                fillColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Theme Color Swatch & Palette (From Screenshot #E60000)
            Text(
              'Theme Color',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: controller.currentColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  controller.selectedThemeColor.value,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controller.availableColors.map((hex) {
                        final isSel = controller.selectedThemeColor.value == hex;
                        final color = Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));

                        return GestureDetector(
                          onTap: () => controller.selectThemeColor(hex),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSel ? Colors.white : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: isSel
                                  ? [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 6)]
                                  : null,
                            ),
                            child: isSel
                                ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Bot Icon Selection Grid (24 Icons from Screenshot)
            Row(
              children: [
                const Icon(Icons.face_rounded, size: 14, color: AppColors.primaryLight),
                const SizedBox(width: 6),
                Text(
                  'Bot Icon',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
              ),
              child: GridView.builder(
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
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primarySoft
                            : (isDark ? AppColors.darkSurface : AppColors.lightBackground),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(icon, style: const TextStyle(fontSize: 20)),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Custom Icon Upload
            Text(
              'Custom Icon (upload image)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    PlatformHelper.lightHaptic();
                    controller.hasCustomIcon.value = true;
                    Get.snackbar('Image Uploaded', 'Custom mascot uploaded', snackPosition: SnackPosition.BOTTOM);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: const Text('Choose File', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 10),
                Text(
                  controller.hasCustomIcon.value ? 'mascot.png' : 'No file chosen',
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ],
            ),
            if (controller.hasCustomIcon.value) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('🤖', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => controller.hasCustomIcon.value = false,
                    child: const Text('Remove', style: TextStyle(fontSize: 11, color: AppColors.error)),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Save Configuration Button (Screenshot)
            SizedBox(
              width: 200,
              height: 42,
              child: ElevatedButton.icon(
                onPressed: controller.saveConfiguration,
                icon: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
                label: const Text('Save Configuration', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        );

        final previewSection = _buildLiveWidgetPreviewBox(controller, isDark);

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
            const SizedBox(height: 28),
            previewSection,
          ],
        );
      },
    );
  }

  Widget _buildPillTab(String label, bool isSelected, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0284C7) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }

  // Live Interactive Preview Widget Box (Screenshot 1 Right Pane)
  Widget _buildLiveWidgetPreviewBox(BotSettingsController controller, bool isDark) {
    final themeColor = controller.currentColor;
    final botName = controller.assistantNameController.text.isNotEmpty ? controller.assistantNameController.text : 'Support Team';
    final welcome = controller.welcomeMessageController.text.isNotEmpty ? controller.welcomeMessageController.text : 'Hi! How can I help you today?';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Red Header (Screenshot 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: themeColor,
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Text(controller.selectedBotIcon.value, style: const TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      botName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),

            // Live Chat Bubbles
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Assistant Welcome Bubble
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                      ),
                      child: Text(
                        welcome,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // User Response Bubble
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: BorderRadius.circular(12),
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

                  const SizedBox(height: 12),

                  // Assistant Response Bubble
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                      ),
                      child: Text(
                        "Of course! We'd be happy to help..",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Input Box Simulation
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Type a message...',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
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
  // 3: TAB 2 - TEST YOUR BOT
  // ==========================================
  Widget _buildTestBotTab(BotSettingsController controller, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;

        final chatTester = Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Column(
              children: [
                // Top Header (Red header with Online & Reset icon)
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
                              controller.assistantNameController.text.isNotEmpty ? controller.assistantNameController.text : 'Support Team',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 4),
                                const Text('Online', style: TextStyle(fontSize: 10, color: Colors.white70)),
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

                // Messages Stream
                Container(
                  height: 340,
                  padding: const EdgeInsets.all(16),
                  color: isDark ? AppColors.darkBackground : const Color(0xFFFAFAFA),
                  child: Obx(() {
                    return ListView.builder(
                      controller: controller.testScrollController,
                      itemCount: controller.testMessages.length,
                      itemBuilder: (context, index) {
                        final msg = controller.testMessages[index];
                        final isUser = msg['sender'] == 'user';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(
                                color: isUser ? controller.currentColor : (isDark ? AppColors.darkSurface : Colors.white),
                                borderRadius: BorderRadius.circular(12),
                                border: isUser ? null : Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                              ),
                              child: Text(
                                msg['text'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isUser ? Colors.white : (isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2937)),
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
                    border: Border(top: BorderSide(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.testInputController,
                          onSubmitted: (_) => controller.sendTestMessage(),
                          style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            filled: true,
                            fillColor: isDark ? AppColors.darkCard : const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: controller.sendTestMessage,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: controller.currentColor,
                            borderRadius: BorderRadius.circular(8),
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

        final instructionsCard = CustomCard(
          padding: const EdgeInsets.all(20),
          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'How to Test',
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Use this chat panel to test your bot\'s responses in real-time. Messages are sent through the same AI pipeline your website visitors will use.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 16),
              _buildBulletItem('Test different types of questions', isDark),
              _buildBulletItem('Verify the welcome message appears correctly', isDark),
              _buildBulletItem('Check response quality and accuracy', isDark),
              _buildBulletItem('Try edge cases and unusual queries', isDark),
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

  Widget _buildBulletItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 14, color: isDark ? AppColors.darkTextSecondary : const Color(0xFF4B5563))),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF4B5563),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4: TAB 3 - QUICK ACTIONS
  // ==========================================
  Widget _buildQuickActionsTab(BotSettingsController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions (functionality cards)',
          style: AppTextStyles.titleLarge(isDark: isDark).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Each crawled website\'s main services are detected separately and shown on the widget\'s home screen for that site. Turn one OFF to hide its card on that website — visitors can still get the answer if they type the question.',
          style: TextStyle(
            fontSize: 12,
            height: 1.5,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),

        const SizedBox(height: 20),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.quickActionGroups.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final group = controller.quickActionGroups[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.language_rounded, size: 18, color: AppColors.primaryLight),
                        const SizedBox(width: 8),
                        Text(
                          group.siteName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          group.domain,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => Text(
                        '${group.shownCount}/${group.items.length} shown',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: group.items.length,
                    separatorBuilder: (context, idx) => Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                    ),
                    itemBuilder: (context, idx) {
                      final item = group.items[idx];

                      return Obx(() {
                        final isShown = item.isShown.value;

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurface : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(8),
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
                                            ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                                            : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                isShown ? 'Shown' : 'Hidden',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isShown ? const Color(0xFF0284C7) : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
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
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ==========================================
  // 5: TAB 4 - INTEGRATION (SCREENSHOT 1)
  // ==========================================
  Widget _buildIntegrationTab(BotSettingsController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1: Widget Embed Code Card
        CustomCard(
          padding: const EdgeInsets.all(20),
          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('📑', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Widget Embed Code',
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Copy and paste this code just before the closing </body> tag in your website\'s index.html file. The key is already included — just copy and paste!',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF4B5563),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),

              // Metadata Row: Active Badge, Site, Key
              Row(
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
                  const SizedBox(width: 12),
                  Text(
                    'Site: ${controller.widgetSiteName}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Key: ${controller.widgetApiKey}',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: isDark ? AppColors.darkTextMuted : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Code Snippet Box with Copy Button
              Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        controller.embedSnippet,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: controller.embedSnippet));
                        PlatformHelper.lightHaptic();
                        Get.snackbar('Copied', 'Widget embed snippet copied to clipboard', snackPosition: SnackPosition.BOTTOM);
                      },
                      icon: const Icon(Icons.copy_rounded, size: 14, color: Color(0xFF4B5563)),
                      label: const Text('Copy', style: TextStyle(fontSize: 12, color: Color(0xFF4B5563), fontWeight: FontWeight.w600)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Allowed Websites Section
              Row(
                children: [
                  const Text('🌐', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    'Allowed Websites',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    ' — added automatically when you crawl a website',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextMuted : const Color(0xFF6B7280),
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
                      color: isDark ? AppColors.darkSurface : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB)),
                    ),
                    child: Text(
                      url,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : const Color(0xFF4B5563),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),
              Text(
                'This widget works on all of your organization\'s crawled websites — one script, everywhere. No manual setup needed.',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextMuted : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2: Installation Steps Card
        CustomCard(
          padding: const EdgeInsets.all(20),
          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🔧', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    'Installation Steps',
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildStepItem('1', 'Copy the script tag above (key is already included!)', isDark),
              _buildStepItem('2', 'Open your website\'s index.html file', isDark),
              _buildStepItem('3', 'Paste the code inside the <body> tag (before </body>)', isDark),
              _buildStepItem('4', 'Save and refresh your website', isDark),
              _buildStepItem('5', 'The chat widget will appear in the bottom-right corner 🎉', isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(String num, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$num. ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2937))),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF4B5563),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 6: TAB 5 - NOTIFICATIONS (SCREENSHOT 2)
  // ==========================================
  Widget _buildNotificationsTab(BotSettingsController controller, bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📧', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Lead Notification Email',
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Order/Lead Email Notifications Toggle
          Text(
            'Order/Lead Email Notifications',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final isEnabled = controller.enableLeadNotifications.value;

            return Row(
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
                Text(
                  isEnabled ? '✅ ON — Emails will be sent when orders/leads are captured' : 'OFF — No email alerts',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isEnabled ? const Color(0xFF16A34A) : (isDark ? AppColors.darkTextMuted : const Color(0xFF6B7280)),
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 20),

          // Email Address Input
          Text(
            'Email Address',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller.notificationEmailController,
            style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2937)),
            decoration: InputDecoration(
              hintText: 'alerts@company.com',
              filled: true,
              fillColor: isDark ? AppColors.darkBackground : const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB))),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Receive an email whenever a new lead is captured',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkTextMuted : const Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: 100,
            height: 38,
            child: ElevatedButton(
              onPressed: controller.saveNotifications,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text('Save', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 7: TAB 6 - PLACEMENT (SCREENSHOT 3)
  // ==========================================
  Widget _buildPlacementTab(BotSettingsController controller, bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📐', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Widget Placement',
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Row 1: Position & Z-Index
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Position', style: _formLabelStyle(isDark)),
                    const SizedBox(height: 6),
                    Obx(
                      () => Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: _dropdownContainerDecoration(isDark),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.selectedPosition.value,
                            isExpanded: true,
                            dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                            items: controller.positionOptions.map((pos) {
                              return DropdownMenuItem<String>(value: pos, child: Text(pos, style: const TextStyle(fontSize: 13)));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) controller.selectedPosition.value = val;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Z-Index', style: _formLabelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.zIndexController, isDark),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Row 2: Offset X & Offset Y
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Offset X (px)', style: _formLabelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.offsetXController, isDark),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Offset Y (px)', style: _formLabelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.offsetYController, isDark),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Row 3: Auto-Open Mode & Auto-Open Delay
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Auto-Open Mode', style: _formLabelStyle(isDark)),
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
                              return DropdownMenuItem<String>(value: opt, child: Text(opt, style: const TextStyle(fontSize: 13)));
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Auto-Open Delay (ms)', style: _formLabelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.autoOpenDelayController, isDark),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Row 4: Hide widget on these pages
          Row(
            children: [
              const Text('🚫', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                'Hide widget on these pages (internal panels)',
                style: _formLabelStyle(isDark),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller.hiddenPagesController,
            maxLines: 4,
            style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2937)),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? AppColors.darkBackground : const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB))),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'One per line. The widget won\'t load on these pages — great for post-login user panels/dashboards. Use a path like /dashboard (hides that page and everything under it, on every site), or a domain like app.yoursite.com (hides that whole site/subdomain). Public pages keep showing the widget. No website code changes needed.',
            style: TextStyle(
              fontSize: 11,
              height: 1.4,
              color: isDark ? AppColors.darkTextMuted : const Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 24),

          // Save Placement Button
          SizedBox(
            width: 140,
            height: 38,
            child: ElevatedButton(
              onPressed: controller.savePlacement,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text('Save Placement', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 8: TAB 7 - PRIVACY (SCREENSHOT 4)
  // ==========================================
  Widget _buildPrivacyTab(BotSettingsController controller, bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔒', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Privacy & Data Retention',
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Row 1: Privacy Policy URL & Visitor Retention
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Privacy Policy URL', style: _formLabelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.privacyPolicyUrlController, isDark),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Visitor Retention (days, 0 = forever)', style: _formLabelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.visitorRetentionController, isDark),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Row 2: Conversation Retention & Transcript Retention
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Conversation Retention (days, 0 = forever)', style: _formLabelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.conversationRetentionController, isDark),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transcript Retention (days)', style: _formLabelStyle(isDark)),
                    const SizedBox(height: 6),
                    _buildSettingsTextField(controller.transcriptRetentionController, isDark),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Row 3: Enable Transcript Emails
          Text('Enable Transcript Emails', style: _formLabelStyle(isDark)),
          const SizedBox(height: 6),
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

          const SizedBox(height: 14),

          // Row 4: Require Opt-In for Transcripts
          Text('Require Opt-In for Transcripts', style: _formLabelStyle(isDark)),
          const SizedBox(height: 6),
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

          const SizedBox(height: 24),

          // Save Privacy Settings Button
          SizedBox(
            width: 170,
            height: 38,
            child: ElevatedButton(
              onPressed: controller.savePrivacy,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text('Save Privacy Settings', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // HELPERS
  // ==========================================
  TextStyle _formLabelStyle(bool isDark) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF374151),
    );
  }

  BoxDecoration _dropdownContainerDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? AppColors.darkBackground : const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB)),
    );
  }

  Widget _buildSettingsTextField(TextEditingController ctrl, bool isDark) {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: ctrl,
        style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2937)),
        decoration: InputDecoration(
          filled: true,
          fillColor: isDark ? AppColors.darkBackground : const Color(0xFFF9FAFB),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDark ? AppColors.darkBorderSubtle : const Color(0xFFE5E7EB))),
        ),
      ),
    );
  }
}
