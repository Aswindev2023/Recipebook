import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/db/recipe_functions.dart';

import 'package:recipe_book/model/favourite_model.dart';
import 'package:recipe_book/model/recipebook_model.dart';

ValueNotifier<List<Favourites>> favouriteListNotifier = ValueNotifier([]);

Future<void> addToFavourites(int recipeId) async {
  final Box<Favourites> favouritesBox =
      await Hive.openBox<Favourites>('favourite_db');
  final existingIndex =
      favouritesBox.values.where((fav) => fav.recipeId == recipeId);

  if (existingIndex.isEmpty) {
    final newFavourite = Favourites(recipeId: recipeId);
    await favouritesBox.add(newFavourite);

    favouriteListNotifier.value = favouritesBox.values.toList();
  }
}

Future<List<RecipeDetails>> getFavouriteRecipes() async {
  final Box<Favourites> favouritesBox =
      await Hive.openBox<Favourites>('favourite_db');
  final favouriteRecipeIds =
      favouritesBox.values.map((fav) => fav.recipeId).toList();
  final allRecipes = await getRecipes();

  final filteredRecipes = allRecipes
      .where((recipe) => favouriteRecipeIds.contains(recipe.recipeId))
      .toList();

  return filteredRecipes;
}

Future<void> removeFromFavorites(int recipeId) async {
  final Box<Favourites> favouritesBox =
      await Hive.openBox<Favourites>('favourite_db');
  int existingIndex = -1;

  for (int i = 0; i < favouritesBox.length; i++) {
    if (favouritesBox.getAt(i)!.recipeId == recipeId) {
      existingIndex = i;
      break;
    }
  }

  if (existingIndex != -1) {
    await favouritesBox.deleteAt(existingIndex);

    getFavouriteRecipes();
    favouriteListNotifier.value = favouritesBox.values.toList();
  }
}
