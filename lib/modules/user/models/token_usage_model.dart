class EndpointUsageModel {
  final String name; // 'ANSWER', 'EMBED', 'REWRITE'
  final String tokensFormatted;
  final double usagePercentage;
  final int apiCalls;
  final String avgTokensPerCall;

  const EndpointUsageModel({
    required this.name,
    required this.tokensFormatted,
    required this.usagePercentage,
    required this.apiCalls,
    required this.avgTokensPerCall,
  });
}

class TokenUsageModel {
  final String totalTokens;
  final String inputTokens;
  final String outputTokens;
  final int apiCalls;
  final List<double> dailyTrend;
  final List<EndpointUsageModel> endpoints;

  const TokenUsageModel({
    required this.totalTokens,
    required this.inputTokens,
    required this.outputTokens,
    required this.apiCalls,
    required this.dailyTrend,
    required this.endpoints,
  });
}
