import 'package:hive_flutter/hive_flutter.dart';
part 'steps_model.g.dart';

@HiveType(typeId: 1)
class RecipeSteps {
  @HiveField(0)
  int id = 0;

  @HiveField(1)
  List<String> step;

  @HiveField(2)
  int recipeId = 0;

  RecipeSteps({
    required this.step,
  });
}
