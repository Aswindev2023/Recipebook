import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_book/classes/categoryview_layout.dart';
import 'package:recipe_book/classes/sortingoption_widget.dart';
import 'package:recipe_book/db/recipe_functions.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/pages/settings_page.dart';

class CategoryViewpage extends StatefulWidget {
  final String categoryname;
  final String image;
  const CategoryViewpage({
    Key? key,
    required this.categoryname,
    required this.image,
  }) : super(key: key);

  @override
  State<CategoryViewpage> createState() => _CategoryViewpageState();
}

class _CategoryViewpageState extends State<CategoryViewpage> {
  bool _isGridView = true;
  List<RecipeDetails> _recipes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecipes(widget.categoryname);
  }

  Future<void> _fetchRecipes(String categoryName) async {
    final List<RecipeDetails> recipes = await getRecipes();
    final filteredRecipes = recipes
        .where((recipe) => recipe.selectedCategory == categoryName)
        .toList();

    setState(() {
      _recipes = filteredRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Recipes',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
              icon: _isGridView
                  ? const Icon(Icons.list)
                  : const Icon(Icons.grid_on),
            ),
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Sort By',
                  child: ListTile(
                    title: const Text('Sort By'),
                    onTap: () {
                      Navigator.pop(context);
                      _showSortingOptions(context);
                    },
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Filtered By',
                  child: ListTile(
                    title: const Text('Filtered By'),
                    onTap: () {
                      // Handle 'Filtered By' tap
                      Navigator.pop(context);
                    },
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Settings',
                  child: ListTile(
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage()));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              width: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(widget.image)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isGridView
                  ? CategoryWidget(
                      isGridView: _isGridView,
                      recipes: _recipes,
                      fetchRecipes: _fetchRecipes,
                      categoryName: widget.categoryname,
                    )
                  : CategoryWidget(
                      isGridView: false,
                      recipes: _recipes,
                      fetchRecipes: _fetchRecipes,
                      categoryName: widget.categoryname,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SortingOptionsWidget(
          onSort: (ascending) {
            _sortRecipes(ascending);
          },
        );
      },
    );
  }

  void _sortRecipes(bool ascending) {
    List<RecipeDetails> sortedRecipes = List.from(_recipes);
    setState(() {
      sortedRecipes.sort((a, b) => _compareCookTime(a, b, ascending));
      _recipes = sortedRecipes;
    });
  }

  int _compareCookTime(
      RecipeDetails recipeA, RecipeDetails recipeB, bool ascending) {
    // Extract cook times and units
    int timeA = int.parse(recipeA.cookTime);
    int timeB = int.parse(recipeB.cookTime);
    String unitA = recipeA.selectedUnit!;
    String unitB = recipeB.selectedUnit!;

    // Convert both cook times to minutes for comparison
    if (unitA == 'Hours') {
      timeA *= 60;
    }
    if (unitB == 'Hours') {
      timeB *= 60;
    }

    // Compare cook times based on ascending or descending order
    if (ascending) {
      return timeA.compareTo(timeB);
    } else {
      return timeB.compareTo(timeA);
    }
  }
}
