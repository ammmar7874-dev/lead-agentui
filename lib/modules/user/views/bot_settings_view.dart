import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/user_shared_controller.dart';

class BotSettingsController extends GetxController {
  final botNameController = TextEditingController(text: 'AI RAG Assistant');
  final welcomeMessageController = TextEditingController(
    text: 'Hello! I am your AI Assistant. How can I help you today?',
  );
  final systemPromptController = TextEditingController(
    text: 'You are a helpful AI grounded only in the connected knowledge sources. Be concise, polite, and cite sources accurately.',
  );

  final RxDouble temperature = 0.3.obs;
  final RxInt selectedColorIndex = 0.obs;

  final List<Color> themeColorOptions = const [
    Color(0xFFC8102E), // Crimson
    Color(0xFF0284C7), // Sapphire
    Color(0xFF10B981), // Emerald
    Color(0xFF8B5CF6), // Purple
    Color(0xFFF59E0B), // Amber
  ];

  Color get currentThemeColor => themeColorOptions[selectedColorIndex.value];

  final RxBool isSaving = false.obs;

  Future<void> saveSettings() async {
    isSaving.value = true;
    PlatformHelper.mediumHaptic();
    await Future.delayed(const Duration(milliseconds: 700));
    isSaving.value = false;
    PlatformHelper.lightHaptic();
    Get.snackbar(
      'Settings Saved',
      'Bot customizations updated and live across all connected web embed widgets.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
    );
  }

  @override
  void onClose() {
    botNameController.dispose();
    welcomeMessageController.dispose();
    systemPromptController.dispose();
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

      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text('Bot Customization', style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontSize: 17, fontWeight: FontWeight.w700)),
          actions: [
            IconButton(
              icon: Icon(
                Icons.save_rounded,
                size: 22,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              onPressed: controller.saveSettings,
              tooltip: 'Save Settings',
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1: Live Interactive Preview Widget
              _buildLivePreviewCard(controller, isDark),

              const SizedBox(height: 20),

              // 2: Branding & Appearance
              Text('Branding & Theme', style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              CustomTextField(
                label: 'Bot Display Name',
                hint: 'e.g. Acme Support Bot',
                controller: controller.botNameController,
                onChanged: (_) => controller.botNameController.text = controller.botNameController.text,
              ),

              const SizedBox(height: 16),

              Text('Primary Theme Color', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              const SizedBox(height: 8),

              // Color Palette Picker
              Row(
                children: List.generate(controller.themeColorOptions.length, (index) {
                  final color = controller.themeColorOptions[index];
                  final isSelected = controller.selectedColorIndex.value == index;

                  return GestureDetector(
                    onTap: () {
                      PlatformHelper.selectionHaptic();
                      controller.selectedColorIndex.value = index;
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: color.withValues(alpha: 0.6),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      child: isSelected ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // 3: Behavior & Instructions
              Text('Conversation Behavior', style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              CustomTextField(
                label: 'Welcome Greeting Message',
                hint: 'Hello! How can I assist you?',
                controller: controller.welcomeMessageController,
                maxLines: 2,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: 'System Prompt Instructions',
                hint: 'You are an AI assistant...',
                controller: controller.systemPromptController,
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              // Temperature Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Creativity / Temperature',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '${controller.temperature.value.toStringAsFixed(1)} (${controller.temperature.value < 0.4 ? 'Strict/Precise' : 'Creative'})',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: controller.currentThemeColor),
                  ),
                ],
              ),
              Slider(
                value: controller.temperature.value,
                onChanged: (val) => controller.temperature.value = val,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                activeColor: controller.currentThemeColor,
              ),

              const SizedBox(height: 20),

              // 4: Website Embed Snippet Card
              _buildEmbedSnippetCard(isDark),

              const SizedBox(height: 24),

              // Save Button
              Obx(
                () => CustomButton(
                  text: 'Save Bot Changes',
                  isLoading: controller.isSaving.value,
                  onPressed: controller.saveSettings,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLivePreviewCard(BotSettingsController controller, bool isDark) {
    final themeColor = controller.currentThemeColor;

    return CustomCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
      borderColor: themeColor.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Live Interactive Preview', style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
              CustomBadge(
                text: 'Preview',
                backgroundColor: themeColor.withValues(alpha: 0.15),
                textColor: themeColor,
                fontSize: 10,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Mini Chat Widget mockup
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightCardHover,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              children: [
                // Header of mini bot
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: themeColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.smart_toy_rounded, size: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      controller.botNameController.text.isEmpty ? 'AI Bot' : controller.botNameController.text,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Bot message bubble
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      controller.welcomeMessageController.text.isEmpty
                          ? 'Hello! How can I help you?'
                          : controller.welcomeMessageController.text,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmbedSnippetCard(bool isDark) {
    const snippet = '<script src="https://airagchatbot.com/widget.js" data-bot-id="bot_98213"></script>';

    return CustomCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Embed on Your Website', style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.primaryLight),
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: snippet));
                  Get.snackbar('Copied', 'Embed snippet copied to clipboard', snackPosition: SnackPosition.BOTTOM);
                },
                tooltip: 'Copy Code',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightCardHover,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: const Text(
              snippet,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: AppColors.secondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
