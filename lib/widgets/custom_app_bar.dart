import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/native/platform_helper.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final VoidCallback? onLeadingPressed;
  final Widget? action;
  final VoidCallback? onActionPressed;
  final bool showBackButton;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.onLeadingPressed,
    this.action,
    this.onActionPressed,
    this.showBackButton = true,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = leading;
    } else if (showBackButton && Navigator.of(context).canPop()) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        onPressed: onLeadingPressed ??
            () {
              PlatformHelper.lightHaptic();
              Get.back();
            },
      );
    }

    return AppBar(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leading: leadingWidget,
      title: Text(
        title,
        style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        if (action != null) ...[
          action!,
          const SizedBox(width: 8),
        ],
      ],
    );
  }
}
