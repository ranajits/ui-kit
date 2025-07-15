import 'dart:convert';
import 'package:flutter/services.dart';
import '../base/base_button_config.dart';

Future<BaseButtonConfig> loadBaseButtonConfig() async {
  final jsonStr = await rootBundle.loadString('assets/button_base.json');
  final Map<String, dynamic> jsonMap = json.decode(jsonStr);
  return BaseButtonConfig.fromJson(jsonMap);
}

Future<List<BaseButtonConfig>> loadButtonVariants() async {
  final jsonStr = await rootBundle.loadString('assets/button_variants.json');
  final List<dynamic> jsonList = json.decode(jsonStr);
  return jsonList.map((e) => BaseButtonConfig.fromJson(e)).toList();
}

List<BaseButtonConfig> mergeBaseWithVariants(BaseButtonConfig base, List<BaseButtonConfig> variants) {
  return variants.map((variant) => base.merge(variant)).toList();
}
