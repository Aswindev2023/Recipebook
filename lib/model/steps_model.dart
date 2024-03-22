import 'package:hive_flutter/hive_flutter.dart';
part 'steps_model.g.dart';

@HiveType(typeId: 3)
class StepsModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final List<String> steps;

  StepsModel({required this.steps, this.id});
}
