import 'package:flutter/material.dart';
import '../tokens/token_models.dart';

class TokenSpacingExample extends StatelessWidget {
  final String name;
  final TokenSpacing spacingToken;
  final Map<String, TokenSpacing> allSpacings;
  const TokenSpacingExample({super.key, required this.name, required this.spacingToken, required this.allSpacings});

  @override
  Widget build(BuildContext context) {
    final value = spacingToken.toDouble(allSpacings);
    return Row(
      children: [
        Container(width: value, height: 16, color: Colors.blueGrey), // You can also use a token color
        const SizedBox(width: 8),
        Text('$name: $value'),
      ],
    );
  }
}
