import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/user_shared_controller.dart';

class ReviewItem {
  final String id;
  final String question;
  final RxString answer;
  final String source;
  final String date;
  final RxBool isApproved;

  ReviewItem({
    required this.id,
    required this.question,
    required String answer,
    required this.source,
    required this.date,
    required bool isApproved,
  })  : answer = answer.obs,
        isApproved = isApproved.obs;
}

class MyReviewsView extends StatefulWidget {
  const MyReviewsView({super.key});

  @override
  State<MyReviewsView> createState() => _MyReviewsViewState();
}

class _MyReviewsViewState extends State<MyReviewsView> {
  final List<ReviewItem> _reviews = [
    ReviewItem(
      id: 'rev_01',
      question: 'How do I add custom CSS styling to the embedded widget?',
      answer: 'You can pass a customTheme JSON object or override widget container CSS variables in your site stylesheet.',
      source: 'excelstech.ai/docs/widget-customization',
      date: 'Aug 27, 2026 09:45 PM',
      isApproved: false,
    ),
    ReviewItem(
      id: 'rev_02',
      question: 'What is the maximum token limit per prompt context?',
      answer: 'Our RAG engine supports up to 128k context windows with GPT-4o and Claude 3.5 Sonnet hybrid routing.',
      source: 'pricing_and_specs.pdf [Page 4]',
      date: 'Aug 26, 2026 11:20 AM',
      isApproved: true,
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
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Get.back(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quality Reviews',
                style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 18),
              ),
              Text(
                'Human-in-the-loop response verification & Golden QA',
                style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CustomBadge(
                text: '1 Pending QA',
                backgroundColor: AppColors.primarySoft,
                textColor: AppColors.primaryLight,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
            ),
          ],
        ),
        body: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          itemCount: _reviews.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = _reviews[index];

            return Obx(() {
              final approved = item.isApproved.value;

              return CustomCard(
                padding: const EdgeInsets.all(16),
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                borderColor: approved ? AppColors.success.withValues(alpha: 0.3) : AppColors.primary.withValues(alpha: 0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: approved ? AppColors.successSoft : AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            approved ? 'APPROVED GOLDEN QA' : 'PENDING REVIEW',
                            style: TextStyle(
                              color: approved ? AppColors.success : AppColors.primaryLight,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          item.date,
                          style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Q: "${item.question}"',
                      style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.lightCardHover,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'A: ${item.answer.value}',
                        style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.menu_book_rounded, size: 14, color: AppColors.primaryLight),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Source: ${item.source}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.primaryLight, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _showEditAnswerDialog(context, item, isDark),
                          icon: const Icon(Icons.edit_note_rounded, size: 16),
                          label: const Text('Edit Answer', style: TextStyle(fontSize: 11)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!approved)
                          ElevatedButton.icon(
                            onPressed: () {
                              PlatformHelper.lightHaptic();
                              item.isApproved.value = true;
                              Get.snackbar('Approved', 'Response added to Golden QA benchmark dataset', snackPosition: SnackPosition.BOTTOM);
                            },
                            icon: const Icon(Icons.check_rounded, size: 16),
                            label: const Text('Approve', style: TextStyle(fontSize: 11)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            });
          },
        ),
      );
    });
  }

  void _showEditAnswerDialog(BuildContext context, ReviewItem item, bool isDark) {
    final editCtrl = TextEditingController(text: item.answer.value);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Refine AI Answer', style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editCtrl,
                maxLines: 4,
                style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 13),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? AppColors.darkCard : AppColors.lightCardHover,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (editCtrl.text.isNotEmpty) {
                  item.answer.value = editCtrl.text.trim();
                  item.isApproved.value = true;
                  Get.back();
                  Get.snackbar('Updated', 'Golden answer saved and synchronized with RAG cache', snackPosition: SnackPosition.BOTTOM);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Save & Approve'),
            ),
          ],
        );
      },
    );
  }
}
