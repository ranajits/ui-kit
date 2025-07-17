import 'package:flutter/material.dart';
import 'package:flutter_sample_apps/tokens/token_loader.dart';
import '../tokens/token_models.dart'; // TokenData is defined here

class TokenButton extends StatefulWidget {
  final String variant; // 'Primary', 'Secondary', 'Tertiary'
  final String size; // 'Small', 'Medium', 'Big'
  final String state; // '', 'Hover', 'Disabled'
  final TokenData tokens;
  final VoidCallback? onPressed;
  final String? label;
  const TokenButton({
    super.key,
    required this.variant,
    required this.size,
    required this.state,
    required this.tokens,
    this.onPressed,
    this.label,
  });

  @override
  State<TokenButton> createState() => _TokenButtonState();
}

class _TokenButtonState extends State<TokenButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final variant = widget.variant;
    final size = widget.size;
    final tokens = widget.tokens;
    // State: '' (default), 'Hover', 'Disabled' -- hover can be forced by mouse, or via prop
    final isHover = _hovering || widget.state == 'Hover';
    final isDisabled = widget.state == 'Disabled';
    final state = isDisabled ? 'Disabled' : (isHover ? 'Hover' : 'Default');

    // Outlined variant logic
    final isOutlined = variant.endsWith('Outlined');
    final baseVariant = isOutlined ? variant.replaceAll('Outlined', '') : variant;

    // Color tokens
    final bgKey = isOutlined ? 'Colors/Neutral/Neutral-0' : 'Colors/Button/${baseVariant}${state}';
    final outlineKey = 'Colors/Button/${baseVariant}${state}Outline';
    final textKey = 'Colors/Button/${baseVariant}Text';
    final bgColor = isOutlined ? Colors.transparent : (tokens.colors[bgKey]?.toColor(tokens.colors) ?? Colors.grey);
    final outlineColor = tokens.colors[outlineKey]?.toColor(tokens.colors) ?? Colors.transparent;
    final textColor = isOutlined
        ? (tokens.colors[outlineKey]?.toColor(tokens.colors) ?? Colors.black)
        : (tokens.colors[textKey]?.toColor(tokens.colors) ?? Colors.black);

    // Spacing tokens
    final paddingH = tokens.spacings['Spacing/Button/${size}PaddingWidth']?.toDouble(tokens.spacings) ?? 16;
    final paddingV = tokens.spacings['Spacing/Button/${size}PaddingHeight']?.toDouble(tokens.spacings) ?? 8;
    final radius = tokens.spacings['Spacing/Button/${size}Radius']?.toDouble(tokens.spacings) ?? 4;
    // final iconGap = tokens.spacings['Spacing/Button/${size}IconGap']?.toDouble(tokens.spacings) ?? 8;

    // Typography tokens
    final typographyKey = 'Text/Button${size}';
    final textStyle = tokens.typographies[typographyKey]?.toTextStyle(tokens.typographies) ?? const TextStyle();

    // BoxShadow for hover
    final boxShadow = (isHover && !isDisabled) ? _getEffectBoxShadow(tokens) : <BoxShadow>[];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: MouseRegion(
        onEnter: (_) {
          if (!isDisabled) setState(() => _hovering = true);
        },
        onExit: (_) {
          if (!isDisabled) setState(() => _hovering = false);
        },
        cursor: isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: isDisabled ? null : widget.onPressed,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: outlineColor, width: 2),
              borderRadius: BorderRadius.circular(radius),
              boxShadow: boxShadow,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
              child: Text(
               // widget.label ?? '${variant}${state != 'Default' ? ' ($state)' : ''} - $size',
                widget.label ?? '${variant} - $size',
                style: textStyle.copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BoxShadow> _getEffectBoxShadow(TokenData tokens) {
    // Try to get Button/Hover effect from tokens.effects
    final effectToken = tokens.effects['Button/Hover'];
    final effectList = effectToken != null 
        ? (effectToken['value'] != null && effectToken['value']['effects'] != null
            ? effectToken['value']['effects']
            : effectToken['effects'])
        : null;
    if (effectList != null && effectList is List && effectList.isNotEmpty) {
      return effectList
          .where((e) => e['type'] == 'DROP_SHADOW')
          .map((e) {
            final c = e['color'];
            final color = c != null
                ? Color.fromARGB(
                    ((c['a'] ?? 1.0) * 255).round(),
                    c['r'] ?? 0,
                    c['g'] ?? 0,
                    c['b'] ?? 0)
                : const Color(0x33000000);
            final offset = e['offset'] != null
                ? Offset(
                    (e['offset']['x'] ?? 0).toDouble(),
                    (e['offset']['y'] ?? 0).toDouble())
                : Offset.zero;
            final blur = (e['radius'] ?? 0).toDouble();
            final spread = (e['spread'] ?? 0).toDouble();
            return BoxShadow(
              color: color,
              offset: offset,
              blurRadius: blur,
              spreadRadius: spread,
            );
          })
          .toList();
    }
   /// Fallback to old hardcoded shadow if no effect token found
    return [
      BoxShadow(
        color: const Color(0xFFFFBE84),
        offset: const Offset(4, 4),
        blurRadius: 8,
        spreadRadius: 0,
      )
    ];
  }
}
