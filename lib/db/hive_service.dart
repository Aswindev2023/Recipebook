import 'package:hive/hive.dart';
import 'package:recipe_book/model/recipebook_model.dart';

class HiveService {
  static const String _boxName = 'recipebox';

  Future<void> addRecipe(Recipe recipe) async {
    try {
      final box = Hive.box('recipebook');
      await box.add(recipe);
      print('Recipe added to database: $recipe');
    } catch (e) {
      print('Error adding recipe to database: $e');
    }
  }

  Future<List<Recipe>> getRecipes() async {
    try {
      final box = Hive.box('recipebook');
      final List<Recipe> recipes = box.values.cast<Recipe>().toList();
      print('Recipes retrieved from database: $recipes');
      return recipes;
    } catch (e) {
      print('Error retrieving recipes from database: $e');
      return [];
    }
  }
}
