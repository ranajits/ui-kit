import 'package:flutter/material.dart';
import '../tokens/token_models.dart';

class TokenColorExample extends StatelessWidget {
  final String name;
  final TokenColor colorToken;
  final Map<String, TokenColor> allColors;
  const TokenColorExample({super.key, required this.name, required this.colorToken, required this.allColors});

  @override
  Widget build(BuildContext context) {
    final color = colorToken.toColor(allColors);
    return Row(
      children: [
        Container(width: 32, height: 32, color: color),
        const SizedBox(width: 8),
        Text(name),
      ],
    );
  }
}
