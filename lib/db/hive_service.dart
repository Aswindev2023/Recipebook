// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/recipebook_model.dart';

ValueNotifier<List<Recipe>> recipeListNotifier = ValueNotifier([]);
Future<int> addRecipe(Recipe value) async {
  final recipes = await Hive.openBox<Recipe>('recipeBook_db');
  final _id = await recipes.add(value);
  value.id = _id;
  recipeListNotifier.value.add(value);
  recipeListNotifier.notifyListeners();
  return _id;
}

Future<void> getRecipe() async {
  final recipes = await Hive.openBox<Recipe>('recipeBook_db');
  recipeListNotifier.value = recipes.values.toList();
  recipeListNotifier.notifyListeners();
}

Future<void> deleteRecipe(int id) async {
  final recipes = await Hive.openBox<Recipe>('recipeBook_db');
  recipes.delete(id);
  getRecipe();
}

Future<void> updateRecipe(Recipe value, int id) async {
  final recipes = await Hive.openBox<Recipe>('recipeBook_db');
  await recipes.put(value.id, value);
  getRecipe();
}

//Favorite Functions:

Future<void> saveFavoriteRecipes(List<Recipe> favoriteRecipes) async {
  final Box<Recipe> favoriteRecipesBox =
      await Hive.openBox<Recipe>('favorite_recipes');

  // Add a print statement to indicate that the box is opened
  print('Opened favorite_recipes box');

  await favoriteRecipesBox.clear();
  await favoriteRecipesBox.addAll(favoriteRecipes);

  // Add a print statement to indicate that recipes are saved
  print('Saved ${favoriteRecipes.length} favorite recipes');
}

Future<List<Recipe>> getFavoriteRecipes() async {
  final Box<Recipe> favoriteRecipesBox =
      await Hive.openBox<Recipe>('favorite_recipes');

  // Add a print statement to indicate that the box is opened
  print('Opened favorite_recipes box');

  final List<Recipe> favoriteRecipes = favoriteRecipesBox.values.toList();

  // Add a print statement to display the retrieved recipes
  print('Retrieved ${favoriteRecipes.length} favorite recipes');

  return favoriteRecipes;
}
