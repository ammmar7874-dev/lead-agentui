import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/user_shared_controller.dart';

class TranscriptModel {
  final String id;
  final String created;
  final String status;
  final String sessionVisitor;
  final String destination;
  final String delivered;
  final List<Map<String, String>> dialog;

  TranscriptModel({
    required this.id,
    required this.created,
    required this.status,
    required this.sessionVisitor,
    required this.destination,
    required this.delivered,
    required this.dialog,
  });
}

class TranscriptsView extends StatefulWidget {
  const TranscriptsView({super.key});

  @override
  State<TranscriptsView> createState() => _TranscriptsViewState();
}

class _TranscriptsViewState extends State<TranscriptsView> {
  final TextEditingController _sessionIdCtrl = TextEditingController();
  final TextEditingController _visitorIdCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  final List<TranscriptModel> _transcripts = [
    TranscriptModel(
      id: 'tr_9182',
      created: 'Aug 27, 2026, 10:28 PM',
      status: 'DELIVERED',
      sessionVisitor: 'sess_wgt_39182 (info@univenture.work)',
      destination: 'info@univenture.work',
      delivered: 'Aug 27, 2026, 10:29 PM',
      dialog: [
        {'sender': 'User', 'text': 'I need details on your Basic Plan RAG chatbot deployment.'},
        {'sender': 'AI Agent', 'text': 'Our Basic Plan includes 10,000 monthly queries, 5 custom knowledge sources, and full website widget embedding.'},
        {'sender': 'User', 'text': 'Great, my email is info@univenture.work, please send an invoice.'},
        {'sender': 'AI Agent', 'text': 'Thank you! Your inquiry has been logged with our sales team.'},
      ],
    ),
    TranscriptModel(
      id: 'tr_9104',
      created: 'Aug 27, 2026, 09:15 PM',
      status: 'DELIVERED',
      sessionVisitor: 'vis_a4102 (sales@designerly.io)',
      destination: 'sales@designerly.io',
      delivered: 'Aug 27, 2026, 09:16 PM',
      dialog: [
        {'sender': 'User', 'text': 'Can the AI bot answer questions about our API documentation?'},
        {'sender': 'AI Agent', 'text': 'Yes, you can upload Swagger OpenAPI JSON, Markdown files, or point directly to your docs website.'},
      ],
    ),
    TranscriptModel(
      id: 'tr_8911',
      created: 'Aug 26, 2026, 04:40 PM',
      status: 'DELIVERED',
      sessionVisitor: 'vis_c8192 (admin@excelstech.ai)',
      destination: 'admin@excelstech.ai',
      delivered: 'Aug 26, 2026, 04:41 PM',
      dialog: [
        {'sender': 'User', 'text': 'Show me the weekly token usage report.'},
        {'sender': 'AI Agent', 'text': 'Total tokens used this week is 142,500 across 56 conversations.'},
      ],
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
                'Transcripts',
                style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 18),
              ),
              Text(
                'Audit conversation transcripts and email deliveries',
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
                text: '56 Total',
                backgroundColor: AppColors.primarySoft,
                textColor: AppColors.primaryLight,
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
              // Request Transcript Card
              CustomCard(
                padding: const EdgeInsets.all(18),
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request a transcript',
                      style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Search by session or visitor ID to email conversation logs',
                      style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _sessionIdCtrl,
                            hint: 'Widget Session ID',
                            label: 'Session ID',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            controller: _visitorIdCtrl,
                            hint: 'or Visitor ID',
                            label: 'Visitor ID',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _emailCtrl,
                      hint: 'Email (optional)',
                      label: 'Destination Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    CustomButton(
                      text: 'Request Transcript',
                      icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                      onPressed: () {
                        PlatformHelper.lightHaptic();
                        Get.snackbar(
                          'Transcript Queued',
                          'Transcript dispatch job scheduled for processing',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.darkSurface,
                          colorText: Colors.white,
                        );
                        _sessionIdCtrl.clear();
                        _visitorIdCtrl.clear();
                        _emailCtrl.clear();
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 24),

              Text(
                'Recent Generated Transcripts',
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Transcripts List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _transcripts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _transcripts[index];

                  return CustomCard(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.successSoft,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.status,
                                style: const TextStyle(
                                  color: AppColors.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              item.created,
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.sessionVisitor,
                          style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.email_outlined, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                            const SizedBox(width: 4),
                            Text(
                              'Delivered to: ${item.destination}',
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _viewTranscriptDetails(context, item, isDark),
                              icon: const Icon(Icons.visibility_outlined, size: 16),
                              label: const Text('View Transcript', style: TextStyle(fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: (index * 60).ms);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  void _viewTranscriptDetails(BuildContext context, TranscriptModel item, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transcript Detail',
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Session: ${item.sessionVisitor}',
                style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, fontSize: 12),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 300,
                child: ListView.separated(
                  itemCount: item.dialog.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final d = item.dialog[index];
                    final isUser = d['sender'] == 'User';

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppColors.primarySoft
                            : (isDark ? AppColors.darkCard : AppColors.lightCardHover),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d['sender'] ?? '',
                            style: TextStyle(
                              color: isUser ? AppColors.primaryLight : AppColors.secondaryLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            d['text'] ?? '',
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              fontSize: 13,
                            ),
                          ),
                        ],
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
  }
}
