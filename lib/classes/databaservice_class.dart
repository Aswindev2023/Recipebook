import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/db/hive_service.dart';
import 'package:recipe_book/db/ingredients_function.dart';
import 'package:recipe_book/db/steps_function.dart';
import 'package:recipe_book/model/Ingredients_model.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/model/steps_model.dart';

class DatabaseService {
  static Future<void> deleteIngredients(int id) async {
    final ingredients = await Hive.openBox<IngredientsModel>('Ingredients_db');
    ingredients.delete(id);
    getIngredients();
  }

  static Future<void> deleteRecipe(int id) async {
    final recipes = await Hive.openBox<Recipe>('recipeBook_db');
    recipes.delete(id);
    getRecipe();
  }

  static Future<void> deleteSteps(int id) async {
    final steps = await Hive.openBox<StepsModel>('Step_db');
    steps.delete(id);
    getSteps();
  }
}
