import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_book/classes/categoryview_layout.dart';
import 'package:recipe_book/db/recipe_functions.dart';
import 'package:recipe_book/model/recipebook_model.dart';

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
              icon: const Icon(Icons.sort),
              onPressed: () {
                _showSortingOptions(context);
              },
            ),
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
            const SizedBox(width: 10),
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
                    )
                  : CategoryWidget(
                      isGridView: false,
                      recipes: _recipes,
                      fetchRecipes: _fetchRecipes,
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
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Time(Lowest to Highest)'),
                onTap: () {
                  Navigator.pop(context);
                  _sortRecipes(true);
                },
              ),
              ListTile(
                title: const Text('Time(Highest to Lowest)'),
                onTap: () {
                  Navigator.pop(context);
                  _sortRecipes(false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _sortRecipes(bool ascending) {
    List<RecipeDetails> sortedRecipes = List.from(_recipes);
    setState(() {
      if (ascending) {
        sortedRecipes.sort((a, b) => a.cookTime.compareTo(b.cookTime));
      } else {
        sortedRecipes.sort((a, b) => b.cookTime.compareTo(a.cookTime));
      }
      _recipes = sortedRecipes;
    });
  }
}
