import 'package:hive_flutter/hive_flutter.dart';
part 'recipe_categorymodel.g.dart';

@HiveType(typeId: 2)
class CategoryModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  final String categoryName;

  @HiveField(2)
  final String image;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.image,
  });
}
