import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/knowledge_controller.dart';
import '../controllers/user_shared_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(AuthController(), permanent: true);
    }
    Get.lazyPut<UserSharedController>(() => UserSharedController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<KnowledgeController>(() => KnowledgeController());
  }
}
