import 'package:flutter/material.dart';
class TokenColor {
  final String name;
  final String value;
  final bool isAlias;
  final String? aliasCollection;
  final String? aliasName;

  TokenColor({
    required this.name,
    required this.value,
    required this.isAlias,
    this.aliasCollection,
    this.aliasName,
  });

  factory TokenColor.fromJson(Map<String, dynamic> json) {
    if (json['isAlias'] == true) {
      return TokenColor(
        name: json['name'],
        value: '',
        isAlias: true,
        aliasCollection: json['value']['collection'],
        aliasName: json['value']['name'],
      );
    } else {
      return TokenColor(
        name: json['name'],
        value: json['value'],
        isAlias: false,
      );
    }
  }

  Color toColor(Map<String, TokenColor> primitives) {
    if (isAlias) {
      final aliasKey = aliasName;
      final primitive = primitives[aliasKey];
      if (primitive != null) {
        return primitive.toColor(primitives);
      }
      throw Exception('Alias not found: $aliasKey');
    }
    return _hexToColor(value);
  }

  static Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class TokenSpacing {
  final String name;
  final num value;
  final bool isAlias;
  final String? aliasCollection;
  final String? aliasName;

  TokenSpacing({
    required this.name,
    required this.value,
    required this.isAlias,
    this.aliasCollection,
    this.aliasName,
  });

  factory TokenSpacing.fromJson(Map<String, dynamic> json) {
    if (json['isAlias'] == true) {
      return TokenSpacing(
        name: json['name'],
        value: 0,
        isAlias: true,
        aliasCollection: json['value']['collection'],
        aliasName: json['value']['name'],
      );
    } else {
      return TokenSpacing(
        name: json['name'],
        value: json['value'],
        isAlias: false,
      );
    }
  }

  double toDouble(Map<String, TokenSpacing> primitives) {
    if (isAlias) {
      final aliasKey = aliasName;
      final primitive = primitives[aliasKey];
      if (primitive != null) {
        return primitive.toDouble(primitives);
      }
      throw Exception('Alias not found: $aliasKey');
    }
    return value.toDouble();
  }
}

class TokenTypography {
  final String name;
  final Map<String, dynamic> value;
  final bool isAlias;
  final String? aliasCollection;
  final String? aliasName;

  TokenTypography({
    required this.name,
    required this.value,
    required this.isAlias,
    this.aliasCollection,
    this.aliasName,
  });

  factory TokenTypography.fromJson(Map<String, dynamic> json) {
    if (json['isAlias'] == true) {
      return TokenTypography(
        name: json['name'],
        value: {},
        isAlias: true,
        aliasCollection: json['value']['collection'],
        aliasName: json['value']['name'],
      );
    } else {
      return TokenTypography(
        name: json['name'],
        value: Map<String, dynamic>.from(json['value']),
        isAlias: false,
      );
    }
  }

  TextStyle toTextStyle(Map<String, TokenTypography> primitives) {
    if (isAlias) {
      final aliasKey = aliasName;
      final primitive = primitives[aliasKey];
      if (primitive != null) {
        return primitive.toTextStyle(primitives);
      }
      throw Exception('Alias not found: $aliasKey');
    }
    String? fontWeightStr = value['fontWeight'];
    // Normalize fontWeight string (e.g., 'Semi Bold' -> 'semibold')
    fontWeightStr = fontWeightStr?.replaceAll(RegExp(r'[^A-Za-z]'), '').toLowerCase();
    return TextStyle(
      fontSize: (value['fontSize'] as num?)?.toDouble(),
      fontFamily: value['fontFamily'],
      fontWeight: _parseFontWeight(fontWeightStr),
      letterSpacing: (value['letterSpacing'] as num?)?.toDouble(),
      decoration: _parseTextDecoration(value['textDecoration']),
    );
  }

  FontWeight? _parseFontWeight(String? weight) {
    switch (weight) {
      case 'thin': return FontWeight.w100;
      case 'extralight': return FontWeight.w200;
      case 'light': return FontWeight.w300;
      case 'regular': return FontWeight.w400;
      case 'medium': return FontWeight.w500;
      case 'semibold': return FontWeight.w600;
      case 'bold': return FontWeight.w700;
      case 'extrabold': return FontWeight.w800;
      case 'black': return FontWeight.w900;
      default: return null; // Unknown or unsupported
    }
  }

  TextDecoration? _parseTextDecoration(String? deco) {
    switch (deco?.toUpperCase()) {
      case 'NONE': return TextDecoration.none;
      case 'UNDERLINE': return TextDecoration.underline;
      case 'LINE_THROUGH': return TextDecoration.lineThrough;
      default: return null;
    }
  }
}
