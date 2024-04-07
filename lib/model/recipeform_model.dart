class RecipeForm {
  final String name;
  final String description;
  final String cookTime;
  final List<String> imageUrls;
  final List<String> steps;
  final List<String> ingredients;
  final List<String> categories;

  const RecipeForm({
    required this.name,
    required this.description,
    required this.cookTime,
    required this.imageUrls,
    required this.ingredients,
    required this.steps,
    required this.categories,
  });
}
