class OnboardingItem {
  final String stepNumber;
  final String title;
  final String highlightWord;
  final String description;
  final String imagePath;
  final String badgeText;
  final List<String> featureBadges;

  const OnboardingItem({
    required this.stepNumber,
    required this.title,
    required this.highlightWord,
    required this.description,
    required this.imagePath,
    required this.badgeText,
    this.featureBadges = const [],
  });
}
