// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/recipe_categorymodel.dart';

ValueNotifier<List<CategoryModel>> categoryListNotifier = ValueNotifier([]);
Future<void> addCategory(CategoryModel value) async {
  final categories = await Hive.openBox<CategoryModel>('Category_db');

  // Manually manage unique IDs
  final int id = categories.length > 0
      ? categories.values.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1
      : 1;

  value.id = id;

  await categories.put(id, value);

  categoryListNotifier.value.add(value);
  categoryListNotifier.notifyListeners();
}

Future<List<CategoryModel>> getCategoryList() async {
  final categories = await Hive.openBox<CategoryModel>('Category_db');
  List<CategoryModel> categoryList = [];

  for (var i = 0; i < categories.length; i++) {
    categoryList.add(categories.getAt(i)!);
    categoryListNotifier.notifyListeners();
  }

  return categoryList;
}

Future<void> deleteCategory(int id) async {
  final categoryBox = await Hive.openBox<CategoryModel>('Category_db');
  if (categoryBox.containsKey(id)) {
    await categoryBox.delete(id);
    categoryListNotifier.value = categoryBox.values.toList();
    categoryListNotifier.notifyListeners();
  }
}
