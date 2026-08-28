import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../../../core/storage/secure_storage_service.dart';

class UserSharedController extends GetxController {
  static UserSharedController get to => Get.find();

  // Active Bottom Navigation Tab (0: Dashboard, 1: Chat, 2: Knowledge, 3: Leads, 4: Profile)
  final RxInt currentTabIndex = 0.obs;

  // Active Drawer Item
  final RxString activeDrawerRoute = 'dashboard'.obs;

  // Notification Counts
  final RxInt unreadLeadsCount = 3.obs;
  final RxInt activeVisitorsCount = 25.obs;

  // Theme Mode
  final RxBool isDarkMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    final savedMode = SecureStorageService.to.getThemeMode();
    isDarkMode.value = (savedMode == 'dark');
  }

  void switchTab(int index) {
    if (currentTabIndex.value != index) {
      PlatformHelper.selectionHaptic();
      currentTabIndex.value = index;
    }
  }

  void toggleTheme() {
    PlatformHelper.mediumHaptic();
    isDarkMode.toggle();
    final modeStr = isDarkMode.value ? 'dark' : 'light';
    SecureStorageService.to.saveThemeMode(modeStr);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void navigateFromDrawer(String routeKey) {
    activeDrawerRoute.value = routeKey;
    PlatformHelper.lightHaptic();
    switch (routeKey) {
      case 'dashboard':
        currentTabIndex.value = 0;
        break;
      case 'chat':
        currentTabIndex.value = 1;
        break;
      case 'sources':
      case 'sync_jobs':
        currentTabIndex.value = 2;
        break;
      case 'leads':
      case 'visitors':
        currentTabIndex.value = 3;
        break;
      case 'profile':
      case 'settings':
      case 'bot_settings':
      case 'token_usage':
        currentTabIndex.value = 4;
        break;
    }
    Get.back(); // close drawer
  }
}
