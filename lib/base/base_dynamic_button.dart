import 'package:flutter/material.dart';
import 'base_button_config.dart';

/// BASE PACKAGE: Generic, reusable button widget
class BaseDynamicButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BaseButtonConfig config;
  final bool disabled;

  const BaseDynamicButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.config,
    this.disabled = false,
  });

  Color _parseColor(String hex) {
    if (hex.toLowerCase() == 'transparent') return Colors.transparent;
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  FontWeight _parseFontWeight(String weight) {
    switch (weight.toLowerCase()) {
      case 'w100': return FontWeight.w100;
      case 'w200': return FontWeight.w200;
      case 'w300': return FontWeight.w300;
      case 'w400': return FontWeight.w400;
      case 'w500': return FontWeight.w500;
      case 'w600': return FontWeight.w600;
      case 'w700':
      case 'bold': return FontWeight.w700;
      case 'w800': return FontWeight.w800;
      case 'w900': return FontWeight.w900;
      default: return FontWeight.normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled;
    final List<Color>? enabledGradientColors = (config.gradientColors != null && config.gradientColors is List && (config.gradientColors as List).isNotEmpty)
        ? (config.gradientColors as List).map((c) => _parseColor(c.toString())).toList()
        : null;
    final List<Color>? disabledGradientColors = (config.disabledGradientColors != null && config.disabledGradientColors is List && (config.disabledGradientColors as List).isNotEmpty)
        ? (config.disabledGradientColors as List).map((c) => _parseColor(c.toString())).toList()
        : null;
    final bool useGradient = (!isDisabled && enabledGradientColors != null && enabledGradientColors.isNotEmpty)
        || (isDisabled && disabledGradientColors != null && disabledGradientColors.isNotEmpty);
    final gradientDirection = (config.gradientDirection ?? 'leftToRight').toString();

    final bgColor = isDisabled
        ? (config.disabledBackgroundColor != null ? _parseColor(config.disabledBackgroundColor!) : _parseColor(config.backgroundColor).withOpacity(0.4))
        : _parseColor(config.backgroundColor);
    final fgColor = isDisabled
        ? (config.disabledForegroundColor != null ? _parseColor(config.disabledForegroundColor!) : _parseColor(config.foregroundColor).withOpacity(0.4))
        : _parseColor(config.foregroundColor);
    final borderColor = isDisabled
        ? (config.disabledBorderColor != null ? _parseColor(config.disabledBorderColor!) : _parseColor(config.borderColor).withOpacity(0.4))
        : _parseColor(config.borderColor);

    Widget child = Text(
      label,
      style: TextStyle(
        color: fgColor,
        fontSize: config.fontSize,
        fontWeight: _parseFontWeight(config.fontWeight),
      ),
    );

    if (config.icon != null) {
      final icon = Icon(_iconFromString(config.icon!), color: fgColor, size: 20);
      child = config.iconPosition == 'left'
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [icon, const SizedBox(width: 8), child],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [child, const SizedBox(width: 8), icon],
            );
    }

    if (useGradient) {
      final List<Color> effectiveGradientColors = isDisabled && disabledGradientColors != null && disabledGradientColors.isNotEmpty
          ? disabledGradientColors
          : enabledGradientColors!;
      return SizedBox(
        height: config.height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: effectiveGradientColors,
              begin: gradientDirection == 'leftToRight' ? Alignment.centerLeft : Alignment.topCenter,
              end: gradientDirection == 'leftToRight' ? Alignment.centerRight : Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(config.borderRadius),
            border: Border.all(color: borderColor, width: config.borderWidth),
          ),
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: fgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(config.borderRadius),
                side: BorderSide(color: Colors.transparent, width: 0),
              ),
              elevation: 2,
              textStyle: TextStyle(
                fontSize: config.fontSize,
                fontWeight: _parseFontWeight(config.fontWeight),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: child,
          ),
        ),
      );
    } else if ((config.name?.toLowerCase() ?? '') == 'outline') {
      return SizedBox(
        height: config.height,
        child: OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: fgColor,
            side: BorderSide(color: borderColor, width: config.borderWidth),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(config.borderRadius),
            ),
            textStyle: TextStyle(
              fontSize: config.fontSize,
              fontWeight: _parseFontWeight(config.fontWeight),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          child: child,
        ),
      );
    } else {
      return SizedBox(
        height: config.height,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: fgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(config.borderRadius),
              side: BorderSide(color: borderColor, width: config.borderWidth),
            ),
            elevation: 2,
            textStyle: TextStyle(
              fontSize: config.fontSize,
              fontWeight: _parseFontWeight(config.fontWeight),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          child: child,
        ),
      );
    }
  }

  IconData? _iconFromString(String iconName) {
    switch (iconName) {
      case 'thumb_up':
        return Icons.thumb_up;
      case 'arrow_forward':
        return Icons.arrow_forward;
      default:
        return null;
    }
  }
}
