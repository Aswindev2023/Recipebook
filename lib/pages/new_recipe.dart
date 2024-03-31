import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';
import 'package:recipe_book/classes/database_helper.dart';
import 'package:recipe_book/classes/recipe_form.dart';
import 'package:recipe_book/db/category_functions.dart';
import 'package:recipe_book/model/Ingredients_model.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/model/steps_model.dart'; // Import the file with getCategory function

class NewRecipe extends StatefulWidget {
  const NewRecipe({Key? key}) : super(key: key);

  @override
  State<NewRecipe> createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {
  final int _selectedIndex = 3;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories(); // Call a function to load categories
  }

  Future<void> _loadCategories() async {
    List<String> categories = await getCategory();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'New Recipe',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: RecipeForm(
              categories: _categories, // Pass categories to RecipeForm
              onSubmit: (
                List<File> selectedImages,
                String name,
                String description,
                String cookTime,
                String? selectedCategory,
                List<List<String>> ingredients,
                List<List<String>> steps,
              ) async {
                // Create a Recipe object
                Recipe recipe = Recipe(
                  name: name,
                  description: description,
                  imagePaths: selectedImages.map((file) => file.path).toList(),
                  isFavorite: false,
                  time: cookTime,
                  category: selectedCategory ?? '',
                );

                // Add the recipe to the database
                int recipeId = await DatabaseManager.addRecipeToDb(recipe);

                // Convert ingredient data to IngredientsModel objects
                List<IngredientsModel> ingredientsList = ingredients
                    .map((ingredientList) => IngredientsModel(
                        ingredients: ingredientList, recipeId: recipeId))
                    .toList();

                // Add ingredients to the database
                for (IngredientsModel ingredient in ingredientsList) {
                  await DatabaseManager.addIngredientToDb(recipeId, ingredient);
                }

                // Convert step data to StepsModel objects
                List<StepsModel> stepsList = steps
                    .map((stepList) =>
                        StepsModel(steps: stepList, recipeId: recipeId))
                    .toList();

                // Add steps to the database
                for (StepsModel step in stepsList) {
                  await DatabaseManager.addStepToDb(recipeId, step);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Recipe Added'),
                  ),
                );
              })),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
