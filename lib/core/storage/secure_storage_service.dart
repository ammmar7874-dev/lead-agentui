import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SecureStorageService extends GetxService {
  static SecureStorageService get to => Get.find();
  late GetStorage _box;

  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String _keyThemeMode = 'theme_mode'; // 'dark' or 'light'
  static const String _keyActiveBotId = 'active_bot_id';

  Future<SecureStorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  // Token
  Future<void> saveToken(String token) async => await _box.write(_keyToken, token);
  String? getToken() => _box.read<String>(_keyToken);
  Future<void> removeToken() async => await _box.remove(_keyToken);

  // User
  Future<void> saveUserData(Map<String, dynamic> userJson) async => await _box.write(_keyUser, userJson);
  Map<String, dynamic>? getUserData() => _box.read<Map<String, dynamic>>(_keyUser);
  Future<void> removeUserData() async => await _box.remove(_keyUser);

  // Auth State
  Future<void> setIsLoggedIn(bool value) async => await _box.write(_keyIsLoggedIn, value);
  bool isLoggedIn() => _box.read<bool>(_keyIsLoggedIn) ?? false;

  // Onboarding
  Future<void> setHasSeenOnboarding(bool value) async => await _box.write(_keyHasSeenOnboarding, value);
  bool hasSeenOnboarding() => _box.read<bool>(_keyHasSeenOnboarding) ?? false;

  // Theme
  Future<void> saveThemeMode(String mode) async => await _box.write(_keyThemeMode, mode);
  String getThemeMode() => _box.read<String>(_keyThemeMode) ?? 'dark';

  // Active Bot
  Future<void> saveActiveBotId(String botId) async => await _box.write(_keyActiveBotId, botId);
  String getActiveBotId() => _box.read<String>(_keyActiveBotId) ?? 'bot_default';

  // Clear all
  Future<void> clearAll() async {
    final hasSeenOnboard = hasSeenOnboarding();
    final theme = getThemeMode();
    await _box.erase();
    await setHasSeenOnboarding(hasSeenOnboard);
    await saveThemeMode(theme);
  }
}
