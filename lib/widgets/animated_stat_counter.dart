import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_text_styles.dart';

class AnimatedStatCounter extends StatelessWidget {
  final num value;
  final TextStyle? style;
  final Duration duration;
  final String prefix;
  final String suffix;
  final int decimalDigits;

  const AnimatedStatCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 1500),
    this.prefix = '',
    this.suffix = '',
    this.decimalDigits = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = style ?? AppTextStyles.displayMedium(isDark: isDark);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        String formatted;
        if (decimalDigits > 0) {
          formatted = NumberFormat.currency(
            symbol: '',
            decimalDigits: decimalDigits,
          ).format(animatedValue).trim();
        } else {
          formatted = NumberFormat.decimalPattern().format(animatedValue.round());
        }

        return Text(
          '$prefix$formatted$suffix',
          style: textStyle,
        );
      },
    );
  }
}
