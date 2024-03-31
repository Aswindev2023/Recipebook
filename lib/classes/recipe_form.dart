// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RecipeForm extends StatefulWidget {
  final List<String> categories;
  final void Function(
    List<File> selectedImages,
    String name,
    String description,
    String cookTime,
    String? selectedCategory,
    List<List<String>> ingredients,
    List<List<String>> steps,
  ) onSubmit;

  const RecipeForm({
    Key? key,
    required this.onSubmit,
    required this.categories,
  }) : super(key: key);

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionareaController =
      TextEditingController();
  final TextEditingController _cookTime = TextEditingController();
  final List<TextEditingController> _ingredientsController = [
    TextEditingController()
  ];
  final List<TextEditingController> _stepControllers = [
    TextEditingController()
  ];
  List<File> _selectedImages = [];
  String? _selectedCategory;
  bool _imagesLoading = false;

  Future<void> _getImage() async {
    setState(() {
      _imagesLoading = true;
    });
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(imageQuality: 50);
    if (pickedImages != null) {
      setState(() {
        _selectedImages =
            pickedImages.map((image) => File(image.path)).toList();
        _imagesLoading = false;
      });
    } else {
      setState(() {
        _imagesLoading =
            false; // Set loading state to false if no images are picked
      });
    }
  }

  // Validate form fields
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    return null;
  }

  String? _validateCookTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cooking time is required';
    }
    return null;
  }

  String? _validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a category';
    }
    return null;
  }

  // Submit form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Display ingredients for debugging
      for (var ingredientList in _ingredientsController
          .map((controller) => controller.text.split('\n'))) {
        print('Ingredients: $ingredientList');
      }

      widget.onSubmit(
        _selectedImages,
        _nameController.text,
        _descriptionareaController.text,
        _cookTime.text,
        _selectedCategory,
        _ingredientsController
            .map(
                (controller) => controller.text.split('\n')) // Split by newline
            .toList(),
        _stepControllers
            .map(
                (controller) => controller.text.split('\n')) // Split by newline
            .toList(),
      );
    }
  }

  //clear form
  void clearForm() {
    _nameController.clear();
    _descriptionareaController.clear();
    _cookTime.clear();
    _selectedImages.clear();
    _selectedCategory = null;
    for (var controller in _ingredientsController) {
      controller.clear();
    }
    for (var controller in _stepControllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _getImage,
            child: Container(
              height: 200,
              color: Colors.grey[300],
              child: _imagesLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _selectedImages.isEmpty
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
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            validator: _validateName,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionareaController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 2,
            decoration: const InputDecoration(
              hintText: "Enter Description",
              border: OutlineInputBorder(),
            ),
            validator: _validateDescription,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cookTime,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: ' Cooking Time',
              hintText: 'e.g. 30 minutes',
              border: OutlineInputBorder(),
            ),
            validator: _validateCookTime,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: widget.categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            validator: _validateCategory,
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < _ingredientsController.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: _ingredientsController[i],
                        decoration: InputDecoration(
                          labelText: 'Ingredients ${i + 1}',
                          border: const OutlineInputBorder(),
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingredient is required';
                          }
                          return null;
                        },
                      ),
                      if (_ingredientsController.length > 1 &&
                          i != _ingredientsController.length - 1)
                        Positioned(
                          right: 0,
                          bottom: 10,
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
                          bottom: 10,
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
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < _stepControllers.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _stepControllers[i],
                            decoration: InputDecoration(
                              labelText: 'Step ${i + 1}',
                              border: const OutlineInputBorder(),
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Step is required';
                              }
                              return null;
                            },
                          ),
                          if (_stepControllers.length > 1 &&
                              i != _stepControllers.length - 1)
                            Positioned(
                              right: 0,
                              top: 10,
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
                              bottom: 10,
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    _stepControllers
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
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red)),
                onPressed: () {
                  _formKey.currentState?.reset();
                  clearForm();
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Implement clear button
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                onPressed: () {
                  _submitForm();
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Implement add button
              ),
            ],
          ),
        ],
      ),
    );
  }
}
