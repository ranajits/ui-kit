import 'package:flutter/material.dart';
import '../tokens/token_models.dart';

class TokenTypographyExample extends StatelessWidget {
  final String name;
  final TokenTypography typographyToken;
  final Map<String, TokenTypography> allTypographies;
  final Map<String, TokenColor> allColors;
  const TokenTypographyExample({super.key, required this.name, required this.typographyToken, required this.allTypographies, required this.allColors});

  @override
  Widget build(BuildContext context) {
    final style = typographyToken.toTextStyle(allTypographies);
    final labelColor = allColors['Colors/Neutral/Neutral-600']?.toColor(allColors) ?? Colors.grey;
    final textColor = allColors['Colors/Neutral/Neutral-900']?.toColor(allColors) ?? Colors.black;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(fontSize: 12, color: labelColor)),
        Text(
          'The quick brown fox jumps over the lazy dog',
          style: style.copyWith(color: textColor),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
