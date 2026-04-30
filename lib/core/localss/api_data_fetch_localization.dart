import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ApplicationLocalizations {
  static Map<String, String> _localizedStrings = {};

  /// API मधून data set
  static Future<void> setLocalization(Map<String, dynamic> data) async {
    _localizedStrings =
        data.map((key, value) => MapEntry(key, value.toString()));

    // Save locally
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("lang_data", json.encode(data));
  }

  /// App start ला load
  static Future<void> loadFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("lang_data");

    if (data != null) {
      Map<String, dynamic> jsonData = json.decode(data);
      _localizedStrings =
          jsonData.map((key, value) => MapEntry(key, value.toString()));
    }
  }

  /// translate function
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  /// of(context) method (same usage ठेवण्यासाठी)
  static ApplicationLocalizations of(BuildContext context) {
    return ApplicationLocalizations();
  }
}