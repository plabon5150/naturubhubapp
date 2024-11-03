import 'dart:convert';

import 'package:naturub/Models/sectionwiseuser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  static const String _sectionListKey = 'sectionList';

  static Future<List<sectionwiseuser>> getListSection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonStringList = prefs.getStringList(_sectionListKey);

    if (jsonStringList == null) {
      return [];
    }

    List<sectionwiseuser> sectionList = jsonStringList
        .map((jsonString) => sectionwiseuser.fromJson(json.decode(jsonString)))
        .toList();

    return sectionList;
  }

  static Future<void> setSectionUserWise(List<sectionwiseuser> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (list.isNotEmpty) {
      List<String> jsonStringList =
          list.map((user) => json.encode(user.toJson())).toList();
      await prefs.setStringList(_sectionListKey, jsonStringList);
    } else {
      await prefs.setStringList(_sectionListKey, []);
    }
  }
}
