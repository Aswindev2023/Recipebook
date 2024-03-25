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
      List<String> ingredients,
      List<String> steps) onSubmit;

  const RecipeForm({
    Key? key,
    required this.onSubmit,
    required this.categories,
  }) : super(key: key);

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
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
  bool _imagesLoading = false; // Track if images are loading

  Future<void> _getImage() async {
    setState(() {
      _imagesLoading = true; // Set loading state to true when fetching images
    });
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(imageQuality: 50);
    if (pickedImages != null) {
      setState(() {
        _selectedImages =
            pickedImages.map((image) => File(image.path)).toList();
        _imagesLoading =
            false; // Set loading state to false when images are loaded
      });
    } else {
      setState(() {
        _imagesLoading =
            false; // Set loading state to false if no images are picked
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _getImage,
          child: Container(
            height: 200,
            color: Colors.grey[300],
            child: _imagesLoading
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Placeholder while images are loading
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
        ),
        const SizedBox(height: 15),
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
        const SizedBox(height: 14),
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
              onPressed: () {}, child: null,
              // Implement clear button
            ),
            ElevatedButton(
              onPressed: () {}, child: null,
              // Implement add button
            ),
          ],
        ),
      ],
    );
  }
}
