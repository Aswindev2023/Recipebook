import 'package:flutter/material.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';
import 'package:recipe_book/classes/form_class.dart';
import 'package:recipe_book/db/ingredients_function.dart';
import 'package:recipe_book/db/recipe_functions.dart';
import 'package:recipe_book/db/step_function.dart';
import 'package:recipe_book/model/ingredientmodels_class.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/model/steps_model.dart';
import 'package:recipe_book/pages/home_page.dart';

class MyRecipeFormPage extends StatefulWidget {
  const MyRecipeFormPage({Key? key}) : super(key: key);

  @override
  State<MyRecipeFormPage> createState() => _MyRecipeFormPageState();
}

class _MyRecipeFormPageState extends State<MyRecipeFormPage> {
  final int _selectedIndex = 3;
  final _formKey = GlobalKey<FormState>();
  late final RecipeFormFields recipeFormFields;

  @override
  void initState() {
    super.initState();
    recipeFormFields = RecipeFormFields();
  }

  void updateSelectedUnit(String unit) {
    setState(() {
      recipeFormFields.setUnit(unit);
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkTheme = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(
          Icons.arrow_back,
          color: isDarkTheme
              ? const Color.fromARGB(117, 32, 31, 31)
              : Colors.white,
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
                  onUnitChanged: updateSelectedUnit,
                  initialValue: recipeFormFields.cookTime,
                  initialUnit: recipeFormFields.selectedUnit!,
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
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _saveForm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Save',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                      const SizedBox(width: 140),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyRecipeFormPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Clear',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ],
                  ),
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

  int generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  void _saveForm() {
    final int uniqueId = generateUniqueId();
    if (_formKey.currentState!.validate()) {
      final recipe = RecipeDetails(
        recipeId: uniqueId,
        name: recipeFormFields.nameController.text,
        description: recipeFormFields.descriptionController.text,
        cookTime: recipeFormFields.cookTime,
        selectedCategory: recipeFormFields.selectedCategory!,
        imageByteList: recipeFormFields.imageBytesList,
        selectedUnit: recipeFormFields.selectedUnit!,
      );

      addRecipe(recipe, uniqueId);
      final ingredients = RecipeIngredients(
        ingredient: recipeFormFields.ingredients,
      );

      addIngredient(ingredients, uniqueId);
      final steps = RecipeSteps(
        step: recipeFormFields.steps,
      );

      addStep(steps, uniqueId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recipe Added'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    } else {
      setState(() {});
    }
  }
}
