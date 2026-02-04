import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/round.dart';

class HistoricStorage {
  static const String _key = 'historic_rounds';
  static Future<void> saveHistoric(List<Round> historic) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = historic.map((round) => jsonEncode(round.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<List<Round>> loadHistoric() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key);
    if (jsonList == null) return [];
    return jsonList.map((json) => Round.fromJson(jsonDecode(json))).toList();
  }

  static Future<void> clearHistoric() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}