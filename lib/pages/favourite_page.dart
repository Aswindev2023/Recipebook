import 'package:flutter/material.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';
import 'package:recipe_book/classes/favourite_layout.dart';
import 'package:recipe_book/classes/filterby_category.dart';
import 'package:recipe_book/classes/sortingoption_widget.dart';

import 'package:recipe_book/db/favourite_functions.dart';

import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/pages/settings_page.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({
    Key? key,
  }) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  bool _isGridView = true;
  final int _selectedIndex = 2;
  List<RecipeDetails> _recipes = [];
  List<RecipeDetails> _filteredRecipes = [];
  List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    final List<RecipeDetails> recipes = await getFavouriteRecipes();

    setState(() {
      _recipes = recipes;
      _filteredRecipes = List.from(recipes);
    });
  }

  void _filterRecipes(List<String> selectedCategories) {
    setState(() {
      _selectedCategories = selectedCategories;
      if (_selectedCategories.isNotEmpty) {
        _filteredRecipes = _recipes.where((recipe) {
          return _selectedCategories.contains(recipe.selectedCategory);
        }).toList();
      } else {
        _filteredRecipes = List.from(_recipes);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkTheme = brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          leading: Icon(
            Icons.arrow_back,
            color: isDarkTheme
                ? const Color.fromARGB(117, 32, 31, 31)
                : Colors.white,
          ),
          centerTitle: true,
          title: const Text(
            'Favourites',
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
                      Navigator.pop(context);
                      _showCategorySelection(context);
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
            const SizedBox(height: 20),
            Expanded(
              child: _isGridView
                  ? FavouriteWidget(
                      isGridView: _isGridView,
                      recipes: _selectedCategories.isNotEmpty
                          ? _filteredRecipes
                          : _recipes,
                      fetchRecipes: _fetchRecipes,
                    )
                  : FavouriteWidget(
                      isGridView: false,
                      recipes: _selectedCategories.isNotEmpty
                          ? _filteredRecipes
                          : _recipes,
                      fetchRecipes: _fetchRecipes,
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
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
      _filteredRecipes = List.from(sortedRecipes);
    });
  }

  int _compareCookTime(
      RecipeDetails recipeA, RecipeDetails recipeB, bool ascending) {
    int timeA = int.parse(recipeA.cookTime);
    int timeB = int.parse(recipeB.cookTime);
    String unitA = recipeA.selectedUnit!;
    String unitB = recipeB.selectedUnit!;
    if (unitA == 'Hours') {
      timeA *= 60;
    }
    if (unitB == 'Hours') {
      timeB *= 60;
    }
    if (ascending) {
      return timeA.compareTo(timeB);
    } else {
      return timeB.compareTo(timeA);
    }
  }

  void _showCategorySelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CategorySelectionBottomSheet(
          onDone: (selectedCategories) {
            _filterRecipes(selectedCategories);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Filters applied'),
              ),
            );
          },
        );
      },
    );
  }
}
