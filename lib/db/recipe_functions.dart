// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/recipebook_model.dart';

ValueNotifier<List<RecipeDetails>> recipeListNotifier = ValueNotifier([]);

void addRecipe(RecipeDetails value, int recipeId) async {
  final recipesBox = await Hive.openBox<RecipeDetails>('Recipe_db');
  final id = await recipesBox.add(value);
  value.recipeId = recipeId;

  value.id = id;

  recipeListNotifier.value.add(value);
  recipeListNotifier.notifyListeners();
}

Future<List<RecipeDetails>> getRecipes() async {
  final recipesBox = await Hive.openBox<RecipeDetails>('Recipe_db');
  final List<RecipeDetails> recipes = recipesBox.values.toList();
  recipeListNotifier.notifyListeners();
  return recipes;
}

void deleteRecipe(int? recipeId) async {
  final recipesBox = await Hive.openBox<RecipeDetails>('Recipe_db');
  final recipeIndex = recipesBox.values
      .toList()
      .indexWhere((recipe) => recipe.recipeId == recipeId);

  if (recipeIndex != -1) {
    await recipesBox.deleteAt(recipeIndex);
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
    updatedRecipe.recipeId = oldRecipe.recipeId;
    await recipesBox.putAt(recipeIndex, updatedRecipe);
    recipeListNotifier.value = recipesBox.values.toList();
    recipeListNotifier.notifyListeners();
  }
}
