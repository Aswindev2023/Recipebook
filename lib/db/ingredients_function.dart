// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/Ingredients_model.dart';

ValueNotifier<List<IngredientsModel>> ingredientsListNotifier =
    ValueNotifier([]);
Future<int> addIngredientToRecipe(int recipeId, IngredientsModel value) async {
  print('addIngredietnToRecipe value: $value');
  print('addIngredietnToRecipe recipeId: $recipeId');

  // Check if value.ingredients is null or empty
  if (value.ingredients == null || value.ingredients.isEmpty) {
    print('Error: Ingredients list is null or empty');
    return -1; // Return a default value or handle the null/empty case
  }

  // Print the ingredients list
  print('Ingredients list: ${value.ingredients}');

  final ingredientsBox = await Hive.openBox<IngredientsModel>('Ingredients_db');

  // Create a new list with the contents of value.ingredients and cast it to List<String>
  final List<String> ingredientsList =
      value.ingredients!.map((e) => e.toString()).toList();

  final _id = await ingredientsBox.add(IngredientsModel(
    id: value.id,
    recipeId: value.recipeId,
    ingredients: ingredientsList,
  ));

  // Print debug information
  print('addIngredientsToRecipe $value');
  print('debug code for last part of the addIngredientsToRecipe function:');

  // Update value with the newly added ingredient ID and recipe ID
  value.id = _id;
  value.recipeId = recipeId;

  // Add the ingredient to the list of ingredients and notify listeners
  ingredientsListNotifier.value.add(value);
  ingredientsListNotifier.notifyListeners();

  return _id;
}

Future<List<IngredientsModel>> getIngredientsForRecipe(int recipeId) async {
  final ingredientsBox = await Hive.openBox<IngredientsModel>('Ingredients_db');
  return ingredientsBox.values
      .where((ingredient) => ingredient.recipeId == recipeId)
      .toList();
}

Future<void> deleteIngredientsForRecipe(int recipeId) async {
  final ingredientsBox = await Hive.openBox<IngredientsModel>('Ingredients_db');
  final ingredientsToDelete = ingredientsBox.values
      .where((ingredient) => ingredient.recipeId == recipeId)
      .toList();
  for (var ingredient in ingredientsToDelete) {
    await ingredientsBox.delete(ingredient.id);
  }
  ingredientsListNotifier.value
      .removeWhere((ingredient) => ingredient.recipeId == recipeId);
  ingredientsListNotifier.notifyListeners();
}

Future<void> updateIngredient(IngredientsModel value) async {
  final ingredientsBox = await Hive.openBox<IngredientsModel>('Ingredients_db');
  await ingredientsBox.put(value.id, value);
  getIngredientsForRecipe(value.recipeId);
}
