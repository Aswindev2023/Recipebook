// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/Ingredients_model.dart';

ValueNotifier<List<RecipeIngredients>> ingredientListNotifier =
    ValueNotifier([]);

void addIngredient(RecipeIngredients value) async {
  print('adding ingredients:$value');
  final ingredientsBox = await Hive.openBox<RecipeIngredients>('Ingredient_db');
  final _id = await ingredientsBox.add(value);

  value.id = _id;
  print('added id ingredient: $_id');
  print('added ingredients:$value');
  ingredientListNotifier.value = ingredientsBox.values.toList();
  ingredientListNotifier.notifyListeners();
}

Future<List<RecipeIngredients>> getIngredients() async {
  print('getIngredients');
  final ingredientsBox = await Hive.openBox<RecipeIngredients>('Ingredient_db');
  final List<RecipeIngredients> ingredients = ingredientsBox.values.toList();
  ingredientListNotifier.notifyListeners();

  return ingredients;
}

void deleteIngredient(int? id) async {
  if (id == null) {
    print('Ingredient ID cannot be null');
    return;
  }
  final ingredientsBox = await Hive.openBox<RecipeIngredients>('Ingredient_db');

  if (ingredientsBox.containsKey(id)) {
    await ingredientsBox.delete(id);

    ingredientListNotifier.value = ingredientsBox.values.toList();
    ingredientListNotifier.notifyListeners();

    print('Deleted ingredient with ID: $id');
  } else {
    print('Ingredient with ID $id does not exist');
  }
}
