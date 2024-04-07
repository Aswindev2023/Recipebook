import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'recipebook_model.g.dart';

@HiveType(typeId: 0)
class RecipeDetails {
  @HiveField(0)
  int id; // Add ID field

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String cookTime;

  @HiveField(4)
  final String selectedCategory;

  @HiveField(5)
  final List<String> imageUrls;

  @HiveField(6)
  final String selectedUnit;

  RecipeDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.cookTime,
    required this.selectedCategory,
    required this.imageUrls,
    required this.selectedUnit,
  });
}
