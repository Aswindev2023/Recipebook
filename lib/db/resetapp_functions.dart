// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> resetApp(BuildContext context) async {
  await clearHiveDatabases();

  clearSharedPreferences();
  resetProvider(context);

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const MyHomePage()),
  );
}

Future<void> clearHiveDatabases() async {
  await Hive.deleteBoxFromDisk('Category_db');
  await Hive.deleteBoxFromDisk('Ingredient_db');
  await Hive.deleteBoxFromDisk('Recipe_db');
  await Hive.deleteBoxFromDisk('Step_db');
  await Hive.deleteBoxFromDisk('favourite_db');
}

void clearSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

void resetProvider(BuildContext context) {
  Provider.of<ThemeProvider>(context, listen: false).reset();
}
