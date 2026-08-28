import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle displayLarge({bool isDark = true, Color? color}) => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      );

  static TextStyle displayMedium({bool isDark = true, Color? color}) => GoogleFonts.outfit(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      );

  static TextStyle displaySmall({bool isDark = true, Color? color}) => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      );

  static TextStyle titleLarge({bool isDark = true, Color? color}) => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      );

  static TextStyle titleMedium({bool isDark = true, Color? color}) => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      );

  static TextStyle titleSmall({bool isDark = true, Color? color}) => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      );

  static TextStyle bodyLarge({bool isDark = true, Color? color}) => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
      );

  static TextStyle bodyMedium({bool isDark = true, Color? color}) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
      );

  static TextStyle bodySmall({bool isDark = true, Color? color}) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: color ?? (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
      );

  static TextStyle labelLarge({bool isDark = true, Color? color}) => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      );

  static TextStyle labelMedium({bool isDark = true, Color? color}) => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
      );

  static TextStyle labelSmall({bool isDark = true, Color? color}) => GoogleFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: color ?? (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
      );

  static TextStyle mono({bool isDark = true, Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      );
}
