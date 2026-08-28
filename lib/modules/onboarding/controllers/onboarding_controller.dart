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
      title: 'Train AI on Your ',
      highlightWord: 'Knowledge Base',
      description:
          'Connect your website, PDF documents, FAQs, and APIs. Your chatbot retrieves precise answers instantly with RAG technology.',
      imagePath: 'assets/images/onboarding_rag.jpg',
      badgeText: '✨ RAG-POWERED AI',
    ),
    OnboardingItem(
      title: 'Capture Leads & ',
      highlightWord: 'Track Visitors',
      description:
          'Monitor live visitor sessions in real-time, qualify incoming inquiries automatically, and export high-intent leads effortlessly.',
      imagePath: 'assets/images/onboarding_analytics.jpg',
      badgeText: '📊 REAL-TIME ANALYTICS',
    ),
    OnboardingItem(
      title: 'Seamless Multi-Channel ',
      highlightWord: 'Integration',
      description:
          'One-line script embed for web, native mobile widgets, CRM integrations, and full bot customization with live preview.',
      imagePath: 'assets/images/onboarding_integration.jpg',
      badgeText: '⚡ OMNICHANNEL CHAT',
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
