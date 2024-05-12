import 'package:flutter/material.dart';
import 'package:recipe_book/pages/addrecipe_page.dart';
import 'package:recipe_book/pages/category_page.dart';
import 'package:recipe_book/pages/favourite_page.dart';

import 'package:recipe_book/pages/home_page.dart';

class NavigationService {
  static void navigateToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
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
      MaterialPageRoute(builder: (context) => const FavouritePage()),
    );
  }

  static void navigateToNewRecipePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyRecipeFormPage()),
    );
  }
}
