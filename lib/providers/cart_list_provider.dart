import 'package:flutter/material.dart';

import '../models/hire_list_item.dart';

class CurrentTaskListProvider with ChangeNotifier {
  final List<HireListItem> _hireList = [];
  List<HireListItem> get getHireList => _hireList;

  void addToHireList(HireListItem hireListItem) {
    _hireList.add(hireListItem);
    notifyListeners();
  }

  void removeFromCart(HireListItem hireListItem) {
    _hireList.removeWhere(
        (element) => element.taskAd!.taskId == hireListItem.taskAd!.taskId);
    notifyListeners();
  }

  void clearHireList() {
    _hireList.clear();
    notifyListeners();
  }
}
