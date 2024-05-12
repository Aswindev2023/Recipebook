// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/recipebook_model.dart';

ValueNotifier<List<RecipeDetails>> recipeListNotifier = ValueNotifier([]);

void addRecipe(RecipeDetails value, int recipeId) async {
  print('adding recipe: $value');
  print('addRecipe recipeId passed from addRecipepage:$recipeId');
  final recipesBox = await Hive.openBox<RecipeDetails>('Recipe_db');
  final id = await recipesBox.add(value);
  value.recipeId = recipeId;
  print('addRecipe functions:${value.id}');
  value.id = id;
  print('recipe id:$id');
  print('added value: $value');
  recipeListNotifier.value.add(value);
  recipeListNotifier.notifyListeners();
}

Future<List<RecipeDetails>> getRecipes() async {
  print('getRecipe');
  final recipesBox = await Hive.openBox<RecipeDetails>('Recipe_db');
  final List<RecipeDetails> recipes = recipesBox.values.toList();
  recipeListNotifier.notifyListeners();
  return recipes;
}

void deleteRecipe(int? recipeId) async {
  if (recipeId == null) {
    print('Recipe ID cannot be null');
    return;
  }

  final recipesBox = await Hive.openBox<RecipeDetails>('Recipe_db');
  final recipeIndex = recipesBox.values
      .toList()
      .indexWhere((recipe) => recipe.recipeId == recipeId);

  if (recipeIndex != -1) {
    await recipesBox.deleteAt(recipeIndex);
    print('Deleted recipe with ID: $recipeId');
  } else {
    print('Recipe with ID $recipeId does not exist');
  }

  recipeListNotifier.value = recipesBox.values.toList();
  recipeListNotifier.notifyListeners();
}

void updateRecipe(int recipeId, RecipeDetails updatedRecipe) async {
  final recipesBox = await Hive.openBox<RecipeDetails>('Recipe_db');
  final recipeIndex = recipesBox.values
      .toList()
      .indexWhere((recipe) => recipe.recipeId == recipeId);

  if (recipeIndex != -1) {
    final oldRecipe = recipesBox.getAt(recipeIndex)!;
    updatedRecipe.recipeId =
        oldRecipe.recipeId; // Ensure the ID remains the same
    await recipesBox.putAt(recipeIndex, updatedRecipe);
    print('Updated recipe with ID: $recipeId');

    // Update the ValueNotifier list
    recipeListNotifier.value = recipesBox.values.toList();
    recipeListNotifier.notifyListeners();
  } else {
    print('Recipe with ID $recipeId does not exist');
  }
}
