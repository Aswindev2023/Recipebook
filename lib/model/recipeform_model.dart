import 'package:flutter/foundation.dart';

class RecipeForm {
  final String name;
  final String description;
  final String cookTime;
  final List<Uint8List> image;
  final List<String> steps;
  final List<String> ingredients;
  final List<String> categories;

  const RecipeForm({
    required this.name,
    required this.description,
    required this.cookTime,
    required this.image,
    required this.ingredients,
    required this.steps,
    required this.categories,
  });
}
