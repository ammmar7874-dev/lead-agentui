import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/user_shared_controller.dart';

class VisitorItem {
  final String id;
  final String avatarLetter;
  final Color avatarColor;
  final String name;
  final String timeAgo;
  final int messageCount;
  final String site;
  final bool hasLead;
  final List<Map<String, String>> chatHistory;

  VisitorItem({
    required this.id,
    required this.avatarLetter,
    required this.avatarColor,
    required this.name,
    required this.timeAgo,
    required this.messageCount,
    required this.site,
    this.hasLead = false,
    required this.chatHistory,
  });
}

class VisitorsView extends StatefulWidget {
  const VisitorsView({super.key});

  @override
  State<VisitorsView> createState() => _VisitorsViewState();
}

class _VisitorsViewState extends State<VisitorsView> {
  final TextEditingController _searchController = TextEditingController();
  final RxInt _selectedVisitorIndex = 0.obs;

  final List<VisitorItem> _visitors = [
    VisitorItem(
      id: 'vis_8f921',
      avatarLetter: 'E',
      avatarColor: const Color(0xFFF59E0B),
      name: 'Anonymous Visitor #8f921',
      timeAgo: '2m ago',
      messageCount: 0,
      site: 'Excels_Tech Widget',
      chatHistory: [],
    ),
    VisitorItem(
      id: 'vis_a4102',
      avatarLetter: 'A',
      avatarColor: const Color(0xFFF97316),
      name: 'Anonymous Visitor #a4102',
      timeAgo: '3m ago',
      messageCount: 0,
      site: 'Excels_Tech Widget',
      chatHistory: [],
    ),
    VisitorItem(
      id: 'vis_09182',
      avatarLetter: '0',
      avatarColor: const Color(0xFFEAB308),
      name: 'Anonymous Visitor #09182',
      timeAgo: '6m ago',
      messageCount: 0,
      site: 'Excels_Tech Widget',
      chatHistory: [],
    ),
    VisitorItem(
      id: 'vis_38192',
      avatarLetter: '3',
      avatarColor: const Color(0xFFF59E0B),
      name: 'Anonymous Visitor #38192',
      timeAgo: '7m ago',
      messageCount: 4,
      site: 'Excels_Tech Widget',
      hasLead: true,
      chatHistory: [
        {'sender': 'user', 'text': 'Hello, what are your pricing plans for enterprise?'},
        {'sender': 'bot', 'text': 'We offer Starter, Professional, and Custom Enterprise RAG plans. Enterprise includes dedicated vector database and custom fine-tuning.'},
        {'sender': 'user', 'text': 'Can I book a demo with your sales engineer?'},
        {'sender': 'bot', 'text': 'Certainly! Please leave your email or use our calendar widget.'},
      ],
    ),
    VisitorItem(
      id: 'vis_c8192',
      avatarLetter: 'C',
      avatarColor: const Color(0xFFF59E0B),
      name: 'Anonymous Visitor #c8192',
      timeAgo: '9m ago',
      messageCount: 0,
      site: 'Excels_Tech Widget',
      chatHistory: [],
    ),
    VisitorItem(
      id: 'vis_81923',
      avatarLetter: '8',
      avatarColor: const Color(0xFFF59E0B),
      name: 'Anonymous Visitor #81923',
      timeAgo: '11m ago',
      messageCount: 2,
      site: 'Excels_Tech Widget',
      chatHistory: [
        {'sender': 'user', 'text': 'Does this integrate with Shopify?'},
        {'sender': 'bot', 'text': 'Yes! You can embed the widget on Shopify by pasting the script snippet into your theme.liquid.'},
      ],
    ),
    VisitorItem(
      id: 'vis_61902',
      avatarLetter: '6',
      avatarColor: const Color(0xFFF97316),
      name: 'Anonymous Visitor #61902',
      timeAgo: '11m ago',
      messageCount: 0,
      site: 'Excels_Tech Widget',
      chatHistory: [],
    ),
    VisitorItem(
      id: 'vis_51928',
      avatarLetter: '5',
      avatarColor: const Color(0xFFF59E0B),
      name: 'Anonymous Visitor #51928',
      timeAgo: '11m ago',
      messageCount: 0,
      site: 'Excels_Tech Widget',
      chatHistory: [],
    ),
    VisitorItem(
      id: 'vis_f1092',
      avatarLetter: 'F',
      avatarColor: const Color(0xFFF59E0B),
      name: 'Anonymous Visitor #f1092',
      timeAgo: '12m ago',
      messageCount: 0,
      site: 'Excels_Tech Widget',
      chatHistory: [],
    ),
    VisitorItem(
      id: 'vis_81920',
      avatarLetter: '8',
      avatarColor: const Color(0xFFF59E0B),
      name: 'Anonymous Visitor #81920',
      timeAgo: '12m ago',
      messageCount: 0,
      site: 'Excels_Tech Widget',
      chatHistory: [],
    ),
    VisitorItem(
      id: 'vis_a8192',
      avatarLetter: 'A',
      avatarColor: const Color(0xFFF97316),
      name: 'Anonymous Visitor #a8192',
      timeAgo: '13m ago',
      messageCount: 0,
      site: 'Excels_Tech Widget',
      chatHistory: [],
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
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Visitors',
            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                size: 22,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              onPressed: () {
                PlatformHelper.lightHaptic();
                Get.snackbar('Refreshed', 'Live visitor data synchronized', snackPosition: SnackPosition.BOTTOM);
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            // Top Summary Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  _buildPillStat(Icons.people_alt_outlined, '301 Total Visitors', isDark),
                  const SizedBox(width: 8),
                  _buildPillStat(Icons.chat_bubble_outline_rounded, '168 Messages', isDark),
                  const SizedBox(width: 8),
                  _buildPillStat(Icons.stars_rounded, '3 Leads', isDark, color: AppColors.secondaryLight),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search visitors...',
                    hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 13),
                    prefixIcon: Icon(Icons.search_rounded, size: 18, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Visitor List & Preview Section
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                itemCount: _visitors.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final visitor = _visitors[index];
                  final isSelected = _selectedVisitorIndex.value == index;

                  return GestureDetector(
                    onTap: () {
                      PlatformHelper.lightHaptic();
                      _selectedVisitorIndex.value = index;
                      _showVisitorDetailSheet(context, visitor, isDark);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? AppColors.darkSurface : AppColors.lightCardHover)
                            : (isDark ? AppColors.darkCard : AppColors.lightSurface),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Avatar Letter
                          Container(
                            width: 38,
                            height: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: visitor.avatarColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              visitor.avatarLetter,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Anonymous',
                                      style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    Text(
                                      visitor.timeAgo,
                                      style: TextStyle(
                                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  visitor.messageCount == 0
                                      ? 'No messages yet'
                                      : '${visitor.messageCount} messages exchanged',
                                  style: TextStyle(
                                    color: visitor.messageCount > 0
                                        ? AppColors.primaryLight
                                        : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                    fontSize: 11,
                                    fontWeight: visitor.messageCount > 0 ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (visitor.hasLead) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.secondarySoft,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'LEAD',
                                style: TextStyle(color: AppColors.secondaryLight, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: (index * 30).ms);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPillStat(IconData icon, String label, bool isDark, {Color? color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVisitorDetailSheet(BuildContext context, VisitorItem visitor, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: visitor.avatarColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          visitor.avatarLetter,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              visitor.name,
                              style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${visitor.messageCount} msgs • ${visitor.timeAgo} • ${visitor.site}',
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          visitor.site,
                          style: const TextStyle(color: AppColors.primaryLight, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Chat Conversation History',
                    style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: visitor.chatHistory.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AppColors.darkTextMuted),
                                const SizedBox(height: 12),
                                Text(
                                  'No messages yet',
                                  style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'This visitor has not sent any messages in this session.',
                                  style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            controller: scrollController,
                            itemCount: visitor.chatHistory.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final msg = visitor.chatHistory[index];
                              final isUser = msg['sender'] == 'user';

                              return Align(
                                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                                  decoration: BoxDecoration(
                                    color: isUser
                                        ? AppColors.primary
                                        : (isDark ? AppColors.darkCard : AppColors.lightCardHover),
                                    borderRadius: BorderRadius.circular(14),
                                    border: isUser ? null : Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                                  ),
                                  child: Text(
                                    msg['text'] ?? '',
                                    style: TextStyle(
                                      color: isUser ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
