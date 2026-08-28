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
        final isWide = constraints.maxWidth >= 768;

        return Obx(() {
          final isDark = sharedController.isDarkMode.value;
          final isDetail = controller.isViewingChatDetail.value;

          return Scaffold(
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            body: isWide
                ? Row(
                    children: [
                      // Left Master Pane: All Conversations List
                      SizedBox(
                        width: 320,
                        child: _buildSessionsListPane(isDark, isWide: true),
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                      ),
                      // Right Detail Pane: Active Chat Conversation
                      Expanded(
                        child: _buildChatConversationPane(isDark, isWide: true),
                      ),
                    ],
                  )
                : (isDetail
                    ? _buildChatConversationPane(isDark, isWide: false)
                    : _buildSessionsListPane(isDark, isWide: false)),
          );
        });
      },
    );
  }

  // ==========================================
  // 1: SESSIONS LIST PANE (ALL CHATS LIST)
  // ==========================================
  Widget _buildSessionsListPane(bool isDark, {required bool isWide}) {
    return Container(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Column(
        children: [
          // Top Action Header (+ New Chat Button)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.createNewSession();
                },
                icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                label: const Text(
                  'New Chat',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Container(
              height: 38,
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
                  fontSize: 13,
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // List of Chat Sessions (ListTiles)
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
                        'No conversations yet',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                itemCount: list.length,
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final session = list[index];
                  final isSelected = isWide && session.id == controller.activeSessionId.value;

                  return Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        controller.selectSession(session.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primarySoft
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.5)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 18,
                              color: isSelected
                                  ? AppColors.primaryLight
                                  : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.primaryLight
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
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                size: 16,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                              onPressed: () => controller.deleteSession(session.id),
                              tooltip: 'Delete chat',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 200.ms, delay: (index * 30).ms);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2: CHAT CONVERSATION DETAIL PANE
  // ==========================================
  Widget _buildChatConversationPane(bool isDark, {required bool isWide}) {
    return Obx(() {
      final active = controller.activeSession;
      final messages = active?.messages ?? [];

      return Column(
        children: [
          // Top Header: Back button (on mobile) + Active Title + Debug Mode Switch
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    if (!isWide)
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                        onPressed: controller.backToSessionsList,
                        tooltip: 'All Conversations',
                      ),
                    Text(
                      active?.title ?? 'New Conversation',
                      style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                // Debug Mode Toggle
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Debug Mode',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: controller.debugMode.value,
                        onChanged: (_) => controller.toggleDebugMode(),
                        activeThumbColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Message Stream / Empty State
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyConversationState(isDark)
                : ListView.builder(
                    controller: controller.scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return _buildMessageBubble(msg, isDark);
                    },
                  ),
          ),

          // Bottom Dropdowns & Input Bar
          _buildBottomInputBar(isDark, isWide: isWide),
        ],
      );
    });
  }

  // ==========================================
  // 3: EMPTY CONVERSATION STATE
  // ==========================================
  Widget _buildEmptyConversationState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
              ),
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 28,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Start a new conversation',
            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Ask questions about your knowledge base',
            style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4: BOTTOM BAR (RESPONSIVE DROPDOWNS + INPUT + SEND)
  // ==========================================
  Widget _buildBottomInputBar(bool isDark, {required bool isWide}) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, isWide ? 10 : 8, 16, isWide ? 14 : 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
          ),
        ),
      ),
      child: isWide
          ? _buildDesktopBottomRow(isDark)
          : _buildMobileBottomColumn(isDark),
    );
  }

  // Mobile / Narrow Bottom Layout (2-tier clean)
  Widget _buildMobileBottomColumn(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mode Selector Pills Row
        Row(
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
            const SizedBox(width: 8),
            _buildDropdownPicker(
              value: controller.currentModelMode.value,
              items: controller.modelModeOptions,
              onChanged: (val) {
                if (val != null) controller.setModelMode(val);
              },
              isDark: isDark,
              icon: Icons.speed_rounded,
            ),
            const Spacer(),
            if (controller.currentMessages.isNotEmpty)
              IconButton(
                icon: Icon(
                  Icons.delete_sweep_outlined,
                  size: 20,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                onPressed: controller.clearConversation,
                tooltip: 'Clear messages',
              ),
          ],
        ),
        const SizedBox(height: 8),
        // Full Width Input Box + Send Button
        Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                  ),
                ),
                child: TextField(
                  controller: controller.inputController,
                  onSubmitted: (_) => controller.sendMessage(),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ask a question about your knowledge base...',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 44,
              child: ElevatedButton.icon(
                onPressed: controller.sendMessage,
                icon: const Icon(Icons.send_rounded, size: 15, color: Colors.white),
                label: const Text(
                  'Send',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Desktop / Wide Bottom Layout (Single row)
  Widget _buildDesktopBottomRow(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
        const SizedBox(width: 8),
        _buildDropdownPicker(
          value: controller.currentModelMode.value,
          items: controller.modelModeOptions,
          onChanged: (val) {
            if (val != null) controller.setModelMode(val);
          },
          isDark: isDark,
          icon: Icons.speed_rounded,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
              ),
            ),
            child: TextField(
              controller: controller.inputController,
              onSubmitted: (_) => controller.sendMessage(),
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Ask a question about your knowledge base...',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 44,
          child: ElevatedButton.icon(
            onPressed: controller.sendMessage,
            icon: const Icon(Icons.send_rounded, size: 15, color: Colors.white),
            label: const Text(
              'Send',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  // Helper: Dropdown Picker Button
  Widget _buildDropdownPicker({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool isDark,
    IconData? icon,
  }) {
    final validValue = items.contains(value) ? value : items.first;

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: validValue,
          isDense: true,
          icon: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(10),
          style: TextStyle(
            fontSize: 12,
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
                  Text(
                    item,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryLight
                          : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.check_rounded, size: 14, color: AppColors.primaryLight),
                  ],
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ==========================================
  // 5: MESSAGE BUBBLE BUILDER
  // ==========================================
  Widget _buildMessageBubble(ChatMessageModel message, bool isDark) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.auto_awesome_rounded, size: 16, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.primary
                        : (isDark ? AppColors.darkCard : AppColors.lightSurface),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(isUser ? 14 : 2),
                      bottomRight: Radius.circular(isUser ? 2 : 14),
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
                      Text(
                        message.text.isEmpty && message.isStreaming ? 'Thinking...' : message.text,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: isUser
                              ? Colors.white
                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        ),
                      ),
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
                                    end: const Offset(1.2, 1.2),
                                    duration: 400.ms,
                                  ),
                              const SizedBox(width: 4),
                              const Text(
                                'Retrieving from knowledge base...',
                                style: TextStyle(
                                  fontSize: 10,
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

                // Citations & Debug Metrics (if Assistant)
                if (!isUser && message.citations.isNotEmpty && !message.isStreaming)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: message.citations.map((c) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.menu_book_rounded, size: 11, color: AppColors.primaryLight),
                              const SizedBox(width: 4),
                              Text(
                                c.title,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primaryLight),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // Debug Mode Telemetry
                if (!isUser && controller.debugMode.value && message.modelUsed != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Mode: ${message.modelUsed} | Tokens: ${message.tokens ?? 0}',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 10),
            Container(
              width: 32,
              height: 32,
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
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}
