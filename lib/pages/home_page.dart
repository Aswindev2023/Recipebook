import 'package:flutter/material.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';
import 'package:recipe_book/classes/filterby_category.dart';
import 'package:recipe_book/classes/list_grid.dart';
import 'package:recipe_book/classes/sortingoption_widget.dart';
import 'package:recipe_book/db/recipe_functions.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/pages/settings_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    Key? key,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _isGridView = true;
  final int _selectedIndex = 0;
  List<RecipeDetails> _recipes = [];

  List<RecipeDetails> _filteredRecipes = [];
  List<String> _selectedCategories = []; // Define this in your state class

  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    final List<RecipeDetails> recipes = await getRecipes();

    setState(() {
      _recipes = recipes;

      _filteredRecipes = List.from(recipes);
    });
  }

  void _filterRecipes(String query, List<String> selectedCategories) {
    setState(() {
      _searchQuery = query;

      final List<RecipeDetails> searchFilteredRecipes =
          _recipes.where((recipe) {
        return query.isEmpty ||
            recipe.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (selectedCategories.isEmpty) {
        _filteredRecipes = List.from(searchFilteredRecipes);
      } else {
        _filteredRecipes = searchFilteredRecipes.where((recipe) {
          return selectedCategories.contains(recipe.selectedCategory);
        }).toList();
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
          leading: Icon(Icons.arrow_back,
              color: isDarkTheme
                  ? const Color.fromARGB(117, 32, 31, 31)
                  : Colors.white),
          centerTitle: true,
          title: Text(
            'Recipes',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
              icon: _isGridView
                  ? Icon(
                      Icons.list,
                      color: isDarkTheme ? Colors.white : Colors.black,
                    )
                  : Icon(
                      Icons.grid_on,
                      color: isDarkTheme ? Colors.white : Colors.black,
                    ),
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
            const Text(
              'What is in your mind?',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Let\'s Make Something',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
                color: isDarkTheme
                    ? const Color.fromARGB(255, 207, 204, 204)
                    : const Color.fromARGB(255, 84, 83, 83),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(left: 4, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.lightBlueAccent, width: 2),
                color: isDarkTheme
                    ? const Color.fromARGB(255, 62, 60, 60)
                    : const Color.fromARGB(255, 255, 255, 255),
              ),
              child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search...',
                    hintStyle: TextStyle(fontSize: 15),
                    border: InputBorder.none,
                  ),
                  onChanged: (query) {
                    _filterRecipes(query, _selectedCategories);
                  }),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isGridView
                  ? RecipeListWidget(
                      isGridView: _isGridView,
                      recipes:
                          _searchQuery.isEmpty ? _recipes : _filteredRecipes,
                      fetchRecipes: _fetchRecipes,
                    )
                  : RecipeListWidget(
                      isGridView: false,
                      recipes:
                          _searchQuery.isEmpty ? _recipes : _filteredRecipes,
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
            setState(() {
              _selectedCategories = selectedCategories;
            });
            _filterRecipes(_searchQuery, _selectedCategories);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Filters applied'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }
}
