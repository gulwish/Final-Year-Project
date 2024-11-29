import 'package:flutter/material.dart';
import 'package:kaamsay/models/task_category.dart';

class TaskCategoriesProvider with ChangeNotifier {
  final List<TaskCategory> _categories = [];
  List<TaskCategory> get categories => _categories;

  int _selectedCategoryIndex = 0;
  int get selectedCategoryIndex => _selectedCategoryIndex;

  void setSelectedCategoryIndex(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  void addToTaskCategories(TaskCategory category) {
    _categories.add(category);
    notifyListeners();
  }

  void addAllToTaskCategories(List<TaskCategory> all) {
    _categories.addAll(all);
    notifyListeners();
  }

  void clearTaskCategories() {
    _categories.clear();
    notifyListeners();
  }
}
