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

class UpdateRecipe extends StatefulWidget {
  const UpdateRecipe({Key? key}) : super(key: key);

  @override
  State<UpdateRecipe> createState() => _UpdateRecipeState();
}

class _UpdateRecipeState extends State<UpdateRecipe> {
  final List<TextEditingController> _stepUpdateControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> _ingredientsUpdateController = [
    TextEditingController()
  ];

  final TextEditingController _descriptionareaUpdateController =
      TextEditingController();
  final TextEditingController _nameUpdateController = TextEditingController();

  final int _selectedIndex = 3;
  final TextEditingController _cookTimeUpdate = TextEditingController();

  List<File> _updateSelectedImages = [];

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(imageQuality: 50);
    // ignore: unnecessary_null_comparison
    if (pickedImages != null) {
      setState(() {
        _updateSelectedImages =
            pickedImages.map((image) => File(image.path)).toList();
      });
    }
  }

  @override
  void dispose() {
    _descriptionareaUpdateController.dispose();
    _nameUpdateController.dispose();
    for (var controller in _ingredientsUpdateController) {
      controller.dispose();
    }
    _cookTimeUpdate.dispose();
    for (var controller in _stepUpdateControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _clearPage() {
    setState(() {
      _descriptionareaUpdateController.clear();
      _nameUpdateController.clear();
      _cookTimeUpdate.clear();
      _updateSelectedImages.clear();

      _ingredientsUpdateController.clear();
      _ingredientsUpdateController.add(TextEditingController());
      _stepUpdateControllers.clear();
      _stepUpdateControllers.add(TextEditingController());
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
          'Update Recipe',
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
                child: _updateSelectedImages.isEmpty
                    ? Center(
                        child: IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          onPressed: _getImage,
                        ),
                      )
                    : PageView.builder(
                        itemCount: _updateSelectedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(_updateSelectedImages[index]),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameUpdateController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionareaUpdateController,
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
              controller: _cookTimeUpdate,
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
                for (int i = 0; i < _ingredientsUpdateController.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Stack(
                      children: [
                        TextField(
                          controller: _ingredientsUpdateController[i],
                          decoration: InputDecoration(
                            labelText: 'Ingredients ${i + 1}',
                            border: const OutlineInputBorder(),
                          ),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        if (_ingredientsUpdateController.length > 1 &&
                            i != _ingredientsUpdateController.length - 1)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  _ingredientsUpdateController.removeAt(i);
                                });
                              },
                            ),
                          ),
                        if (i == _ingredientsUpdateController.length - 1)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _ingredientsUpdateController
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
            const SizedBox(height: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < _stepUpdateControllers.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Stack(
                      children: [
                        TextField(
                          controller: _stepUpdateControllers[i],
                          decoration: InputDecoration(
                            labelText: 'Step ${i + 1}',
                            border: const OutlineInputBorder(),
                          ),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        if (_stepUpdateControllers.length > 1 &&
                            i != _stepUpdateControllers.length - 1)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  _stepUpdateControllers.removeAt(i);
                                });
                              },
                            ),
                          ),
                        if (i == _stepUpdateControllers.length - 1)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _stepUpdateControllers
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

    if (_nameUpdateController.text.isNotEmpty &&
        _updateSelectedImages.isNotEmpty &&
        _descriptionareaUpdateController.text.isNotEmpty &&
        _ingredientsUpdateController.isNotEmpty &&
        _stepUpdateControllers.isNotEmpty &&
        _cookTimeUpdate.text.isNotEmpty) {
      List<String> ingredients = [];
      for (var controller in _ingredientsUpdateController) {
        if (controller.text.isNotEmpty) {
          ingredients.add(controller.text);
        }
      }

      List<String> steps = [];
      for (var controller in _stepUpdateControllers) {
        if (controller.text.isNotEmpty) {
          steps.add(controller.text);
        }
      }

      String recipeName = _nameUpdateController.text;
      String recipeDescription = _descriptionareaUpdateController.text;
      String recipeCooktime = _cookTimeUpdate.text;

      List<String> imagePaths =
          _updateSelectedImages.map((image) => image.path).toList();

      Recipe recipe = Recipe(
        name: recipeName,
        description: recipeDescription,
        imagePaths: imagePaths,
        isFavorite: false,
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
