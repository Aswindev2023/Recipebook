// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/steps_model.dart';

ValueNotifier<List<RecipeSteps>> stepListNotifier = ValueNotifier([]);

void addStep(RecipeSteps value) async {
  print('adding steps:$value');
  final stepsBox = await Hive.openBox<RecipeSteps>('Step_db');
  final id = await stepsBox.add(value);
  value.id = id;

  print('added step id: $id');
  print('added step:$value');
  stepListNotifier.value = stepsBox.values.toList();
  stepListNotifier.notifyListeners();
}

Future<List<RecipeSteps>> getSteps() async {
  print('getSteps');
  final stepsBox = await Hive.openBox<RecipeSteps>('Step_db');
  final List<RecipeSteps> steps = stepsBox.values.toList();
  stepListNotifier.notifyListeners();
  print('getRecipe:$steps');

  return steps;
}

void deleteStep(int? id) async {
  if (id == null) {
    print('stepId cannot be null');
  }
  final stepsBox = await Hive.openBox<RecipeSteps>('Step_db');
  if (stepsBox.containsKey(id)) {
    await stepsBox.delete(id);
    stepListNotifier.value = stepsBox.values.toList();
    stepListNotifier.notifyListeners();
    print('Deleted step  with ID: $id');
  } else {
    print('step with ID $id does not exist');
  }
}
