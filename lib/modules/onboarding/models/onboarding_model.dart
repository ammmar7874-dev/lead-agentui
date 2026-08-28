import 'package:flutter/material.dart';

class OnboardingItem {
  final String stepNumber;
  final String titlePrefix;
  final String titleSuffix;
  final String subtitle;
  final String description;
  final List<String> featureBadges;
  final IconData mainIcon;

  const OnboardingItem({
    required this.stepNumber,
    required this.titlePrefix,
    required this.titleSuffix,
    required this.subtitle,
    required this.description,
    required this.featureBadges,
    required this.mainIcon,
  });
}
