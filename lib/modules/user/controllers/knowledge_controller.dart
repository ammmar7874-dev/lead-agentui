import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../models/knowledge_source_model.dart';
import '../models/sync_job_model.dart';

class SearchTestResult {
  final String sourceTitle;
  final String contentSnippet;
  final double score;

  const SearchTestResult({
    required this.sourceTitle,
    required this.contentSnippet,
    required this.score,
  });
}

class KnowledgeController extends GetxController {
  static KnowledgeController get to => Get.find();

  final RxBool isLoading = false.obs;
  final RxString activeSubTab = 'sources'.obs; // 'sources', 'sync_jobs', 'test_search'

  // Stats
  final RxInt totalSources = 12.obs;
  final RxInt totalDocuments = 113.obs;
  final RxInt totalChunks = 2611.obs;
  final RxInt totalIndexedChunks = 2611.obs;

  // Sync Jobs stats
  final RxInt jobsSucceeded = 77.obs;
  final RxInt jobsFailed = 23.obs;
  final RxInt jobsInProgress = 0.obs;
  final RxInt jobsTotal = 100.obs;

  // Search Tester
  final TextEditingController searchTestController = TextEditingController();
  final RxList<SearchTestResult> testSearchResults = <SearchTestResult>[].obs;
  final RxBool isSearching = false.obs;

  // Knowledge Sources List
  final RxList<KnowledgeSourceModel> sources = <KnowledgeSourceModel>[
    KnowledgeSourceModel(
      id: 'src_1',
      title: 'AI SEO',
      type: 'Website',
      documentCount: 6,
      chunkCount: 93,
      syncStatus: 'SUCCEEDED',
      autoSync: true,
      syncInterval: '24 hours',
      lastSync: DateTime.now().subtract(const Duration(hours: 4)),
      nextSync: DateTime.now().add(const Duration(hours: 20)),
    ),
    KnowledgeSourceModel(
      id: 'src_2',
      title: 'AI Social Hub',
      type: 'Website',
      documentCount: 2,
      chunkCount: 21,
      syncStatus: 'SUCCEEDED',
      autoSync: true,
      syncInterval: '24 hours',
      lastSync: DateTime.now().subtract(const Duration(hours: 5)),
      nextSync: DateTime.now().add(const Duration(hours: 19)),
    ),
    KnowledgeSourceModel(
      id: 'src_3',
      title: 'AI RAG ChatBot Knowledge Docs',
      type: 'PDF & FAQs',
      documentCount: 6,
      chunkCount: 87,
      syncStatus: 'SUCCEEDED',
      autoSync: true,
      syncInterval: '24 hours',
      lastSync: DateTime.now().subtract(const Duration(hours: 6)),
      nextSync: DateTime.now().add(const Duration(hours: 18)),
    ),
    KnowledgeSourceModel(
      id: 'src_4',
      title: 'AI Designerly Studio',
      type: 'Website',
      documentCount: 4,
      chunkCount: 54,
      syncStatus: 'FAILED',
      autoSync: false,
      syncInterval: '12 hours',
      lastSync: DateTime.now().subtract(const Duration(hours: 9)),
      nextSync: DateTime.now().add(const Duration(hours: 3)),
    ),
  ].obs;

  // Sync Jobs List
  final RxList<SyncJobModel> syncJobs = <SyncJobModel>[
    SyncJobModel(
      id: 'job_1',
      sourceTitle: 'AI SEO',
      executedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      duration: '16s',
      pages: 1,
      docs: 0,
      chunks: 0,
      embedded: 93,
      status: 'SUCCEEDED',
    ),
    SyncJobModel(
      id: 'job_2',
      sourceTitle: 'AI Social Hub',
      executedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 10)),
      duration: '1m 19s',
      pages: 7,
      docs: 1,
      chunks: 16,
      embedded: 21,
      status: 'SUCCEEDED',
    ),
    SyncJobModel(
      id: 'job_3',
      sourceTitle: 'AI RAG ChatBot',
      executedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 25)),
      duration: '1m 26s',
      pages: 7,
      docs: 1,
      chunks: 24,
      embedded: 87,
      status: 'SUCCEEDED',
    ),
    SyncJobModel(
      id: 'job_4',
      sourceTitle: 'AI Designerly',
      executedAt: DateTime.now().subtract(const Duration(hours: 8)),
      duration: '5m 22s',
      pages: 0,
      docs: 0,
      chunks: 0,
      embedded: 0,
      status: 'FAILED',
      errorMessage: 'Job could not complete after 3 automatic retries (worker kept stopping mid-run)',
    ),
  ].obs;

  void setSubTab(String tabKey) {
    activeSubTab.value = tabKey;
    PlatformHelper.selectionHaptic();
  }

  void toggleAutoSync(String sourceId) {
    PlatformHelper.selectionHaptic();
    final index = sources.indexWhere((s) => s.id == sourceId);
    if (index != -1) {
      final current = sources[index];
      sources[index] = current.copyWith(autoSync: !current.autoSync);
    }
  }

  Future<void> triggerSync(String sourceId) async {
    PlatformHelper.mediumHaptic();
    final index = sources.indexWhere((s) => s.id == sourceId);
    if (index != -1) {
      sources[index] = sources[index].copyWith(syncStatus: 'SYNCING');
      await Future.delayed(const Duration(seconds: 2));
      sources[index] = sources[index].copyWith(
        syncStatus: 'SUCCEEDED',
        lastSync: DateTime.now(),
      );
      PlatformHelper.lightHaptic();
      Get.snackbar(
        'Sync Completed',
        'Source "${sources[index].title}" has been re-indexed successfully.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> performTestSearch() async {
    final query = searchTestController.text.trim();
    if (query.isEmpty) return;

    isSearching.value = true;
    PlatformHelper.lightHaptic();
    await Future.delayed(const Duration(milliseconds: 700));

    testSearchResults.assignAll([
      SearchTestResult(
        sourceTitle: 'AI SEO (excels-tech.ai)',
        contentSnippet: '...matching vector index for keywords "$query". High semantic density in service descriptions and landing page headers.',
        score: 0.94,
      ),
      SearchTestResult(
        sourceTitle: 'AI RAG Knowledge Docs',
        contentSnippet: '...system prompt configurations and FAQ answer mapping relevant to "$query".',
        score: 0.88,
      ),
    ]);

    isSearching.value = false;
  }

  @override
  void onClose() {
    searchTestController.dispose();
    super.onClose();
  }
}
