import 'package:flutter/material.dart';
import 'package:recipe_book/classes/form_class.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/model/Ingredients_model.dart';
import 'package:recipe_book/model/steps_model.dart';

class EditFormPage extends StatefulWidget {
  final RecipeDetails recipe;
  final List<RecipeIngredients> ingredients;
  final List<RecipeSteps> steps;

  const EditFormPage({
    Key? key,
    required this.recipe,
    required this.ingredients,
    required this.steps,
  }) : super(key: key);

  @override
  State<EditFormPage> createState() => _EditFormPageState();
}

class _EditFormPageState extends State<EditFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final RecipeFormFields recipeFormFields;

  @override
  void initState() {
    super.initState();
    recipeFormFields = RecipeFormFields();
    // Set initial values for recipe details
    recipeFormFields.nameController.text = widget.recipe.name;
    recipeFormFields.descriptionController.text = widget.recipe.description;
    recipeFormFields.setCookTime(widget.recipe.cookTime);
    recipeFormFields.setSelectedCategory(widget.recipe.selectedCategory);
    recipeFormFields.setImages(List.from(widget.recipe.imageByteList));
    recipeFormFields.setUnit(widget.recipe.selectedUnit ?? 'Minutes');
    // Set initial values for ingredients and steps
    recipeFormFields.setIngredients(List.from(widget.ingredients));
    recipeFormFields.setSteps(List.from(widget.steps));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Recipe',
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
                // Widgets for editing recipe details
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
                  onUnitChanged: recipeFormFields.setUnit,
                ),
                const SizedBox(height: 20),
                // Widgets for editing ingredients and steps
                buildIngredientField(recipeFormFields),
                const SizedBox(height: 20),
                buildStepField(recipeFormFields),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 160),
                      ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
