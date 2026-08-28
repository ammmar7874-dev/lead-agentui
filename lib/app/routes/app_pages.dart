import 'package:get/get.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/forgot_password_view.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/signup_view.dart';
import '../../modules/onboarding/bindings/onboarding_binding.dart';
import '../../modules/onboarding/views/onboarding_view.dart';
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/user/bindings/user_binding.dart';
import '../../modules/user/views/bot_settings_view.dart';
import '../../modules/user/views/crawl_failures_view.dart';
import '../../modules/user/views/escalations_view.dart';
import '../../modules/user/views/feedback_view.dart';
import '../../modules/user/views/governance_view.dart';
import '../../modules/user/views/ingestion_view.dart';
import '../../modules/user/views/knowledge_gaps_view.dart';
import '../../modules/user/views/live_activity_view.dart';
import '../../modules/user/views/main_shell_view.dart';
import '../../modules/user/views/messages_analytics_view.dart';
import '../../modules/user/views/my_reviews_view.dart';
import '../../modules/user/views/sync_jobs_view.dart';
import '../../modules/user/views/token_usage_view.dart';
import '../../modules/user/views/transcripts_view.dart';
import '../../modules/user/views/visitors_view.dart';
import '../../modules/user/views/widget_manager_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const MainShellView(),
      binding: UserBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.botSettings,
      page: () => const BotSettingsView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.tokenUsage,
      page: () => const TokenUsageView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.visitors,
      page: () => const VisitorsView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.transcripts,
      page: () => const TranscriptsView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.messagesAnalytics,
      page: () => const MessagesAnalyticsView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.widgetManager,
      page: () => const WidgetManagerView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.feedback,
      page: () => const FeedbackView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.escalations,
      page: () => const EscalationsView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.syncJobs,
      page: () => const SyncJobsView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.ingestion,
      page: () => const IngestionView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.crawlFailures,
      page: () => const CrawlFailuresView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.knowledgeGaps,
      page: () => const KnowledgeGapsView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.governance,
      page: () => const GovernanceView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.myReviews,
      page: () => const MyReviewsView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.liveActivity,
      page: () => const LiveActivityView(),
      binding: UserBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
