// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/recipebook_model.dart';

ValueNotifier<List<Recipe>> recipeListNotifier = ValueNotifier([]);
void addRecipe(Recipe value) async {
  final recipes = await Hive.openBox<Recipe>('recipeBook_db');
  final _id = await recipes.add(value);
  value.id = _id;
  recipeListNotifier.value.add(value);
  recipeListNotifier.notifyListeners();
}

Future<void> getRecipe() async {
  final recipes = await Hive.openBox<Recipe>('recipeBook_db');
  recipeListNotifier.value.clear();
  recipeListNotifier.value.addAll(recipes.values);
  recipeListNotifier.notifyListeners();
}

Future<void> deleteRecipe(int id) async {
  final recipes = await Hive.openBox<Recipe>('recipeBook_db');
  recipes.delete(id);
  getRecipe();
}
