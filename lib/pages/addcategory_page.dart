import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book/db/category_functions.dart';
import 'package:recipe_book/model/recipe_categorymodel.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  PlatformFile? _imageFile;
  final TextEditingController _nameController = TextEditingController();

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) {
        return;
      }

      setState(() {
        _imageFile = result.files.first;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
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
            GestureDetector(
              onTap: _pickImage,
              child: _imageFile == null
                  ? Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey[300],
                      child: Icon(Icons.add_a_photo),
                    )
                  : Image.memory(
                      _imageFile!.bytes!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    clearButton();
                  },
                  child: const Text('clear'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    saveCategory();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void saveCategory() {
    if (_nameController.text.isNotEmpty && _imageFile != null) {
      String categoryName = _nameController.text;
      CategoryModel category = CategoryModel(
        categoryName: categoryName,
        image: _imageFile?.path ?? '',
      );

      addCategory(category);

      clearButton();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name and select an image.'),
        ),
      );
    }
  }
}
