// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/Ingredients_model.dart';

ValueNotifier<List<IngredientsModel>> ingredientsListNotifier =
    ValueNotifier([]);
void addIngredients(IngredientsModel value) async {
  final ingredients = await Hive.openBox<IngredientsModel>('Ingredients_db');
  final _id = await ingredients.add(value);
  value.id = _id;
  ingredientsListNotifier.value.add(value);
  ingredientsListNotifier.notifyListeners();
}

Future<void> getIngredients() async {
  final ingredients = await Hive.openBox<IngredientsModel>('Ingredients_db');
  ingredientsListNotifier.value.clear();
  ingredientsListNotifier.value.addAll(ingredients.values);
  ingredientsListNotifier.notifyListeners();
}

Future<void> deleteIngredients(int id) async {
  final ingredients = await Hive.openBox<IngredientsModel>('Ingredients_db');
  ingredients.delete(id);
  getIngredients();
}

Future<void> updateIngredients(IngredientsModel value, int id) async {
  final ingredients = await Hive.openBox<IngredientsModel>('Ingredients_db');
  ingredients.put(value.id, value);
  getIngredients();
}
