enum Environment { dev, staging, prod }

class EnvConfig {
  final Environment environment;
  final String baseUrl;
  final String apiVersion;
  final String appTitle;

  const EnvConfig({
    required this.environment,
    required this.baseUrl,
    required this.apiVersion,
    required this.appTitle,
  });

  static const EnvConfig dev = EnvConfig(
    environment: Environment.dev,
    baseUrl: 'https://airagchatbot.com',
    apiVersion: 'v1',
    appTitle: 'AI ChatBot (Dev)',
  );

  static const EnvConfig prod = EnvConfig(
    environment: Environment.prod,
    baseUrl: 'https://airagchatbot.com',
    apiVersion: 'v1',
    appTitle: 'AI RAG ChatBot',
  );
}
