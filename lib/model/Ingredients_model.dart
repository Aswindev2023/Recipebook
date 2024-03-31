import 'package:hive_flutter/hive_flutter.dart';
part 'Ingredients_model.g.dart';

@HiveType(typeId: 1)
class IngredientsModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int recipeId;

  @HiveField(2)
  final List<String> ingredients;
  IngredientsModel(
      {required List<String> ingredients, required this.recipeId, this.id})
      : ingredients = ingredients.isEmpty ? [] : List.from(ingredients);
}
