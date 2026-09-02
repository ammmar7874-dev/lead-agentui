import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/user_shared_controller.dart';

class LiveSessionModel {
  final String id;
  final String site;
  final String visitor;
  final String started;
  final String lastActive;
  final String lead;
  final bool isOnline;

  LiveSessionModel({
    required this.id,
    required this.site,
    required this.visitor,
    required this.started,
    required this.lastActive,
    required this.lead,
    this.isOnline = true,
  });
}

class LiveActivityView extends StatefulWidget {
  const LiveActivityView({super.key});

  @override
  State<LiveActivityView> createState() => _LiveActivityViewState();
}

class _LiveActivityViewState extends State<LiveActivityView> {
  final RxList<LiveSessionModel> _sessions = <LiveSessionModel>[
    LiveSessionModel(
      id: 'sess_1',
      site: 'Excels_Tech Widget',
      visitor: 'Visitor #1092',
      started: '2m ago',
      lastActive: 'Just now',
      lead: 'info@univenture.work',
      isOnline: true,
    ),
    LiveSessionModel(
      id: 'sess_2',
      site: 'aipoweremail',
      visitor: 'Visitor #8812',
      started: '5m ago',
      lastActive: '1m ago',
      lead: 'Anonymous',
      isOnline: true,
    ),
  ].obs;

  @override
  Widget build(BuildContext context) {
    final sharedController = Get.find<UserSharedController>();

    return Obx(() {
      final isDark = sharedController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            onPressed: () => Get.back(),
          ),

          title: Text(
            'Live Activity',
            style: AppTextStyles.titleMedium(
              isDark: isDark,
            ).copyWith(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                size: 22,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              onPressed: () {
                PlatformHelper.lightHaptic();
                Get.snackbar(
                  'Refreshed',
                  'Live telemetry feed synced',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Section Title (From Screenshot: "Live activity (active now)")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Live activity (active now)',
                    style: AppTextStyles.titleLarge(
                      isDark: isDark,
                    ).copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successSoft,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.3),
                      ),
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
                            )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.3, 1.3),
                              duration: 800.ms,
                            ),
                        const SizedBox(width: 5),
                        Text(
                          '${_sessions.length} Live',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Live Sessions Table Card (From Screenshot)
              CustomCard(
                padding: const EdgeInsets.all(0),
                backgroundColor: isDark
                    ? AppColors.darkCard
                    : AppColors.lightSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Subtitle: "X active sessions"
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                      child: Text(
                        '${_sessions.length} active sessions',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),

                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? AppColors.darkBorderSubtle
                          : AppColors.lightBorderSubtle,
                    ),

                    // Table Columns Header Row (Site, Visitor, Started, Last active, Lead)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightBackground.withValues(alpha: 0.5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Site',
                              style: _columnHeaderStyle(isDark),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Visitor',
                              style: _columnHeaderStyle(isDark),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Started',
                              style: _columnHeaderStyle(isDark),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Last active',
                              style: _columnHeaderStyle(isDark),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Lead',
                              style: _columnHeaderStyle(isDark),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? AppColors.darkBorderSubtle
                          : AppColors.lightBorderSubtle,
                    ),

                    // Table Body Rows (or "No active sessions.")
                    if (_sessions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        child: Text(
                          'No active sessions.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      )

                      
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _sessions.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          thickness: 1,
                          color: isDark
                              ? AppColors.darkBorderSubtle
                              : AppColors.lightBorderSubtle,
                        ),
                        itemBuilder: (context, index) {
                          final session = _sessions[index];

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                // Site
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.language_rounded,
                                        size: 14,
                                        color: AppColors.primaryLight,
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          session.site,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Visitor
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const BoxDecoration(
                                          color: AppColors.success,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          session.visitor,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Started
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    session.started,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ),

                                // Last Active
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    session.lastActive,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ),

                                // Lead Status
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      if (session.lead != 'Anonymous') ...[
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          size: 13,
                                          color: AppColors.success,
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                      Flexible(
                                        child: Text(
                                          session.lead,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight:
                                                session.lead != 'Anonymous'
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            color: session.lead != 'Anonymous'
                                                ? AppColors.success
                                                : (isDark
                                                      ? AppColors.darkTextMuted
                                                      : AppColors
                                                            .lightTextMuted),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Toolbar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      PlatformHelper.lightHaptic();
                      _sessions.clear();
                    },
                    icon: const Icon(Icons.clear_all_rounded, size: 16),
                    label: const Text(
                      'Simulate Empty State',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      side: BorderSide(
                        color: isDark
                            ? AppColors.darkBorderSubtle
                            : AppColors.lightBorderSubtle,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      PlatformHelper.lightHaptic();
                      final id = DateTime.now().millisecondsSinceEpoch;
                      _sessions.insert(
                        0,
                        LiveSessionModel(
                          id: 'sess_$id',
                          site: 'Excels_Tech Widget',
                          visitor: 'Visitor #$id'.substring(0, 14),
                          started: 'Just now',
                          lastActive: 'Just now',
                          lead: id % 2 == 0 ? 'lead_$id@acme.io' : 'Anonymous',
                          
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Simulate New Live Visitor',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  TextStyle _columnHeaderStyle(bool isDark) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: isDark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    );
  }
}
