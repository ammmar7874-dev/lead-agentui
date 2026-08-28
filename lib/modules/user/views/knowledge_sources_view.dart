import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/animated_stat_counter.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/knowledge_controller.dart';
import '../controllers/user_shared_controller.dart';
import '../models/knowledge_source_model.dart';

class KnowledgeSourcesView extends GetView<KnowledgeController> {
  const KnowledgeSourcesView({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedController = Get.find<UserSharedController>();

    return Obx(() {
      final isDark = sharedController.isDarkMode.value;
      final activeTab = controller.activeSubTab.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: Column(
          children: [
            // Top Sub-Tab Switcher (Sources / Sync Jobs / Search Tester)
            _buildSubTabBar(isDark),

            // Content Area based on selected sub-tab
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (activeTab == 'sources') _buildSourcesContent(isDark),
                    if (activeTab == 'sync_jobs') _buildSyncJobsContent(isDark),
                    if (activeTab == 'test_search') _buildSearchTesterContent(isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSubTabBar(bool isDark) {
    final tabs = [
      {'key': 'sources', 'label': 'Sources (12)', 'icon': Icons.folder_special_rounded},
      {'key': 'sync_jobs', 'label': 'Sync Jobs (100)', 'icon': Icons.history_rounded},
      {'key': 'test_search', 'label': 'Search Tester', 'icon': Icons.saved_search_rounded},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
          ),
        ),
      ),
      child: Row(
        children: tabs.map((t) {
          final isSelected = controller.activeSubTab.value == t['key'];
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.setSubTab(t['key'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkCard : AppColors.lightCardHover),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      t['icon'] as IconData,
                      size: 14,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        t['label'] as String,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 1. Sources Content
  Widget _buildSourcesContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Index Summary Card
        CustomCard(
          padding: const EdgeInsets.all(16),
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
          borderColor: AppColors.primary.withValues(alpha: 0.25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricColumn('SOURCES', controller.totalSources.value, isDark),
              Container(height: 32, width: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              _buildMetricColumn('DOCUMENTS', controller.totalDocuments.value, isDark),
              Container(height: 32, width: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              _buildMetricColumn('CHUNKS', controller.totalChunks.value, isDark),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Connected Sources', style: AppTextStyles.titleMedium(isDark: isDark)),
            ElevatedButton.icon(
              onPressed: () {
                _showAddSourceBottomSheet(isDark);
              },
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add Source', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // List of Knowledge Sources
        Obx(
          () => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.sources.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final src = controller.sources[index];
              return _buildSourceCard(src, isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMetricColumn(String label, int value, bool isDark) {
    return Column(
      children: [
        AnimatedStatCounter(
          value: value,
          style: AppTextStyles.titleLarge(isDark: isDark).copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 0.5,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSourceCard(KnowledgeSourceModel src, bool isDark) {
    final isFailed = src.syncStatus == 'FAILED';
    final isSyncing = src.syncStatus == 'SYNCING';

    return CustomCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
      borderColor: isFailed
          ? AppColors.error.withValues(alpha: 0.4)
          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isFailed ? AppColors.errorSoft : AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  src.type == 'Website' ? Icons.language_rounded : Icons.description_rounded,
                  color: isFailed ? AppColors.error : AppColors.primaryLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      src.title,
                      style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${src.type} • ${src.documentCount} docs • ${src.chunkCount} chunks',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              CustomBadge(
                text: src.syncStatus,
                isPulsing: isSyncing,
                backgroundColor: isFailed
                    ? AppColors.errorSoft
                    : (isSyncing ? AppColors.warningSoft : AppColors.successSoft),
                textColor: isFailed
                    ? AppColors.error
                    : (isSyncing ? AppColors.warning : AppColors.success),
                fontSize: 10,
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 12, color: AppColors.darkBorderSubtle),
          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Auto-Sync (${src.syncInterval})',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    height: 24,
                    width: 38,
                    child: Switch(
                      value: src.autoSync,
                      onChanged: (_) => controller.toggleAutoSync(src.id),
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: isSyncing ? null : () => controller.triggerSync(src.id),
                icon: isSyncing
                    ? const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.sync_rounded, size: 14),
                label: Text(isSyncing ? 'Syncing...' : 'Sync Now', style: const TextStyle(fontSize: 11)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddSourceBottomSheet(bool isDark) {
    final urlCtrl = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Knowledge Source', style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              'Crawl website URL, sitemap, or upload PDFs to vector index',
              style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Website / Sitemap URL',
              hint: 'https://example.com/docs',
              controller: urlCtrl,
              prefixIcon: const Icon(Icons.link_rounded),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Start Vector Indexing',
              onPressed: () {
                Get.back();
                Get.snackbar('Job Started', 'Vector ingestion worker queued for URL', snackPosition: SnackPosition.TOP);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 2. Sync Jobs Content
  Widget _buildSyncJobsContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Cards
        Row(
          children: [
            Expanded(
              child: _buildJobStatPill('SUCCEEDED', controller.jobsSucceeded.value, AppColors.success, isDark),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildJobStatPill('FAILED', controller.jobsFailed.value, AppColors.error, isDark),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildJobStatPill('TOTAL', controller.jobsTotal.value, AppColors.secondary, isDark),
            ),
          ],
        ),

        const SizedBox(height: 18),
        Text('Execution History', style: AppTextStyles.titleMedium(isDark: isDark)),
        const SizedBox(height: 12),

        Obx(
          () => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.syncJobs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final job = controller.syncJobs[index];
              final isSuccess = job.status == 'SUCCEEDED';

              return CustomCard(
                padding: const EdgeInsets.all(14),
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                borderColor: isSuccess
                    ? (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                    : AppColors.error.withValues(alpha: 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          job.sourceTitle,
                          style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                        ),
                        CustomBadge(
                          text: job.status,
                          backgroundColor: isSuccess ? AppColors.successSoft : AppColors.errorSoft,
                          textColor: isSuccess ? AppColors.success : AppColors.error,
                          fontSize: 10,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${DateFormat('MMM dd, yyyy • HH:mm').format(job.executedAt)} • Duration: ${job.duration}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.lightCardHover,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pages: ${job.pages} | Docs: ${job.docs} | Chunks: ${job.chunks}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                          Text(
                            'Embedded: ${job.embedded}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (job.errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.errorSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.error),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                job.errorMessage!,
                                style: const TextStyle(color: AppColors.error, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJobStatPill(String label, int count, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  // 3. Search Tester Content
  Widget _buildSearchTesterContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vector Semantic Search Tester',
          style: AppTextStyles.titleMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Test query vector retrieval against your indexed sources to inspect cosine similarity scores and matching chunks.',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Test Query',
                hint: 'e.g. MVP development timeline or pricing',
                controller: controller.searchTestController,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => Container(
                height: 52,
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: controller.isSearching.value ? null : controller.performTestSearch,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: controller.isSearching.value
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Test'),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Obx(() {
          if (controller.testSearchResults.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.manage_search_rounded, size: 48, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    const SizedBox(height: 12),
                    Text(
                      'Enter a query above to test RAG similarity matches.',
                      style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Matching Vector Chunks (${controller.testSearchResults.length})', style: AppTextStyles.titleSmall(isDark: isDark)),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.testSearchResults.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final res = controller.testSearchResults[index];
                  return CustomCard(
                    padding: const EdgeInsets.all(14),
                    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                    borderColor: AppColors.secondary.withValues(alpha: 0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                res.sourceTitle,
                                style: AppTextStyles.titleSmall(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            CustomBadge(
                              text: 'Similarity ${(res.score * 100).toInt()}%',
                              backgroundColor: AppColors.successSoft,
                              textColor: AppColors.success,
                              fontSize: 10,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightCardHover,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            res.contentSnippet,
                            style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        }),
      ],
    );
  }
}
