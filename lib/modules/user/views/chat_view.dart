import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/chat_controller.dart';
import '../controllers/user_shared_controller.dart';
import '../models/chat_message_model.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedController = Get.find<UserSharedController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 840;

        return Obx(() {
          final isDark = sharedController.isDarkMode.value;
          final isDetail = controller.isViewingChatDetail.value;

          return Scaffold(
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            body: Stack(
              children: [
                isWide
                    ? Row(
                        children: [
                          // Master List Pane (Left sidebar on desktop/tablet)
                          SizedBox(
                            width: 300,
                            child: _buildSessionsListPane(isDark, isWide: true, context: context),
                          ),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                          ),
                          // Detail Conversation Pane (Right on desktop/tablet)
                          Expanded(
                            child: _buildChatConversationPane(isDark, isWide: true, context: context),
                          ),
                        ],
                      )
                    : (isDetail
                        ? _buildChatConversationPane(isDark, isWide: false, context: context)
                        : _buildSessionsListPane(isDark, isWide: false, context: context)),

                // Citation Slide-over Overlay if opened
                if (controller.showCitationsDrawer.value && controller.selectedCitation.value != null)
                  _buildCitationOverlay(isDark, context),
              ],
            ),
          );
        });
      },
    );
  }

  // =========================================================================
  // 1: SESSIONS LIST PANE (ALL CHATS LIST)
  // =========================================================================
  Widget _buildSessionsListPane(bool isDark, {required bool isWide, required BuildContext context}) {
    return Container(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Column(
        children: [
          // Header & New Chat Button
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, size: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RAG Assistant',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
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
                              const SizedBox(width: 5),
                              Text(
                                'Engine Online',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: ElevatedButton.icon(
                    onPressed: controller.createNewSession,
                    icon: const Icon(Icons.add_rounded, size: 17, color: Colors.white),
                    label: const Text(
                      'New Conversation',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                ),
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: (val) => controller.searchQuery.value = val,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  hintText: 'Search chats...',
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    fontSize: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 16,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                  suffixIcon: controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 14),
                          onPressed: () {
                            controller.searchController.clear();
                            controller.searchQuery.value = '';
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Chat Sessions List
          Expanded(
            child: Obx(() {
              final list = controller.filteredSessions;

              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 32,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No conversations',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                itemCount: list.length,
                separatorBuilder: (context, index) => const SizedBox(height: 3),
                itemBuilder: (context, index) {
                  final session = list[index];
                  final isSelected = isWide && session.id == controller.activeSessionId.value;

                  return _buildSessionItem(session, isSelected, isDark, context);
                },
              );
            }),
          ),

          // Compact Status Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard.withValues(alpha: 0.3) : AppColors.lightCardHover,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.storage_rounded, size: 13, color: AppColors.primaryLight),
                    const SizedBox(width: 5),
                    Text(
                      'Postgres PgVector',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '18.4k vectors',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem(ChatSessionModel session, bool isSelected, bool isDark, BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => controller.selectSession(session.id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primarySoft
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                session.isPinned ? Icons.push_pin_rounded : Icons.chat_bubble_outline_rounded,
                size: 15,
                color: session.isPinned
                    ? AppColors.warning
                    : (isSelected
                        ? AppColors.primaryLight
                        : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? (isDark ? AppColors.primaryLight : AppColors.primary)
                            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      session.lastMessagePreview,
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
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_horiz_rounded,
                  size: 16,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(maxWidth: 150),
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                onSelected: (val) {
                  if (val == 'pin') {
                    controller.togglePinSession(session.id);
                  } else if (val == 'rename') {
                    _showRenameDialog(session, isDark);
                  } else if (val == 'delete') {
                    controller.deleteSession(session.id);
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'pin',
                    child: Row(
                      children: [
                        Icon(session.isPinned ? Icons.push_pin_outlined : Icons.push_pin_rounded, size: 14, color: AppColors.warning),
                        const SizedBox(width: 8),
                        Text(session.isPinned ? 'Unpin' : 'Pin', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 14, color: AppColors.secondaryLight),
                        SizedBox(width: 8),
                        Text('Rename', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, size: 14, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(fontSize: 12, color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRenameDialog(ChatSessionModel session, bool isDark) {
    final textEdit = TextEditingController(text: session.title);
    Get.dialog(
      Dialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rename Conversation',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textEdit,
                autofocus: true,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'New title...',
                  filled: true,
                  fillColor: isDark ? AppColors.darkCard : AppColors.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      controller.renameSession(session.id, textEdit.text);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 2: CHAT CONVERSATION DETAIL PANE
  // =========================================================================
  Widget _buildChatConversationPane(bool isDark, {required bool isWide, required BuildContext context}) {
    return Obx(() {
      final active = controller.activeSession;
      final messages = active?.messages ?? [];

      return Column(
        children: [
          // Top Header Bar
          _buildConversationHeader(active, isDark, isWide: isWide),

          // Message Stream or Hero State
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyConversationState(isDark)
                : ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.fromLTRB(isWide ? 20 : 12, 14, isWide ? 20 : 12, 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return _buildMessageBubble(msg, isDark, isWide: isWide);
                    },
                  ),
          ),

          // Bottom Input Console
          _buildBottomInputConsole(isDark, isWide: isWide),
        ],
      );
    });
  }

  Widget _buildConversationHeader(ChatSessionModel? active, bool isDark, {required bool isWide}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 18 : 12, vertical: 8),
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
          Expanded(
            child: Row(
              children: [
                if (!isWide)
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 17,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                    onPressed: controller.backToSessionsList,
                    tooltip: 'All Conversations',
                  ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        active?.title ?? 'New Conversation',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isWide ? 15 : 13.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${active?.modelMode ?? "Balanced (4o)"} · Grounded in ${active?.sourceMode ?? "Auto (RAG)"}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Telemetry Toggle Pill
              InkWell(
                onTap: controller.toggleDebugMode,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  decoration: BoxDecoration(
                    color: controller.debugMode.value
                        ? AppColors.primarySoft
                        : (isDark ? AppColors.darkCard : AppColors.lightBackground),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: controller.debugMode.value
                          ? AppColors.primary.withValues(alpha: 0.5)
                          : (isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.insights_rounded,
                        size: 13,
                        color: controller.debugMode.value
                            ? AppColors.primaryLight
                            : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      ),
                      if (isWide) ...[
                        const SizedBox(width: 4),
                        Text(
                          'Telemetry',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: controller.debugMode.value
                                ? AppColors.primaryLight
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),

              IconButton(
                icon: Icon(
                  Icons.ios_share_rounded,
                  size: 17,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                onPressed: controller.exportTranscript,
                tooltip: 'Export Transcript',
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
              ),

              IconButton(
                icon: Icon(
                  Icons.delete_sweep_outlined,
                  size: 19,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                onPressed: () {
                  if (active?.messages.isNotEmpty ?? false) {
                    controller.clearConversation();
                  }
                },
                tooltip: 'Clear Messages',
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 3: EMPTY CONVERSATION HERO STATE
  // =========================================================================
  Widget _buildEmptyConversationState(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Clean Glowing AI Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.auto_awesome_rounded, size: 28, color: Colors.white),
                ),
              ).animate().scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 300.ms),
              const SizedBox(height: 14),
              Text(
                'AI RAG Assistant',
                style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ask questions grounded in your PostgreSQL vectors and synced documents.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 20),

              // Inspiration Prompts
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Suggested Prompts',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              LayoutBuilder(
                builder: (ctx, box) {
                  final prompts = controller.quickPrompts;
                  final isTwoCol = box.maxWidth >= 480;

                  if (isTwoCol) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: prompts.length,
                      itemBuilder: (ctx, i) => _buildPromptCard(prompts[i], isDark),
                    );
                  }

                  return Column(
                    children: prompts.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _buildPromptCard(p, isDark),
                    )).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptCard(Map<String, dynamic> item, bool isDark) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => controller.applyQuickPrompt(item['prompt'] as String),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(item['icon'] as IconData, size: 14, color: AppColors.primaryLight),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_outward_rounded, size: 13, color: AppColors.primaryLight),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item['prompt'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 4: MESSAGE BUBBLE BUILDER
  // =========================================================================
  Widget _buildMessageBubble(ChatMessageModel message, bool isDark, {required bool isWide}) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Assistant Icon
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.auto_awesome_rounded, size: 14, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
          ],

          // Bubble Container
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWide ? 680 : double.infinity),
              child: Column(
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Assistant Badge
                  if (!isUser)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message.modelUsed ?? 'AI RAG Engine',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryLight,
                            ),
                          ),
                          if (message.latencyMs != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              '${message.latencyMs}ms',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'monospace',
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                  // Message Card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.primary
                          : (isDark ? AppColors.darkCard : AppColors.lightSurface),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14),
                        topRight: const Radius.circular(14),
                        bottomLeft: Radius.circular(isUser ? 14 : 3),
                        bottomRight: Radius.circular(isUser ? 3 : 14),
                      ),
                      border: isUser
                          ? null
                          : Border.all(
                              color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                            ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Attachments if any
                        if (isUser && message.attachments.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Wrap(
                              spacing: 5,
                              runSpacing: 4,
                              children: message.attachments.map((att) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.attach_file_rounded, size: 11, color: Colors.white),
                                      const SizedBox(width: 3),
                                      Text(
                                        att.name,
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                        // Formatted Text / Code Blocks
                        _buildMessageContent(message, isDark, isUser),

                        // Streaming Step Ticker
                        if (message.isStreaming)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryLight,
                                    shape: BoxShape.circle,
                                  ),
                                ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                                      begin: const Offset(0.6, 0.6),
                                      end: const Offset(1.3, 1.3),
                                      duration: 400.ms,
                                    ),
                                const SizedBox(width: 5),
                                Text(
                                  message.streamingStep ?? 'Grounded retrieval in progress...',
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Citations Pills
                  if (!isUser && message.citations.isNotEmpty && !message.isStreaming)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 4,
                        children: message.citations.map((c) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () => controller.openCitationDetail(c),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.35),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.menu_book_rounded, size: 11, color: AppColors.primaryLight),
                                  const SizedBox(width: 4),
                                  Text(
                                    c.title,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  // Action Buttons (Copy, TTS, Feedback, Regenerate)
                  if (!isUser && !message.isStreaming)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 13),
                            onPressed: () => controller.copyMessageText(message.text),
                            tooltip: 'Copy',
                            constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                            padding: EdgeInsets.zero,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                          IconButton(
                            icon: Icon(
                              message.isTtsPlaying ? Icons.volume_up_rounded : Icons.volume_mute_rounded,
                              size: 13,
                              color: message.isTtsPlaying ? AppColors.primaryLight : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                            ),
                            onPressed: () => controller.toggleTts(message.id),
                            tooltip: 'Read Aloud',
                            constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                            padding: EdgeInsets.zero,
                          ),
                          IconButton(
                            icon: Icon(
                              message.isLiked == true ? Icons.thumb_up_rounded : Icons.thumb_up_outlined,
                              size: 13,
                              color: message.isLiked == true ? AppColors.primaryLight : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                            ),
                            onPressed: () => controller.toggleMessageReaction(message.id, true),
                            tooltip: 'Helpful',
                            constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                            padding: EdgeInsets.zero,
                          ),
                          IconButton(
                            icon: Icon(
                              message.isLiked == false ? Icons.thumb_down_rounded : Icons.thumb_down_outlined,
                              size: 13,
                              color: message.isLiked == false ? AppColors.error : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                            ),
                            onPressed: () => controller.toggleMessageReaction(message.id, false),
                            tooltip: 'Not helpful',
                            constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: controller.regenerateLastResponse,
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.refresh_rounded, size: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Regenerate',
                                    style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Telemetry Box (Debug mode)
                  if (!isUser && controller.debugMode.value && !message.isStreaming)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                        ),
                      ),
                      child: Text(
                        'Telemetry: ${message.modelUsed} | Tokens: ${message.tokens ?? 0} | Latency: ${message.latencyMs ?? 0}ms',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontFamily: 'monospace',
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // User Avatar
          if (isUser) ...[
            const SizedBox(width: 10),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCardHover,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                ),
              ),
              child: Center(
                child: Text(
                  'U',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 180.ms);
  }

  Widget _buildMessageContent(ChatMessageModel message, bool isDark, bool isUser) {
    if (message.text.isEmpty && message.isStreaming) {
      return const SizedBox.shrink();
    }

    final rawText = message.text;

    if (rawText.contains('```')) {
      final parts = rawText.split('```');
      final widgets = <Widget>[];

      for (int i = 0; i < parts.length; i++) {
        if (i % 2 == 1) {
          final codeLines = parts[i].trim().split('\n');
          final lang = codeLines.isNotEmpty && !codeLines.first.contains(' ') ? codeLines.first : 'code';
          final codeBody = lang == codeLines.first && codeLines.length > 1
              ? codeLines.sublist(1).join('\n')
              : parts[i].trim();

          widgets.add(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E293B),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lang.toUpperCase(),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: AppColors.secondaryLight),
                        ),
                        InkWell(
                          onTap: () => controller.copyMessageText(codeBody),
                          child: const Row(
                            children: [
                              Icon(Icons.copy_rounded, size: 11, color: Colors.white70),
                              SizedBox(width: 4),
                              Text('Copy', style: TextStyle(fontSize: 10, color: Colors.white70)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SelectableText(
                      codeBody,
                      style: const TextStyle(fontSize: 11.5, fontFamily: 'monospace', color: Color(0xFF38BDF8), height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          if (parts[i].trim().isNotEmpty) {
            widgets.add(SelectableText(
              parts[i],
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isUser ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
            ));
          }
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      );
    }

    return SelectableText(
      rawText,
      style: TextStyle(
        fontSize: 13,
        height: 1.4,
        color: isUser ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      ),
    );
  }

  // =========================================================================
  // 5: BOTTOM INPUT CONSOLE (ZERO OVERFLOW HORIZONTAL SCROLL)
  // =========================================================================
  Widget _buildBottomInputConsole(bool isDark, {required bool isWide}) {
    return Container(
      padding: EdgeInsets.fromLTRB(isWide ? 18 : 10, 6, isWide ? 18 : 10, isWide ? 12 : 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Mode Selectors wrapped in SingleChildScrollView to prevent ANY overflow
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDropdownPicker(
                  value: controller.currentSourceMode.value,
                  items: controller.sourceModeOptions,
                  onChanged: (val) {
                    if (val != null) controller.setSourceMode(val);
                  },
                  isDark: isDark,
                  icon: Icons.layers_outlined,
                ),
                const SizedBox(width: 6),
                _buildDropdownPicker(
                  value: controller.currentModelMode.value,
                  items: controller.modelModeOptions,
                  onChanged: (val) {
                    if (val != null) controller.setModelMode(val);
                  },
                  isDark: isDark,
                  icon: Icons.speed_rounded,
                ),
                const SizedBox(width: 6),
                _buildAttachSourceButton(isDark),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Attached Files Tags
          Obx(() {
            final attachments = controller.pendingAttachments;
            if (attachments.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: attachments.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.attach_file_rounded, size: 11, color: AppColors.primaryLight),
                          const SizedBox(width: 4),
                          Text(
                            item.name,
                            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.primaryLight),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () => controller.removeAttachment(idx),
                            child: const Icon(Icons.close_rounded, size: 12, color: AppColors.primaryLight),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }),

          // Input Box + Mic + Send Button
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Mic Button
                Obx(() {
                  final isRec = controller.isRecordingVoice.value;
                  return IconButton(
                    icon: Icon(
                      isRec ? Icons.stop_circle_rounded : Icons.mic_rounded,
                      size: 18,
                      color: isRec ? AppColors.error : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                    onPressed: controller.toggleVoiceRecording,
                    tooltip: isRec ? 'Stop' : 'Voice',
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    padding: EdgeInsets.zero,
                  );
                }),

                // Text Input
                Expanded(
                  child: Obx(() {
                    if (controller.isRecordingVoice.value) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Listening (${controller.recordingSeconds.value}s)... Tap mic to send',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      );
                    }

                    return TextField(
                      controller: controller.inputController,
                      focusNode: controller.inputFocusNode,
                      minLines: 1,
                      maxLines: 3,
                      onSubmitted: (_) => controller.sendMessage(),
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ask anything grounded in your knowledge base...',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                        border: InputBorder.none,
                      ),
                    );
                  }),
                ),

                // Send / Stop Button
                Padding(
                  padding: const EdgeInsets.only(right: 5, bottom: 5),
                  child: Obx(() {
                    if (controller.isBotTyping.value) {
                      return SizedBox(
                        height: 32,
                        child: ElevatedButton.icon(
                          onPressed: controller.stopGenerating,
                          icon: const Icon(Icons.stop_rounded, size: 13, color: Colors.white),
                          label: const Text('Stop', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 32,
                      child: ElevatedButton.icon(
                        onPressed: controller.sendMessage,
                        icon: const Icon(Icons.arrow_upward_rounded, size: 14, color: Colors.white),
                        label: const Text(
                          'Send',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachSourceButton(bool isDark) {
    return PopupMenuButton<String>(
      icon: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.attach_file_rounded, size: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            const SizedBox(width: 3),
            Text(
              'Attach',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
      padding: EdgeInsets.zero,
      tooltip: 'Attach Context',
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (type) => controller.addSampleAttachment(type),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: 'pdf',
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf_rounded, size: 14, color: AppColors.error),
              SizedBox(width: 8),
              Text('Attach PDF Manual', style: TextStyle(fontSize: 11.5)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'database',
          child: Row(
            children: [
              Icon(Icons.storage_rounded, size: 14, color: AppColors.secondaryLight),
              SizedBox(width: 8),
              Text('Attach PgVector Store', style: TextStyle(fontSize: 11.5)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'link',
          child: Row(
            children: [
              Icon(Icons.link_rounded, size: 14, color: AppColors.success),
              SizedBox(width: 8),
              Text('Attach Live API Endpoint', style: TextStyle(fontSize: 11.5)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownPicker({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool isDark,
    IconData? icon,
  }) {
    final validValue = items.contains(value) ? value : items.first;

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: validValue,
          isDense: true,
          icon: Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 14,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(8),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          items: items.map((item) {
            final isSelected = item == validValue;
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 12, color: isSelected ? AppColors.primaryLight : AppColors.darkTextMuted),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    item,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryLight
                          : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // =========================================================================
  // 6: CITATION GROUNDING MODAL OVERLAY
  // =========================================================================
  Widget _buildCitationOverlay(bool isDark, BuildContext context) {
    final citation = controller.selectedCitation.value!;

    return Positioned.fill(
      child: GestureDetector(
        onTap: controller.closeCitationDetail,
        child: Container(
          color: Colors.black54,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 580),
                margin: const EdgeInsets.all(14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.menu_book_rounded, size: 15, color: AppColors.primaryLight),
                            const SizedBox(width: 8),
                            Text(
                              'Citation Source',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 16),
                          onPressed: controller.closeCitationDetail,
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      citation.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                        ),
                      ),
                      child: Text(
                        citation.snippet,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Confidence: ${((citation.score ?? 0.95) * 100).toInt()}% match',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.closeCitationDetail();
                            Get.rawSnackbar(
                              message: 'Source: ${citation.url ?? citation.title}',
                              duration: const Duration(seconds: 2),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text('Open Source', style: TextStyle(fontSize: 11.5, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 180.ms);
  }
}
