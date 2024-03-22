// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/steps_model.dart';

ValueNotifier<List<StepsModel>> stepListNotifier = ValueNotifier([]);
void addSteps(StepsModel value) async {
  final steps = await Hive.openBox<StepsModel>('Steps_db');
  final _id = await steps.add(value);
  value.id = _id;
  stepListNotifier.value.add(value);
  stepListNotifier.notifyListeners();
}

Future<void> getSteps() async {
  final steps = await Hive.openBox<StepsModel>('Step_db');
  stepListNotifier.value.clear();
  stepListNotifier.value.addAll(steps.values);
  stepListNotifier.notifyListeners();
}

Future<void> deleteSteps(int id) async {
  final steps = await Hive.openBox<StepsModel>('Step_db');
  steps.delete(id);
  getSteps();
}
