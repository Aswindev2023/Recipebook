// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/steps_model.dart';

ValueNotifier<List<RecipeSteps>> stepListNotifier = ValueNotifier([]);

void addStep(RecipeSteps value, int recipeId) async {
  final stepsBox = await Hive.openBox<RecipeSteps>('Step_db');
  value.recipeId = recipeId;

  final id = await stepsBox.add(value);
  value.id = id;

  stepListNotifier.value = stepsBox.values.toList();
  stepListNotifier.notifyListeners();
}

Future<List<RecipeSteps>> getSteps(int recipeId) async {
  final stepsBox = await Hive.openBox<RecipeSteps>('Step_db');
  final List<RecipeSteps> allSteps = stepsBox.values.toList();
  final List<RecipeSteps> stepsByRecipeId =
      allSteps.where((step) => step.recipeId == recipeId).toList();
  stepListNotifier.notifyListeners();

  return stepsByRecipeId;
}

void deleteStep(int? recipeId) async {
  final stepsBox = await Hive.openBox<RecipeSteps>('Step_db');
  final keysToDelete = stepsBox.values
      .where((step) => step.recipeId == recipeId)
      .map((step) => step.id)
      .toList();

  for (var id in keysToDelete) {
    if (stepsBox.containsKey(id)) {
      await stepsBox.delete(id);
    }
  }

  stepListNotifier.value = stepsBox.values.toList();
  stepListNotifier.notifyListeners();
}

void updateStep(int stepId, RecipeSteps updatedStep) async {
  final stepsBox = await Hive.openBox<RecipeSteps>('Step_db');
  final stepIndex =
      stepsBox.values.toList().indexWhere((step) => step.recipeId == stepId);

  if (stepIndex != -1) {
    final oldStep = stepsBox.getAt(stepIndex)!;
    updatedStep.recipeId = oldStep.recipeId;
    await stepsBox.putAt(stepIndex, updatedStep);

    stepListNotifier.value = stepsBox.values.toList();
    stepListNotifier.notifyListeners();
  }
}
