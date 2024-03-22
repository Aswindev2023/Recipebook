import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';
import 'package:recipe_book/db/hive_service.dart';
import 'package:recipe_book/db/ingredients_function.dart';
import 'package:recipe_book/db/steps_function.dart';

import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/model/Ingredients_model.dart';
import 'package:recipe_book/model/steps_model.dart';
import 'package:image_picker/image_picker.dart';

class NewRecipe extends StatefulWidget {
  const NewRecipe({Key? key}) : super(key: key);

  @override
  State<NewRecipe> createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {
  final List<TextEditingController> _stepControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> _ingredientsController = [
    TextEditingController()
  ];

  final TextEditingController _descriptionareaController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _ingredientsControllers = TextEditingController();
  final int _selectedIndex = 3;
  final TextEditingController _cookTime = TextEditingController();

  List<File> _selectedImages = [];

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(imageQuality: 50);
    // ignore: unnecessary_null_comparison
    if (pickedImages != null) {
      setState(() {
        _selectedImages =
            pickedImages.map((image) => File(image.path)).toList();
      });
    }
  }

  @override
  void dispose() {
    _descriptionareaController.dispose();
    _nameController.dispose();
    _ingredientsControllers.dispose();
    _cookTime.dispose();
    for (var controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _clearPage() {
    setState(() {
      _descriptionareaController.clear();
      _nameController.clear();
      _cookTime.clear();
      _selectedImages.clear();

      _ingredientsController.clear();
      _ingredientsController.add(TextEditingController());
      _stepControllers.clear();
      _stepControllers.add(TextEditingController());
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _getImage,
              child: Container(
                height: 200,
                color: Colors.grey[300],
                child: _selectedImages.isEmpty
                    ? Center(
                        child: IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          onPressed: _getImage,
                        ),
                      )
                    : PageView.builder(
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(_selectedImages[index]),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionareaController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 2,
              decoration: const InputDecoration(
                hintText: "Enter Description",
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cookTime,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: ' Cooking Time',
                hintText: 'e.g. 30 minutes',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            /* DropdownButtonFormField<RecipeCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: RecipeCategory.values.map((category) {
                return DropdownMenuItem<RecipeCategory>(
                  value: category,
                  child: Text(category.toString().split('.').last),
                );
              }).toList(),
              onChanged: (RecipeCategory? value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),*/
            //const SizedBox(height: 16),
            /*TextField(
              controller: _ingredientsController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Ingredients',
                border: OutlineInputBorder(),
              ),
            ),*/
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < _ingredientsController.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Stack(
                      children: [
                        TextField(
                          controller: _ingredientsController[i],
                          decoration: InputDecoration(
                            labelText: 'Ingredients ${i + 1}',
                            border: const OutlineInputBorder(),
                          ),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        if (_ingredientsController.length > 1 &&
                            i != _ingredientsController.length - 1)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  _ingredientsController.removeAt(i);
                                });
                              },
                            ),
                          ),
                        if (i == _ingredientsController.length - 1)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _ingredientsController
                                      .add(TextEditingController());
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < _stepControllers.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Stack(
                      children: [
                        TextField(
                          controller: _stepControllers[i],
                          decoration: InputDecoration(
                            labelText: 'Step ${i + 1}',
                            border: const OutlineInputBorder(),
                          ),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        if (_stepControllers.length > 1 &&
                            i != _stepControllers.length - 1)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  _stepControllers.removeAt(i);
                                });
                              },
                            ),
                          ),
                        if (i == _stepControllers.length - 1)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _stepControllers.add(TextEditingController());
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 243, 22, 6)),
                  ),
                  onPressed: () {
                    _clearPage();
                  },
                  child: const Text(
                    'Clear',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 81, 243, 6)),
                  ),
                  onPressed: () {
                    saveRecipe();
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
      ),
    );
  }

  void saveRecipe() {
//debug code
    print('Name: ${_nameController.text.isNotEmpty}');
    print('Images: ${_selectedImages.isNotEmpty}');
    print('Description: ${_descriptionareaController.text.isNotEmpty}');
    print('Ingredients: ${_ingredientsController.isNotEmpty}');
    print('Steps: ${_stepControllers.isNotEmpty}');
    print('Cook Time: ${_cookTime.text.isNotEmpty}');

    if (_nameController.text.isNotEmpty &&
        _selectedImages.isNotEmpty &&
        _descriptionareaController.text.isNotEmpty &&
        _ingredientsController.isNotEmpty &&
        _stepControllers.isNotEmpty &&
        _cookTime.text.isNotEmpty) {
      List<String> ingredients = [];
      for (var controller in _ingredientsController) {
        if (controller.text.isNotEmpty) {
          ingredients.add(controller.text);
        }
      }

      List<String> steps = [];
      for (var controller in _stepControllers) {
        if (controller.text.isNotEmpty) {
          steps.add(controller.text);
        }
      }

      String recipeName = _nameController.text;
      String recipeDescription = _descriptionareaController.text;
      String recipeCooktime = _cookTime.text;

      List<String> imagePaths =
          _selectedImages.map((image) => image.path).toList();

      Recipe recipe = Recipe(
        name: recipeName,
        description: recipeDescription,
        imagePaths: imagePaths,
        isFavorite: false, // Default value for isFavorite
        time: recipeCooktime,
      );
      StepsModel stepsModel = StepsModel(steps: steps);
      IngredientsModel ingredientsModel =
          IngredientsModel(ingredients: ingredients);

      addRecipe(recipe);
      addSteps(stepsModel);
      addIngredients(ingredientsModel);

      _clearPage();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please fill in all fields and select at least one image.'),
        ),
      );
    }
  }
}
