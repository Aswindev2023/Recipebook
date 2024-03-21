import 'package:flutter/material.dart';
import 'package:recipe_book/pages/category_page.dart';
import 'package:recipe_book/pages/favourites_page.dart';
import 'package:recipe_book/pages/home_page.dart';
import 'package:recipe_book/pages/new_recipe.dart';

class NavigationService {
  static void navigateToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homepage(recipes: [])),
    );
  }

  static void navigateToCategoryPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Category()),
    );
  }

  static void navigateToFavoritesPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const Favorites(
                recipes: [],
              )),
    );
  }

  static void navigateToNewRecipePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewRecipe()),
    );
  }
}
