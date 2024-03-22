import 'package:hive_flutter/hive_flutter.dart';
part 'Ingredients_model.g.dart';

@HiveType(typeId: 1)
class IngredientsModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  final List<String> ingredients;
  IngredientsModel({required this.ingredients, this.id});
}
