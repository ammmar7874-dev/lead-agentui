import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/user_shared_controller.dart';

class IngestionView extends StatefulWidget {
  const IngestionView({super.key});

  @override
  State<IngestionView> createState() => _IngestionViewState();
}

class _IngestionViewState extends State<IngestionView> {
  bool _isReindexing = false;

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
                'Vector Ingestion Engine',
                style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 18),
              ),
              Text(
                'Vector Database & embedding index telemetry',
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
                text: 'Index Healthy',
                backgroundColor: AppColors.successSoft,
                textColor: AppColors.success,
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
              // Vector DB Status Card
              CustomCard(
                padding: const EdgeInsets.all(18),
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.hub_rounded, color: AppColors.primaryLight, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pinecone Vector DB',
                                  style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Serverless • us-east-1 • Hybrid Index',
                                  style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.darkBorderSubtle),
                    const SizedBox(height: 16),

                    _buildInfoRow('Embedding Model', 'text-embedding-3-small', isDark),
                    const SizedBox(height: 10),
                    _buildInfoRow('Vector Dimensions', '1,536 dimensions', isDark),
                    const SizedBox(height: 10),
                    _buildInfoRow('Total Vectors Indexed', '4,280 vectors', isDark),
                    const SizedBox(height: 10),
                    _buildInfoRow('Chunk Size / Overlap', '512 tokens / 50 tokens', isDark),
                    const SizedBox(height: 10),
                    _buildInfoRow('Distance Metric', 'Cosine Similarity', isDark),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 20),

              // Ingestion Pipeline Steps
              Text(
                'RAG Ingestion Pipeline Flow',
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              _buildPipelineStep('1', 'Document Extraction', 'Crawls websites & extracts text from PDFs / DOCX files', AppColors.primary, isDark),
              const SizedBox(height: 10),
              _buildPipelineStep('2', 'Semantic Chunking', 'Splits text into 512-token semantic segments with 50-token overlap', AppColors.secondary, isDark),
              const SizedBox(height: 10),
              _buildPipelineStep('3', 'OpenAI Embeddings', 'Generates 1536-dim vector embeddings via text-embedding-3-small', AppColors.success, isDark),
              const SizedBox(height: 10),
              _buildPipelineStep('4', 'Vector Indexing', 'Upserts vectors with rich metadata into Pinecone Hybrid namespace', const Color(0xFFF59E0B), isDark),

              const SizedBox(height: 24),

              // Re-index All Action Button
              CustomButton(
                text: _isReindexing ? 'Re-indexing Knowledge Base...' : 'Re-index Entire Knowledge Base',
                icon: const Icon(Icons.refresh_rounded, size: 18, color: Colors.white),
                isLoading: _isReindexing,
                onPressed: () {
                  PlatformHelper.mediumHaptic();
                  setState(() => _isReindexing = true);
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      setState(() => _isReindexing = false);
                      Get.snackbar('Re-index Complete', '4,280 vectors re-indexed and synchronized successfully', snackPosition: SnackPosition.BOTTOM);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 12),
        ),
        Text(
          value,
          style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPipelineStep(String step, String title, String description, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              step,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
