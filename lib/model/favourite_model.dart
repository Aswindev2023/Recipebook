import 'package:hive_flutter/hive_flutter.dart';
part 'favourite_model.g.dart';

@HiveType(typeId: 4)
class Favourites extends HiveObject {
  @HiveField(0)
  int recipeId;
  Favourites({
    required this.recipeId,
  });
}
