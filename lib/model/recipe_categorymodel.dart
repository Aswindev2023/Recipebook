import 'package:hive_flutter/hive_flutter.dart';
part 'recipe_categorymodel.g.dart';

@HiveType(typeId: 2)
class CategoryModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final List<String> category;

  CategoryModel({required this.category, this.id});
}
