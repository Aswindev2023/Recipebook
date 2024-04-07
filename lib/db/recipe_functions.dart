// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/recipebook_model.dart';

ValueNotifier<List<RecipeDetails>> recipeListNotifier = ValueNotifier([]);

void addRecipe(RecipeDetails value) async {
  print('adding recipe: $value');
  final recipesBox = await Hive.openBox<RecipeDetails>('Recipe_db');
  final id = await recipesBox.add(value);
  value.id = id;
  print('recipe id:$id');
  print('added value: $value');
  recipeListNotifier.value.add(value);
  recipeListNotifier.notifyListeners();
}

Future<List<RecipeDetails>> getRecipes() async {
  final recipesBox = await Hive.openBox<RecipeDetails>('Recipe_db');
  final List<RecipeDetails> recipes = recipesBox.values.toList();

  return recipes;
}
