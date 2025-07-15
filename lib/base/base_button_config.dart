/// BASE PACKAGE: Generic button config for design system
class BaseButtonConfig {
  final String? name;
  final String backgroundColor;
  final String foregroundColor;
  final String borderColor;
  final double borderWidth;
  final double borderRadius;
  final double fontSize;
  final String fontWeight;
  final String? icon;
  final String? iconPosition;
  final double height;
  final String? disabledBackgroundColor;
  final String? disabledForegroundColor;
  final String? disabledBorderColor;

  final List<String>? gradientColors;
  final String? gradientDirection;
  final List<String>? disabledGradientColors;

  const BaseButtonConfig({
    this.name,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.fontSize,
    required this.fontWeight,
    this.icon,
    this.iconPosition,
    required this.height,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.disabledBorderColor,
    this.gradientColors,
    this.gradientDirection,
    this.disabledGradientColors,
  });

  factory BaseButtonConfig.fromJson(Map<String, dynamic> json) {
    return BaseButtonConfig(
      name: json['name'],
      backgroundColor: json['backgroundColor'],
      foregroundColor: json['foregroundColor'],
      borderColor: json['borderColor'],
      borderWidth: (json['borderWidth'] as num).toDouble(),
      borderRadius: (json['borderRadius'] as num).toDouble(),
      fontSize: (json['fontSize'] as num).toDouble(),
      fontWeight: json['fontWeight'],
      icon: json['icon'],
      iconPosition: json['iconPosition'],
      height: (json['height'] as num).toDouble(),
      disabledBackgroundColor: json['disabledBackgroundColor'],
      disabledForegroundColor: json['disabledForegroundColor'],
      disabledBorderColor: json['disabledBorderColor'],
      gradientColors: json['gradientColors'] != null
        ? (json['gradientColors'] as List).map((e) => e.toString()).toList()
        : null,
      gradientDirection: json['gradientDirection'],
      disabledGradientColors: json['disabledGradientColors'] != null
        ? (json['disabledGradientColors'] as List).map((e) => e.toString()).toList()
        : null,
    );
  }

  BaseButtonConfig merge(BaseButtonConfig override) {
    return BaseButtonConfig(
      name: override.name ?? name,
      backgroundColor: override.backgroundColor != '' ? override.backgroundColor : backgroundColor,
      foregroundColor: override.foregroundColor != '' ? override.foregroundColor : foregroundColor,
      borderColor: override.borderColor != '' ? override.borderColor : borderColor,
      borderWidth: override.borderWidth != 0 ? override.borderWidth : borderWidth,
      borderRadius: override.borderRadius != 0 ? override.borderRadius : borderRadius,
      fontSize: override.fontSize != 0 ? override.fontSize : fontSize,
      fontWeight: override.fontWeight != '' ? override.fontWeight : fontWeight,
      icon: override.icon ?? icon,
      iconPosition: override.iconPosition ?? iconPosition,
      height: override.height != 0 ? override.height : height,
      disabledBackgroundColor: override.disabledBackgroundColor ?? disabledBackgroundColor,
      disabledForegroundColor: override.disabledForegroundColor ?? disabledForegroundColor,
      disabledBorderColor: override.disabledBorderColor ?? disabledBorderColor,
      gradientColors: override.gradientColors ?? gradientColors,
      gradientDirection: override.gradientDirection ?? gradientDirection,
      disabledGradientColors: override.disabledGradientColors ?? disabledGradientColors,
    );
  }
}
