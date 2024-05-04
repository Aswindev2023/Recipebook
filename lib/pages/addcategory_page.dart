import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_book/db/category_functions.dart';
import 'package:recipe_book/model/recipe_categorymodel.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  File? _imageFile;
  final TextEditingController _nameController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void clearButton() {
    setState(() {
      _nameController.clear();
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Category',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: _imageFile == null
                    ? Container(
                        width: 150,
                        height: 150,
                        color: Colors.grey[300],
                        child: const Icon(Icons.add_a_photo),
                      )
                    : Image.file(
                        _imageFile!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: clearButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Clear',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    saveCategory();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  void saveCategory() {
    final int uniqueId = generateUniqueId();
    if (_nameController.text.isNotEmpty && _imageFile != null) {
      String categoryName = _nameController.text;
      CategoryModel category = CategoryModel(
        categoryId: uniqueId,
        categoryName: categoryName,
        image: _imageFile!.path,
      );

      addCategory(category, category.categoryId);
      print('passing $category and ${category.categoryId}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category Added'),
        ),
      );

      clearButton();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name and select an image.'),
        ),
      );
    }
  }
}
