import 'package:recipe_book/db/hive_service.dart';
import 'package:recipe_book/db/ingredients_function.dart';
import 'package:recipe_book/db/steps_function.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/model/Ingredients_model.dart';
import 'package:recipe_book/model/steps_model.dart';

class DatabaseManager {
  static Future<int> addRecipeToDb(Recipe value) async {
    print('Adding recipe to database: $value');
    final recipeId = await addRecipe(value);
    print('Recipe added to database with ID: $recipeId');
    return recipeId;
  }

  static Future<int> addIngredientToDb(
      int recipeId, IngredientsModel value) async {
    print('Adding ingredient to database for recipe ID: $recipeId');
    try {
      final ingredientId = await addIngredientToRecipe(recipeId, value);
      print('value from addIngredientToDb(test):$value');
      print('Ingredient added to database with ID(test): $ingredientId');
      return ingredientId;
    } catch (e) {
      print('Error adding ingredient to database: $e');
      rethrow; // Rethrow the error to propagate it further
    }
  }

  static Future<int> addStepToDb(int recipeId, StepsModel value) async {
    print('Adding step to database for recipe ID: $recipeId');
    final stepId = await addStepToRecipe(recipeId, value);
    print('Step added to database with ID: $stepId');
    return stepId;
  }
}
