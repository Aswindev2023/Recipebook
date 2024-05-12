// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/ingredientmodels_class.dart';

ValueNotifier<List<RecipeIngredients>> ingredientListNotifier =
    ValueNotifier([]);

void addIngredient(RecipeIngredients value, int recipeId) async {
  print('adding ingredients:$value');
  final ingredientsBox = await Hive.openBox<RecipeIngredients>('Ingredient_db');
  value.recipeId = recipeId;
  print('ingredient addfunction:${value.recipeId}');
  final id = await ingredientsBox.add(value);
  value.id = id;
  print('added id ingredient: $id');
  print('added ingredients:$value');
  ingredientListNotifier.value = ingredientsBox.values.toList();
  ingredientListNotifier.notifyListeners();
}

Future<List<RecipeIngredients>> getIngredients(int recipeId) async {
  print('getIngredients');
  final ingredientsBox = await Hive.openBox<RecipeIngredients>('Ingredient_db');
  final List<RecipeIngredients> allIngredients = ingredientsBox.values.toList();
  final List<RecipeIngredients> ingredientsByRecipeId = allIngredients
      .where((ingredient) => ingredient.recipeId == recipeId)
      .toList();
  ingredientListNotifier.notifyListeners();
  print(
      'getIngredientsByRecipeId for recipeId $recipeId: $ingredientsByRecipeId');
  return ingredientsByRecipeId;
}

void deleteIngredient(int? recipeId) async {
  if (recipeId == null) {
    print('Recipe ID cannot be null');
    return;
  }

  final ingredientsBox = await Hive.openBox<RecipeIngredients>('Ingredient_db');
  final keysToDelete = ingredientsBox.values
      .where((ingredient) => ingredient.recipeId == recipeId)
      .map((ingredient) => ingredient.id)
      .toList();

  for (var id in keysToDelete) {
    if (ingredientsBox.containsKey(id)) {
      await ingredientsBox.delete(id);
      print('Deleted ingredient with ID: $id');
    } else {
      print('Ingredient with ID $id does not exist');
    }
  }

  ingredientListNotifier.value = ingredientsBox.values.toList();
  ingredientListNotifier.notifyListeners();
}

void updateIngredient(
    int ingredientId, RecipeIngredients updatedIngredient) async {
  final ingredientsBox = await Hive.openBox<RecipeIngredients>('Ingredient_db');
  final ingredientIndex = ingredientsBox.values
      .toList()
      .indexWhere((ingredient) => ingredient.recipeId == ingredientId);

  if (ingredientIndex != -1) {
    final oldIngredient = ingredientsBox.getAt(ingredientIndex)!;
    updatedIngredient.recipeId =
        oldIngredient.recipeId; // Ensure the recipe ID remains the same
    await ingredientsBox.putAt(ingredientIndex, updatedIngredient);
    print('Updated ingredient with ID: $ingredientId');

    // Update the ValueNotifier list
    ingredientListNotifier.value = ingredientsBox.values.toList();
    ingredientListNotifier.notifyListeners();
  } else {
    print('Ingredient with ID $ingredientId does not exist');
  }
}
