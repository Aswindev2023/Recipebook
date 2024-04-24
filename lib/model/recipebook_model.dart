import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'recipebook_model.g.dart';

@HiveType(typeId: 0)
class RecipeDetails {
  @HiveField(0)
  int id = 0;

  @HiveField(1)
  int recipeId = 0;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String cookTime;

  @HiveField(5)
  final String selectedCategory;

  @HiveField(6)
  final List<String> imageUrls;

  @HiveField(7)
  final String? selectedUnit;

  RecipeDetails({
    required this.recipeId,
    required this.name,
    required this.description,
    required this.cookTime,
    required this.selectedCategory,
    required this.imageUrls,
    required this.selectedUnit,
  });
}
