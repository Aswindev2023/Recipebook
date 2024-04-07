import 'package:flutter/material.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';
import 'package:recipe_book/classes/form_class.dart';
import 'package:recipe_book/db/ingredients_function.dart';
import 'package:recipe_book/db/recipe_functions.dart';
import 'package:recipe_book/db/step_function.dart';
import 'package:recipe_book/model/Ingredients_model.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/model/steps_model.dart';

class MyFormPage extends StatefulWidget {
  const MyFormPage({Key? key}) : super(key: key);

  @override
  State<MyFormPage> createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final int _selectedIndex = 3;
  final _formKey = GlobalKey<FormState>();
  late final RecipeFormFields recipeFormFields;

  @override
  void initState() {
    super.initState();
    recipeFormFields = RecipeFormFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        title: const Text(
          'New Recipe',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildImagePickerAndDisplay(recipeFormFields),
                const SizedBox(height: 20),
                NameField(
                  controller: recipeFormFields.nameController,
                  validator: recipeFormFields.validateName,
                ),
                const SizedBox(height: 20),
                DescriptionField(
                  controller: recipeFormFields.descriptionController,
                  validator: recipeFormFields.validateDescription,
                ),
                const SizedBox(height: 20),
                CookTimeField(
                  onCookTimeChanged: recipeFormFields.setCookTime,
                  validator: recipeFormFields.validateCookTime,
                ),
                const SizedBox(height: 20),
                buildCategoryDropdown(recipeFormFields),
                const SizedBox(
                  height: 20,
                ),
                buildIngredientField(recipeFormFields),
                const SizedBox(
                  height: 8,
                ),
                buildStepField(recipeFormFields),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _saveForm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Save',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Clear all form fields
                        _formKey.currentState?.reset();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Clear',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      print('Form is valid');
      // Save the form data or perform other actions
      final recipe = RecipeDetails(
        name: recipeFormFields.nameController.text,
        description: recipeFormFields.descriptionController.text,
        cookTime: recipeFormFields.cookTime,
        id: 0,
        selectedCategory: recipeFormFields.selectedCategory!,
        imageUrls: recipeFormFields.imageUrls,
        selectedUnit: recipeFormFields.selectedUnit!,
      );
      addRecipe(recipe);
      final ingredients = RecipeIngredients(
        id: 0,
        ingredient: recipeFormFields.ingredients,
      );
      addIngredient(ingredients);
      final steps = RecipeSteps(
        id: 0,
        step: recipeFormFields.steps,
      );
      addStep(steps);
      _formKey.currentState?.reset();
    } else {
      // Validation failed, display error messages
      setState(() {});
    }
  }
}
