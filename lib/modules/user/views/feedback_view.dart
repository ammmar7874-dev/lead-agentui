import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/user_shared_controller.dart';

class FeedbackItem {
  final String date;
  final int rating;
  final String label;
  final String site;
  final String sessionId;
  final String comment;

  FeedbackItem({
    required this.date,
    required this.rating,
    required this.label,
    required this.site,
    required this.sessionId,
    required this.comment,
  });
}

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final TextEditingController _searchCtrl = TextEditingController();

  final List<FeedbackItem> _feedbacks = [
    FeedbackItem(
      date: 'Aug 27, 2026 10:30 PM',
      rating: 5,
      label: 'Accurate & Fast',
      site: 'Excels_Tech Widget',
      sessionId: 'sess_wgt_39182',
      comment: 'Found exactly what I needed regarding the custom pricing plan!',
    ),
    FeedbackItem(
      date: 'Aug 27, 2026 08:14 PM',
      rating: 4,
      label: 'Helpful',
      site: 'Excels_Tech Widget',
      sessionId: 'sess_wgt_10928',
      comment: 'Quick answers on documentation and API routes.',
    ),
    FeedbackItem(
      date: 'Aug 26, 2026 05:22 PM',
      rating: 5,
      label: 'Excellent',
      site: 'aipoweremail',
      sessionId: 'sess_wgt_88192',
      comment: 'The chatbot answered technical integration questions seamlessly.',
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
            'Chat Feedback',
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
                Get.snackbar('Refreshed', 'Feedback ratings synced', snackPosition: SnackPosition.BOTTOM);
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Filter by label or site...',
                    hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 13),
                    prefixIcon: Icon(Icons.search_rounded, size: 18, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // List of Feedback
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                itemCount: _feedbacks.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _feedbacks[index];

                  return CustomCard(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Star Rating
                            Row(
                              children: List.generate(
                                5,
                                (sIdx) => Icon(
                                  sIdx < item.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                                  color: const Color(0xFFFBBF24),
                                  size: 18,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.label,
                                style: const TextStyle(color: AppColors.primaryLight, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '"${item.comment}"',
                          style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Site: ${item.site}',
                              style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
                            ),
                            Text(
                              item.date,
                              style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: (index * 60).ms);
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
