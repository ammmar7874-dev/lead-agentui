import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/knowledge_controller.dart';
import '../controllers/user_shared_controller.dart';

class KnowledgeGapModel {
  final String question;
  final int frequency;
  final double confidence;
  final String sampleBotAnswer;
  final RxBool isResolved;

  KnowledgeGapModel({
    required this.question,
    required this.frequency,
    required this.confidence,
    required this.sampleBotAnswer,
    required bool isResolved,
  }) : isResolved = isResolved.obs;
}

class KnowledgeGapsView extends StatefulWidget {
  const KnowledgeGapsView({super.key});

  @override
  State<KnowledgeGapsView> createState() => _KnowledgeGapsViewState();
}

class _KnowledgeGapsViewState extends State<KnowledgeGapsView> {
  final List<KnowledgeGapModel> _gaps = [
    KnowledgeGapModel(
      question: 'Do you offer a 30-day money back guarantee for annual plans?',
      frequency: 14,
      confidence: 0.42,
      sampleBotAnswer: 'I do not have specific information about refund policies in my knowledge base.',
      isResolved: false,
    ),
    KnowledgeGapModel(
      question: 'What are your hardware requirements for on-premise LLM hosting?',
      frequency: 8,
      confidence: 0.51,
      sampleBotAnswer: 'On-premise deployment options require talking directly with our engineering team.',
      isResolved: false,
    ),
    KnowledgeGapModel(
      question: 'Can we pay via wire transfer / ACH instead of credit card?',
      frequency: 5,
      confidence: 0.58,
      sampleBotAnswer: 'Credit card payment is available by default; contact sales for invoices.',
      isResolved: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final sharedController = Get.find<UserSharedController>();
    final knowledgeCtrl = Get.find<KnowledgeController>();

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
                'Knowledge Gaps',
                style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 18),
              ),
              Text(
                'Unanswered questions & missing knowledge suggestions',
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
                text: '2 Unresolved',
                backgroundColor: AppColors.warningSoft,
                textColor: AppColors.warning,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.warningSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.lightbulb_outline_rounded, color: AppColors.warning, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'AI analyzes conversations and flags questions where the bot was unsure. Add answers here to automatically train the agent.',
                        style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 20),

              Text(
                'High-Frequency Missing Answers',
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _gaps.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final gap = _gaps[index];

                  return Obx(() {
                    final resolved = gap.isResolved.value;

                    return CustomCard(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                      borderColor: resolved ? AppColors.darkBorderSubtle : AppColors.warning.withValues(alpha: 0.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySoft,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Asked ${gap.frequency} times',
                                  style: const TextStyle(
                                    color: AppColors.primaryLight,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: resolved ? AppColors.successSoft : AppColors.warningSoft,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  resolved ? 'RESOLVED' : 'CONFIDENCE ${(gap.confidence * 100).toInt()}%',
                                  style: TextStyle(
                                    color: resolved ? AppColors.success : AppColors.warning,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '"${gap.question}"',
                            style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : AppColors.lightCardHover,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Bot Answer: ${gap.sampleBotAnswer}',
                              style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11, fontStyle: FontStyle.italic),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (!resolved)
                                ElevatedButton.icon(
                                  onPressed: () {
                                    PlatformHelper.lightHaptic();
                                    _showAddAnswerDialog(context, gap, knowledgeCtrl, isDark);
                                  },
                                  icon: const Icon(Icons.add_rounded, size: 16),
                                  label: const Text('Add Answer to Knowledge Base', style: TextStyle(fontSize: 11)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                )
                              else
                                const Row(
                                  children: [
                                    Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                                    SizedBox(width: 4),
                                    Text('Trained in Vector KB', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showAddAnswerDialog(BuildContext context, KnowledgeGapModel gap, KnowledgeController knowledgeCtrl, bool isDark) {
    final answerCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Add FAQ Training Answer', style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Question:', style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11)),
              const SizedBox(height: 2),
              Text(gap.question, style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              TextField(
                controller: answerCtrl,
                maxLines: 4,
                style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Enter official answer for the AI bot...',
                  hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 12),
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
                if (answerCtrl.text.isNotEmpty) {
                  gap.isResolved.value = true;
                  Get.back();
                  Get.snackbar('Trained!', 'New FAQ added and synced to Pinecone vector store', snackPosition: SnackPosition.BOTTOM);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Save & Index'),
            ),
          ],
        );
      },
    );
  }
}
