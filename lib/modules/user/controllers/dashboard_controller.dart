import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../theme/app_colors.dart';
import '../models/stat_metric_model.dart';

class QuickActionItem {
  final String id;
  final String title;
  final String description;
  final String icon;
  final RxBool isShown;

  QuickActionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    bool isShown = true,
  }) : isShown = isShown.obs;
}

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();

  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  // Real-time Metrics
  final RxInt totalVisitors = 301.obs;
  final RxInt conversations = 56.obs;
  final RxInt totalMessages = 168.obs;
  final RxInt leadsCaptured = 18.obs;
  final RxInt knowledgeSources = 12.obs;
  final RxInt thisWeekConversations = 7.obs;

  // 7-day conversation bar chart values
  final List<double> weeklyConversationCounts = [0, 0, 0, 3, 1, 3, 0];
  final List<String> weekDays = ['Fri', 'Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu'];

  // Quick Action Functionality Cards (From screenshot 223412)
  final RxList<QuickActionItem> quickActions = <QuickActionItem>[
    QuickActionItem(
      id: 'mvp',
      title: 'MVP Development',
      description: 'How can you help me with MVP development?',
      icon: '🚀',
      isShown: true,
    ),
    QuickActionItem(
      id: 'prop',
      title: 'Property Management Software',
      description: 'What solutions do you offer for property management?',
      icon: '🏢',
      isShown: false,
    ),
    QuickActionItem(
      id: 'health',
      title: 'Healthcare Software Development',
      description: 'What healthcare software development services do you provide?',
      icon: '🏥',
      isShown: false,
    ),
    QuickActionItem(
      id: 'supply',
      title: 'Supply Chain Software',
      description: 'How can your software help with supply chain management?',
      icon: '📦',
      isShown: true,
    ),
    QuickActionItem(
      id: 'hospitality',
      title: 'Hospitality Software',
      description: 'What custom software do you offer for hotels and resorts?',
      icon: '🏨',
      isShown: true,
    ),
    QuickActionItem(
      id: 'retail',
      title: 'Retail Software Development',
      description: 'What retail and e-commerce software solutions do you have?',
      icon: '🛒',
      isShown: true,
    ),
  ].obs;

  List<StatMetricModel> get statMetrics => [
        StatMetricModel(
          title: 'TOTAL VISITORS',
          value: totalVisitors.value,
          subtitle: '25 live on site',
          icon: Icons.people_alt_rounded,
          color: AppColors.secondary,
          trend: '+18%',
        ),
        StatMetricModel(
          title: 'CONVERSATIONS',
          value: conversations.value,
          subtitle: '7 this week',
          icon: Icons.chat_bubble_rounded,
          color: const Color(0xFFEC4899),
          trend: '+24%',
        ),
        StatMetricModel(
          title: 'TOTAL MESSAGES',
          value: totalMessages.value,
          subtitle: 'Avg 3 msgs/chat',
          icon: Icons.mark_email_read_rounded,
          color: const Color(0xFF10B981),
          trend: '+12%',
        ),
        StatMetricModel(
          title: 'LEADS CAPTURED',
          value: leadsCaptured.value,
          subtitle: '3 new inquiries',
          icon: Icons.trending_up_rounded,
          color: const Color(0xFFF59E0B),
          trend: '+40%',
        ),
        StatMetricModel(
          title: 'KNOWLEDGE SOURCES',
          value: knowledgeSources.value,
          subtitle: '2,611 chunks indexed',
          icon: Icons.folder_special_rounded,
          color: const Color(0xFF8B5CF6),
        ),
      ];

  Future<void> refreshDashboard() async {
    isRefreshing.value = true;
    PlatformHelper.lightHaptic();
    await Future.delayed(const Duration(milliseconds: 700));
    totalVisitors.value += 1;
    isRefreshing.value = false;
  }

  void toggleQuickAction(String id) {
    PlatformHelper.selectionHaptic();
    final action = quickActions.firstWhereOrNull((a) => a.id == id);
    if (action != null) {
      action.isShown.toggle();
    }
  }
}
