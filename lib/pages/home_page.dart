import 'package:flutter/material.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';
import 'package:recipe_book/classes/list_grid.dart';
import 'package:recipe_book/db/hive_service.dart';
import 'package:recipe_book/model/recipebook_model.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    Key? key,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late List<Recipe> _recipes;
  bool _isGridView = true;
  final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _recipes = [];
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    if (recipeListNotifier.value != null) {
      _recipes = List.of(recipeListNotifier.value);
    } else {
      // Handle the case where recipeListNotifier.value is null or not initialized
      // For example, you could assign an empty list as a fallback
      print('empty recipe list');
    }
  }

  void toggleFavoriteStatus(int index) {
    setState(() {
      _recipes[index].isFavorite = !_recipes[index].isFavorite;
    });
    _updateFavoriteRecipes();
    print(
        'Recipe at index $index toggled favorite status: ${_recipes[index].isFavorite}');
  }

  Future<void> _updateFavoriteRecipes() async {
    List<Recipe> favoriteRecipes =
        _recipes.where((recipe) => recipe.isFavorite).toList();
    await saveFavoriteRecipes(favoriteRecipes);
    print('Updated favorite recipes: $favoriteRecipes');
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
                onChanged: (value) {},
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isGridView
                  ? RecipeListWidget(
                      recipes: _recipes,
                      toggleFavoriteStatus: toggleFavoriteStatus,
                      isGridView: _isGridView,
                    )
                  : RecipeListWidget(
                      recipes: _recipes,
                      toggleFavoriteStatus: toggleFavoriteStatus,
                      isGridView: false,
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
                },
              ),
              ListTile(
                title: const Text('Time(Highest to Lowest)'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
