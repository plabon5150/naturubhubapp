import 'package:flutter/material.dart';
import 'package:naturub/Models/sectionwiseuser.dart';

class AppState extends ChangeNotifier {
  List<sectionwiseuser> _list = [];
  String UserName = "";
  List<sectionwiseuser> get list => _list;
  String get Name => UserName;

  void updateSectionData(List<sectionwiseuser> newData) {
    _list = newData;
    notifyListeners();
  }

  void updateUserName(String name) {
    UserName = name;
    notifyListeners();
  }
}
