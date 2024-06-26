// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/classes/form_class.dart';
import 'package:recipe_book/db/ingredients_function.dart';
import 'package:recipe_book/db/recipe_functions.dart';
import 'package:recipe_book/db/step_function.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/model/steps_model.dart';
import 'package:recipe_book/model/ingredientmodels_class.dart';

class RecipeEditPage extends StatefulWidget {
  final RecipeDetails recipeDetails;

  const RecipeEditPage({
    Key? key,
    required this.recipeDetails,
  }) : super(key: key);

  @override
  State<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  late final RecipeFormFields _formFields;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _formFields = RecipeFormFields();
    _formFields.nameController.text = widget.recipeDetails.name;
    _formFields.descriptionController.text = widget.recipeDetails.description;
    _formFields.setCookTime(widget.recipeDetails.cookTime);
    _formFields.setSelectedCategory(widget.recipeDetails.selectedCategory);
    _formFields.setImages(widget.recipeDetails.imageByteList);
    _formFields.setUnit(widget.recipeDetails.selectedUnit ?? 'Minutes');
    _loadStepsAndIngredients();
  }

  Future<void> _loadStepsAndIngredients() async {
    final stepsBox = await Hive.openBox<RecipeSteps>('Step_db');
    final ingredientsBox =
        await Hive.openBox<RecipeIngredients>('Ingredient_db');

    List<String> steps = stepsBox.values
        .where((step) => step.recipeId == widget.recipeDetails.recipeId)
        .map((step) => step.step)
        .expand((step) => step)
        .toList();

    List<String> ingredients = ingredientsBox.values
        .where((ingredient) =>
            ingredient.recipeId == widget.recipeDetails.recipeId)
        .map((ingredient) => ingredient.ingredient)
        .expand((ingredient) => ingredient)
        .toList();

    setState(() {
      _formFields.setSteps(steps);
      _formFields.setIngredients(ingredients);
    });
  }

  void updateSelectedUnit(String unit) {
    setState(() {
      _formFields.setUnit(unit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildImagePickerAndDisplay(_formFields),
              const SizedBox(height: 16.0),
              NameField(
                controller: _formFields.nameController,
                validator: _formFields.validateName,
              ),
              const SizedBox(height: 16.0),
              DescriptionField(
                controller: _formFields.descriptionController,
                validator: _formFields.validateDescription,
              ),
              const SizedBox(height: 16.0),
              CookTimeField(
                onCookTimeChanged: _formFields.setCookTime,
                validator: _formFields.validateCookTime,
                onUnitChanged: _formFields.setUnit,
                initialValue: _formFields.cookTime,
                initialUnit: _formFields.selectedUnit!,
              ),
              const SizedBox(height: 16.0),
              buildCategoryDropdown(_formFields),
              const SizedBox(height: 16.0),
              buildIngredientField(
                _formFields,
              ),
              const SizedBox(height: 16.0),
              buildStepField(
                _formFields,
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    _saveForm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Save',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    int editRecipeId = widget.recipeDetails.recipeId;

    if (_formKey.currentState!.validate()) {
      final updatedRecipe = RecipeDetails(
        recipeId: editRecipeId,
        name: _formFields.nameController.text,
        description: _formFields.descriptionController.text,
        cookTime: _formFields.cookTime,
        selectedCategory: _formFields.selectedCategory!,
        imageByteList: _formFields.imageBytesList,
        selectedUnit: _formFields.selectedUnit!,
      );

      updateRecipe(editRecipeId, updatedRecipe);

      final updatedIngredients = RecipeIngredients(
        ingredient: _formFields.ingredients,
      );
      updateIngredient(editRecipeId, updatedIngredients);

      final updatedSteps = RecipeSteps(
        step: _formFields.steps,
      );
      updateStep(editRecipeId, updatedSteps);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recipe Updated'),
        ),
      );
      Navigator.pop(context, true);
    } else {
      setState(() {});
    }
  }
}
