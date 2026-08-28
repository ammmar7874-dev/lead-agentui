import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_card.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/user_shared_controller.dart';
import 'bot_settings_view.dart';
import 'token_usage_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final sharedController = Get.find<UserSharedController>();

    return Obx(() {
      final isDark = sharedController.isDarkMode.value;
      final user = authController.currentUser.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Account Header Card
              CustomCard(
                padding: const EdgeInsets.all(20),
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                borderColor: AppColors.primary.withValues(alpha: 0.3),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/images/bot_mascot.jpg', fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Admin User',
                            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? 'zia@excels-tech.com',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CustomBadge(
                                text: user?.role ?? 'ADMIN',
                                backgroundColor: AppColors.primarySoft,
                                textColor: AppColors.primaryLight,
                                fontSize: 9,
                              ),
                              const SizedBox(width: 6),
                              CustomBadge(
                                text: 'Enterprise Plan',
                                backgroundColor: AppColors.successSoft,
                                textColor: AppColors.success,
                                fontSize: 9,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 20),

              // Preferences Section
              Text('Preferences', style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              CustomCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(Icons.dark_mode_outlined, size: 20),
                      title: Text(
                        'Dark Mode Theme',
                        style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(fontSize: 13),
                      ),
                      value: sharedController.isDarkMode.value,
                      onChanged: (_) => sharedController.toggleTheme(),
                      activeThumbColor: AppColors.primary,
                    ),
                    const Divider(height: 1, color: AppColors.darkBorderSubtle),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.tune_rounded, size: 20),
                      title: Text('Bot Customization', style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(fontSize: 13)),
                      trailing: const Icon(Icons.chevron_right_rounded, size: 18),
                      onTap: () => Get.to(() => const BotSettingsView()),
                    ),
                    const Divider(height: 1, color: AppColors.darkBorderSubtle),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.analytics_outlined, size: 20),
                      title: Text('Token Analytics & Quota', style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(fontSize: 13)),
                      trailing: const Icon(Icons.chevron_right_rounded, size: 18),
                      onTap: () => Get.to(() => const TokenUsageView()),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Security & Auth Section
              Text('Security & Organization', style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              CustomCard(
                padding: const EdgeInsets.all(16),
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.verified_user_outlined, size: 18, color: AppColors.success),
                            const SizedBox(width: 10),
                            Text('Two-Factor Authentication', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                          ],
                        ),
                        CustomBadge(text: 'Enabled', backgroundColor: AppColors.successSoft, textColor: AppColors.success, fontSize: 10),
                      ],
                    ),
                    const Divider(height: 20, color: AppColors.darkBorderSubtle),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.business_rounded, size: 18, color: AppColors.secondary),
                            const SizedBox(width: 10),
                            Text('Organization', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                          ],
                        ),
                        Text('Excels Tech Inc', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Sign Out?',
                      middleText: 'Are you sure you want to sign out of your AI RAG ChatBot account?',
                      textConfirm: 'Sign Out',
                      textCancel: 'Cancel',
                      confirmTextColor: Colors.white,
                      buttonColor: AppColors.error,
                      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      titleStyle: AppTextStyles.titleMedium(isDark: isDark),
                      middleTextStyle: AppTextStyles.bodyMedium(isDark: isDark),
                      onConfirm: () {
                        Get.back();
                        authController.logout();
                      },
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 18),
                  label: const Text('Sign Out', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.error.withValues(alpha: 0.4)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
