// ignore_for_file: file_names

import 'package:hive_flutter/hive_flutter.dart';
part 'ingredientmodels_class.g.dart';

@HiveType(typeId: 3)
class RecipeIngredients extends HiveObject {
  @HiveField(0)
  int id = 0;

  @HiveField(1)
  List<String> ingredient;

  @HiveField(2)
  int recipeId = 0;

  RecipeIngredients({
    required this.ingredient,
  });
}
