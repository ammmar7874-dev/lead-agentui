import 'environment.dart';

class AppConfig {
  static EnvConfig _current = EnvConfig.prod;

  static EnvConfig get current => _current;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.dev:
        _current = EnvConfig.dev;
        break;
      case Environment.staging:
      case Environment.prod:
        _current = EnvConfig.prod;
        break;
    }
  }

  static const String appName = 'AI RAG ChatBot';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@airagchatbot.com';
  static const String websiteUrl = 'https://airagchatbot.com';
}
