import 'package:flutter/material.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';
import 'package:recipe_book/classes/list_grid.dart';
import 'package:recipe_book/db/recipe_functions.dart';
import 'package:recipe_book/model/recipebook_model.dart';

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
  // List<RecipeSteps> _steps = [];
  //List<RecipeIngredients> _ingredients = [];
  List<RecipeDetails> _filteredRecipes = [];
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    final List<RecipeDetails> recipes = await getRecipes();
    //final List<RecipeSteps> steps = await getSteps();
    //final List<RecipeIngredients> ingredients = await getIngredients();
    setState(() {
      _recipes = recipes;
      //_steps = steps;
      //_ingredients = ingredients;
      _filteredRecipes = List.from(recipes);
    });
  }

  void _filterRecipes(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isNotEmpty) {
        _filteredRecipes = _recipes
            .where((recipe) =>
                recipe.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        _filteredRecipes =
            List.from(_recipes); // Show all recipes if query is empty
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          leading: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
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
            const Text(
              'What is in your mind?',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Let\'s Make Something',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 84, 83, 83),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(left: 4, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.lightBlueAccent, width: 2),
                color: const Color.fromARGB(255, 236, 234, 234),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search...',
                  hintStyle: TextStyle(fontSize: 15),
                  border: InputBorder.none,
                ),
                onChanged: _filterRecipes,
              ),
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
