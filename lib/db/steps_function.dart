// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/steps_model.dart';

ValueNotifier<List<StepsModel>> stepListNotifier = ValueNotifier([]);
Future<int> addStepToRecipe(int recipeId, StepsModel value) async {
  final stepsBox = await Hive.openBox<StepsModel>('Steps_db');
  final _id = await stepsBox.add(value);
  value.id = _id;
  value.recipeId = recipeId;
  stepListNotifier.value.add(value);
  stepListNotifier.notifyListeners();
  return _id;
}

Future<List<StepsModel>> getStepsForRecipe(int recipeId) async {
  final stepsBox = await Hive.openBox<StepsModel>('Steps_db');
  return stepsBox.values.where((step) => step.recipeId == recipeId).toList();
}

Future<void> deleteStepsForRecipe(int recipeId) async {
  final stepsBox = await Hive.openBox<StepsModel>('Steps_db');
  final stepsToDelete =
      stepsBox.values.where((step) => step.recipeId == recipeId).toList();
  for (var step in stepsToDelete) {
    await stepsBox.delete(step.id);
  }
  stepListNotifier.value.removeWhere((step) => step.recipeId == recipeId);
  stepListNotifier.notifyListeners();
}

Future<void> updateStep(StepsModel value) async {
  final stepsBox = await Hive.openBox<StepsModel>('Steps_db');
  await stepsBox.put(value.id, value);
  getStepsForRecipe(value.recipeId);
}
