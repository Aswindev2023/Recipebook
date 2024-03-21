import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';
import 'package:recipe_book/db/hive_service.dart';
import 'package:recipe_book/model/recipebook_model.dart'; // Import Recipe model
import 'package:image_picker/image_picker.dart';

class NewRecipe extends StatefulWidget {
  const NewRecipe({Key? key}) : super(key: key);

  @override
  State<NewRecipe> createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {
  final HiveService _hiveService = HiveService();
  final List<TextEditingController> _stepControllers = [
    TextEditingController()
  ];

  final TextEditingController _textareaController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  dynamic _selectedCategory;
  final int _selectedIndex = 3;
  String _cookTime = '';

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

  void _addRecipe() {
    final List<String> ingredients = _ingredientsController.text.split('\n');
    final List<String> steps =
        _stepControllers.map((controller) => controller.text).toList();

    final List<String> imagePaths = _selectedImages
        .map((image) => image.path)
        .toList(); // Convert File objects to paths

    final recipe = Recipe(
      name: _nameController.text,
      description: _textareaController.text,
      category: _selectedCategory!,
      imagePaths: imagePaths, // Use converted image paths
      ingredients: ingredients,
      steps: steps,
      time: _cookTime,
      images:
          _selectedImages, // Pass the original list of File objects if needed
    );

    _hiveService.addRecipe(recipe);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _textareaController.dispose();
    _nameController.dispose();
    _ingredientsController.dispose();
    for (var controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _clearPage() {
    setState(() {
      _textareaController.clear();
      _nameController.clear();
      _ingredientsController.clear();
      _stepsController.clear();
      _selectedCategory = null;
      _cookTime = '';
      _selectedImages.clear();
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
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textareaController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Enter Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                setState(() {
                  _cookTime = value;
                });
              },
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: ' Cooking Time',
                hintText: 'e.g. 30 minutes',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<RecipeCategory>(
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
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ingredientsController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Ingredients',
                border: OutlineInputBorder(),
              ),
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
                    _addRecipe();
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
}
