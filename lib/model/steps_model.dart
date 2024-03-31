import 'package:hive_flutter/hive_flutter.dart';
part 'steps_model.g.dart';

@HiveType(typeId: 3)
class StepsModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int recipeId;

  @HiveField(2)
  final List<String> steps;

  StepsModel({required this.recipeId, required this.steps, this.id});
}
