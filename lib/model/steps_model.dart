import 'package:hive_flutter/hive_flutter.dart';
part 'steps_model.g.dart';

@HiveType(typeId: 1)
class RecipeSteps {
  @HiveField(0)
  int id;

  @HiveField(1)
  List<String> step;

  RecipeSteps({
    required this.id,
    required this.step,
  });
}
