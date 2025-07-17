import 'dart:convert';
import 'package:flutter/services.dart';
import 'token_models.dart';

class TokenData {
  final Map<String, TokenColor> colors;
  final Map<String, TokenSpacing> spacings;
  final Map<String, TokenTypography> typographies;
  final Map<String, dynamic> effects;

  TokenData({
    required this.colors,
    required this.spacings,
    required this.typographies,
    required this.effects,
  });
}

class TokenLoader {
  static Future<TokenData> load(String assetPath, {String? modeName}) async {
    final jsonStr = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> json = jsonDecode(jsonStr);
    final primitives = json['collections'].firstWhere((c) => c['name'] == 'Primitives');
    final tokens = json['collections'].firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
    final typographyCollection = json['collections'].firstWhere((c) => c['name'] == 'Typography', orElse: () => null);
    final effectsCollection = json['collections'].firstWhere((c) => c['name'] == 'Effects', orElse: () => null);

    Map<String, dynamic> selectMode(Map<String, dynamic> collection, String? modeName) {
      final modes = collection['modes'] as List;
      if (modeName != null) {
        final found = modes.where((m) => m['name'] == modeName).toList();
        if (found.isNotEmpty) return found.first;
      }
      return modes[0];
    }

    final primitivesMode = selectMode(primitives, modeName);
    final tokensMode = tokens != null ? selectMode(tokens, modeName) : null;
    final typographyMode = typographyCollection != null ? selectMode(typographyCollection, modeName) : null;
    final effectsMode = effectsCollection != null ? selectMode(effectsCollection, modeName) : null;

    final List variables = primitivesMode['variables'];
    final colorMap = <String, TokenColor>{};
    final spacingMap = <String, TokenSpacing>{};
    final typographyMap = <String, TokenTypography>{};
    final effectsMap = <String, dynamic>{};
    for (final v in variables) {
      if (v['type'] == 'color') {
        colorMap[v['name']] = TokenColor.fromJson(v);
      } else if (v['type'] == 'number') {
        spacingMap[v['name']] = TokenSpacing.fromJson(v);
      } else if (v['type'] == 'typography') {
        typographyMap[v['name']] = TokenTypography.fromJson(v);
      }
    }
    if (tokensMode != null) {
      for (final v in tokensMode['variables']) {
        if (v['type'] == 'color') {
          colorMap[v['name']] = TokenColor.fromJson(v);
        } else if (v['type'] == 'number') {
          spacingMap[v['name']] = TokenSpacing.fromJson(v);
        } else if (v['type'] == 'typography') {
          typographyMap[v['name']] = TokenTypography.fromJson(v);
        }
      }
    }
    if (typographyMode != null) {
      for (final v in typographyMode['variables']) {
        if (v['type'] == 'typography') {
          typographyMap[v['name']] = TokenTypography.fromJson(v);
        }
      }
    }
    if (effectsMode != null) {
      for (final v in effectsMode['variables']) {
        effectsMap[v['name']] = v;
      }
    }
    return TokenData(colors: colorMap, spacings: spacingMap, typographies: typographyMap, effects: effectsMap);
  }
}
