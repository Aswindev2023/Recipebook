import 'package:flutter/material.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';
import 'package:recipe_book/classes/recipe_form.dart';
import 'package:recipe_book/db/category_functions.dart'; // Import the file with getCategory function

class NewRecipe extends StatefulWidget {
  const NewRecipe({Key? key}) : super(key: key);

  @override
  State<NewRecipe> createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {
  final int _selectedIndex = 3;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories(); // Call a function to load categories
  }

  Future<void> _loadCategories() async {
    List<String> categories = await getCategory();
    setState(() {
      _categories = categories;
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
        child: RecipeForm(
          categories: _categories, // Pass categories to RecipeForm
          onSubmit: (selectedImages, name, description, cookTime,
              selectedCategory, ingredients, steps) {
            // Implement saveRecipe function or call it from here
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
