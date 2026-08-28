class BotConfigModel {
  final String id;
  final String assistantName;
  final String welcomeMessage;
  final String themeColorHex;
  final int selectedIconIndex;
  final String? customIconPath;
  final bool emailNotificationsEnabled;
  final String notificationEmail;
  final String widgetScriptCode;
  final List<String> allowedWebsites;

  const BotConfigModel({
    required this.id,
    required this.assistantName,
    required this.welcomeMessage,
    required this.themeColorHex,
    required this.selectedIconIndex,
    this.customIconPath,
    required this.emailNotificationsEnabled,
    required this.notificationEmail,
    required this.widgetScriptCode,
    required this.allowedWebsites,
  });

  BotConfigModel copyWith({
    String? id,
    String? assistantName,
    String? welcomeMessage,
    String? themeColorHex,
    int? selectedIconIndex,
    String? customIconPath,
    bool? emailNotificationsEnabled,
    String? notificationEmail,
    String? widgetScriptCode,
    List<String>? allowedWebsites,
  }) {
    return BotConfigModel(
      id: id ?? this.id,
      assistantName: assistantName ?? this.assistantName,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      themeColorHex: themeColorHex ?? this.themeColorHex,
      selectedIconIndex: selectedIconIndex ?? this.selectedIconIndex,
      customIconPath: customIconPath ?? this.customIconPath,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      notificationEmail: notificationEmail ?? this.notificationEmail,
      widgetScriptCode: widgetScriptCode ?? this.widgetScriptCode,
      allowedWebsites: allowedWebsites ?? this.allowedWebsites,
    );
  }
}
