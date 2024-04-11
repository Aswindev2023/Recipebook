// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:recipe_book/classes/category_menu.dart';
import 'package:recipe_book/classes/dynamicIngredients.dart';
import 'package:recipe_book/classes/dynamicSteps.dart';
import 'package:recipe_book/classes/image_picker.dart';
import 'package:recipe_book/model/recipeform_model.dart'; // Assuming recipeform_model.dart defines RecipeForm

class RecipeFormFields {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  String cookTime = '';
  String? _selectedUnit = 'Minutes';
  List<String> _imageUrls = [];
  List<String> _steps = [];
  List<String> _ingredients = [];
  String? get selectedCategory => _selectedCategory;
  List<String> get ingredients => _ingredients;
  List<String> get steps => _steps;
  List<String> get imageUrls => _imageUrls;
  String? get selectedUnit => _selectedUnit;

  String? _selectedCategory;

  RecipeFormFields()
      : nameController = TextEditingController(),
        descriptionController = TextEditingController() {
    print('Default unit initialized: $_selectedUnit');
  }

  void setCookTime(String value) {
    cookTime = value;
  }

  void setUnit(String unit) {
    print('Setting unit to: $unit');
    _selectedUnit = unit;
    print('Selected unit updated: $_selectedUnit');
  }

  void setIngredients(List<String> ingredients) {
    _ingredients = ingredients;
  }

  void setSteps(List<String> steps) {
    _steps = steps;
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
  }

  // Create a method to get the complete RecipeForm data
  RecipeForm getRecipeForm() {
    return RecipeForm(
      name: nameController.text,
      description: descriptionController.text,
      cookTime: '$cookTime $_selectedUnit',
      imageUrls: _imageUrls,
      ingredients: _ingredients,
      steps: _steps,
      categories: [_selectedCategory ?? ''],
    );
  }

  // Validators
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a recipe name.';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description.';
    }
    return null;
  }

  String? validateCookTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a cooking time.';
    }
    final RegExp numRegex = RegExp(r'^\d*\.?\d+$');

    if (!numRegex.hasMatch(value)) {
      return 'Cooking time must be a number.';
    }
    return null;
  }
}

Widget buildImagePickerAndDisplay(RecipeFormFields recipeFormFields) {
  return ImagePickerAndDisplay(onImagesSelected: (List<String> urls) {
    print('buildImagePickerAndDisplay:$urls');
    recipeFormFields._imageUrls = urls;
  });
}

Widget buildStepField(RecipeFormFields recipeFormFields) {
  return DynamicStepField(
    initialFields: recipeFormFields._steps,
    fieldName: 'Steps', // You can customize the field name as needed
    onStepsChanged: (List<String> steps) {
      recipeFormFields._steps = steps;
    },
  );
}

Widget buildIngredientField(RecipeFormFields recipeFormFields) {
  return DynamicIngredientField(
    initialIngredients: recipeFormFields._ingredients,
    fieldName: 'Ingredients', // You can customize the field name as needed
    onIngredientsChanged: (List<String> ingredients) {
      recipeFormFields.setIngredients(ingredients); // Update ingredients list
    },
  );
}

Widget buildCategoryDropdown(RecipeFormFields recipeFormFields) {
  return CategoryDropdown(
    selectedCategory: recipeFormFields._selectedCategory,
    onChanged: (value) {
      recipeFormFields.setSelectedCategory(value);
    },
  );
}

class NameField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const NameField(
      {super.key, required this.controller, required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: 'Recipe Name',
        hintText: 'Add Name',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const DescriptionField(
      {super.key, required this.controller, required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'Add Description',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: 2,
    );
  }
}

class CookTimeField extends StatefulWidget {
  final Function(String)
      onCookTimeChanged; // Callback for user-entered cook time
  final String? Function(String?) validator;
  final Function(String) onUnitChanged;
  const CookTimeField({
    super.key,
    required this.onCookTimeChanged,
    required this.validator,
    required this.onUnitChanged,
  });

  @override
  State<CookTimeField> createState() => _CookTimeFieldState();
}

class _CookTimeFieldState extends State<CookTimeField> {
  String cookTime = '';
  String _selectedUnit = 'Minutes'; // Default unit

  void setCookTime(String value) {
    setState(() {
      cookTime = value;
    });
    widget.onCookTimeChanged(cookTime);
  }

  void setUnit(String? unit) {
    if (unit != null) {
      print('Unit received: $unit'); // Add this line for debugging
      setState(() {
        _selectedUnit = unit;
      });
      widget.onUnitChanged(_selectedUnit);
    } else {
      print('Received null unit'); // Add this line for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building CookTimeField widget with selected unit: $_selectedUnit');
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: TextFormField(
            keyboardType: TextInputType.number,
            validator: widget.validator,
            decoration: InputDecoration(
              labelText: 'Cooking Time',
              hintText: 'Add Time',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: setCookTime,
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: _selectedUnit,
          items: const [
            DropdownMenuItem(value: 'Minutes', child: Text('Minutes')),
            DropdownMenuItem(value: 'Hours', child: Text('Hours')),
          ],
          onChanged: setUnit,
        ),
      ],
    );
  }
}
