import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/native/platform_helper.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../models/onboarding_model.dart';

class OnboardingController extends GetxController {
  static OnboardingController get to => Get.find();

  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingItem> items = const [
    OnboardingItem(
      stepNumber: '01 · AUTOMATION',
      titlePrefix: 'AI Agents ',
      titleSuffix: 'Do All Your Email Work',
      subtitle: 'Autonomous Cold Outreach & Follow-Ups',
      description:
          'No more manual sending, forgotten follow-ups, or wasted hours. Your AI agents draft, validate & launch campaigns automatically.',
      featureBadges: [
        '⚡ 247+ Features',
        '🔒 5-Step Validation Pipeline',
      ],
      mainIcon: Icons.mark_email_read_rounded,
    ),
    OnboardingItem(
      stepNumber: '02 · RAG KNOWLEDGE',
      titlePrefix: 'Instant Answers ',
      titleSuffix: 'From Your Documents',
      subtitle: 'Vectorized Pinecone Search & Real-time AI',
      description:
          'Connect your knowledge base, APIs, and websites. Autonomous RAG indexes documents and answers customer queries in milliseconds.',
      featureBadges: [
        '🧠 OpenAI & Pinecone Hybrid RAG',
        '⚡ 99.4% Retrieval Accuracy',
      ],
      mainIcon: Icons.auto_awesome_rounded,
    ),
    OnboardingItem(
      stepNumber: '03 · CONVERSIONS',
      titlePrefix: 'Qualify Leads ',
      titleSuffix: '& Convert 24/7',
      subtitle: 'High-Intent Customer Handoff & Telemetry',
      description:
          'Track live visitor telemetry, capture qualified buyer leads automatically, and export high-conversion CRM transcripts effortlessly.',
      featureBadges: [
        '📈 3.4x Higher Conversion Rate',
        '🛡️ Enterprise PII Guardrails',
      ],
      mainIcon: Icons.bolt_rounded,
    ),
  ];

  bool get isLastPage => currentPage.value == items.length - 1;

  void onPageChanged(int index) {
    currentPage.value = index;
    PlatformHelper.selectionHaptic();
  }

  void nextPage() {
    if (isLastPage) {
      finishOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> finishOnboarding() async {
    PlatformHelper.mediumHaptic();
    await SecureStorageService.to.setHasSeenOnboarding(true);
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
