import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'recipebook_model.g.dart';

@HiveType(typeId: 4)
class Recipe {
  @HiveField(0)
  int? id;
  @HiveField(1)
  List<String> imagePaths;

  @HiveField(2)
  String name;

  @HiveField(3)
  String description;

  @HiveField(4)
  bool isFavorite;

  @HiveField(5)
  String time;

  @HiveField(6)
  final String? category;

  Recipe({
    required this.name,
    required this.description,
    required this.imagePaths,
    this.isFavorite = false,
    required this.time,
    this.category,
    this.id,
  });
}
