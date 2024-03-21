import 'dart:io';

import 'package:hive/hive.dart';
import 'package:hive_generator/hive_generator.dart';
//part 'model/recipe.g.dart';

enum RecipeCategory {
  breakfast,
  lunch,
  dinner,
  desserts,
  beverages,
  custom,
}

@HiveAdapt<Recipe>() // Added @HiveAdapt annotation here
@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  late List<String> imagePaths;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late RecipeCategory category;

  @HiveField(4)
  late List<String> ingredients;

  @HiveField(5)
  late List<String> steps;

  @HiveField(6)
  bool isFavorite;

  @HiveField(7)
  late dynamic time;

  Recipe({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.imagePaths,
    required this.category,
    this.isFavorite = false,
    required this.time,
    required List<File> images,
  });
}
