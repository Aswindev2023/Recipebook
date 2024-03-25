// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/recipe_categorymodel.dart';

ValueNotifier<List<CategoryModel>> categoryListNotifier = ValueNotifier([]);
void addCategory(CategoryModel value) async {
  final categories = await Hive.openBox<CategoryModel>('Category_db');
  final _id = await categories.add(value);
  value.id = _id;
  categoryListNotifier.value.add(value);
  categoryListNotifier.notifyListeners();
}

/*Future<void> getCategory() async {
  final categories = await Hive.openBox<CategoryModel>('Category_db');
  categoryListNotifier.value.clear();
  categoryListNotifier.value.addAll(categories.values);
  categoryListNotifier.notifyListeners();
}*/
Future<List<String>> getCategory() async {
  final categories = await Hive.openBox<CategoryModel>('Category_db');
  List<String> categoryNames =
      categories.values.map((category) => category.categoryName).toList();
  return categoryNames;
}

Future<void> deleteCategory(int id) async {
  final categories = await Hive.openBox<CategoryModel>('Category_db');
  categories.delete(id);
  getCategory();
}

Future<void> updateCategory(CategoryModel value, int id) async {
  final categories = await Hive.openBox<CategoryModel>('Category_db');
  categories.put(value.id, value);
  getCategory();
}
