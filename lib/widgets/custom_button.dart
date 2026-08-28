import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../core/native/platform_helper.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isSecondary;
  final dynamic icon;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isSecondary = false,
    this.icon,
    this.width,
    this.height = 52,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _animController.forward();
      PlatformHelper.lightHaptic();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _animController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = widget.borderRadius ?? BorderRadius.circular(14);

    Color bg;
    if (widget.isOutlined) {
      bg = Colors.transparent;
    } else if (widget.backgroundColor != null) {
      bg = widget.backgroundColor!;
    } else if (widget.isSecondary) {
      bg = AppColors.secondary;
    } else {
      bg = AppColors.primary;
    }

    Color txtColor;
    if (widget.textColor != null) {
      txtColor = widget.textColor!;
    } else if (widget.isOutlined) {
      txtColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    } else {
      txtColor = Colors.white;
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: SizedBox(
          width: widget.width ?? double.infinity,
          height: widget.height,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: (!widget.isOutlined && widget.backgroundColor == null && !widget.isSecondary)
                  ? AppColors.primaryGradient
                  : null,
              color: bg,
              borderRadius: radius,
              border: widget.isOutlined
                  ? Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      width: 1.5,
                    )
                  : null,
              boxShadow: (widget.onPressed != null && !widget.isOutlined && !widget.isLoading)
                  ? [
                      BoxShadow(
                        color: (widget.isSecondary ? AppColors.secondary : AppColors.primary).withAlpha(60),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isLoading ? null : widget.onPressed,
                borderRadius: radius,
                child: Padding(
                  padding: widget.padding ??
                      (widget.text.isEmpty
                          ? EdgeInsets.zero
                          : const EdgeInsets.symmetric(horizontal: 16)),
                  child: Center(
                    child: widget.isLoading
                        ? const SpinKitThreeBounce(
                            color: Colors.white,
                            size: 22,
                          )
                        : Builder(
                            builder: (context) {
                              Widget? renderedIcon;
                              if (widget.icon is Widget) {
                                renderedIcon = widget.icon as Widget;
                              } else if (widget.icon is IconData) {
                                renderedIcon = Icon(
                                  widget.icon as IconData,
                                  size: 18,
                                  color: txtColor,
                                );
                              }

                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ?renderedIcon,
                                  if (renderedIcon != null && widget.text.isNotEmpty)
                                    const SizedBox(width: 8),
                                  if (widget.text.isNotEmpty)
                                    Flexible(
                                      child: Text(
                                        widget.text,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.labelLarge(
                                          isDark: isDark,
                                          color: txtColor,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
