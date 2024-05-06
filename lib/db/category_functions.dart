// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/recipe_categorymodel.dart';

ValueNotifier<List<CategoryModel>> categoryListNotifier = ValueNotifier([]);
void addCategory(CategoryModel value) async {
  final categories = await Hive.openBox<CategoryModel>('Category_db');
  final id = await categories.add(value);

  value.id = id;
  categoryListNotifier.value.add(value);
  categoryListNotifier.notifyListeners();
}

Future<List<CategoryModel>> getCategoryList() async {
  print('getcategorylist function is called ');
  final categories = await Hive.openBox<CategoryModel>('Category_db');
  List<CategoryModel> categoryList = [];

  // Loop through all the items in the box and add them to the list
  for (var i = 0; i < categories.length; i++) {
    categoryList.add(categories.getAt(i)!);
    categoryListNotifier.notifyListeners();
  }

  return categoryList;
}
/*
Future<void> updateCategory(CategoryModel value, int id) async {
  final categories = await Hive.openBox<CategoryModel>('Category_db');
  categories.put(value.id, value);
}*/

void deleteCategory(int? id) async {
  if (id == null) {
    print('id is null');
    return;
  }
  final categoryBox = await Hive.openBox<CategoryModel>('Category_db');
  if (categoryBox.containsKey(id)) {
    await categoryBox.delete(id);
    categoryListNotifier.value = categoryBox.values.toList();
    categoryListNotifier.notifyListeners();
    getCategoryList();
    print('Deleted recipe with ID: $id');
  } else {
    print('Recipe with ID $id does not exist');
  }
}
