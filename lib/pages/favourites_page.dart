import 'package:flutter/material.dart';
import 'package:recipe_book/classes/list_grid.dart';
import 'package:recipe_book/db/hive_service.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';

class Favorites extends StatefulWidget {
  final List<Recipe> recipes;

  const Favorites({Key? key, required this.recipes}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late List<Recipe> _favoriteRecipes;
  bool _isGridView = true;
  final int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    print('Loading favorite recipes...');
    List<Recipe> favoriteRecipes = await getFavoriteRecipes();
    print('Favorite recipes loaded: $favoriteRecipes');
    setState(() {
      _favoriteRecipes = favoriteRecipes;
    });
  }

  void toggleFavoriteStatus(int index) {
    print('Toggling favorite status for recipe at index $index...');
    setState(() {
      widget.recipes[index].isFavorite = !widget.recipes[index].isFavorite;
    });
    print(
        'Recipe at index $index toggled favorite status: ${widget.recipes[index].isFavorite}');

    _updateFavoriteRecipes();
  }

  void _updateFavoriteRecipes() {
    List<Recipe> favoriteRecipes =
        widget.recipes.where((recipe) => recipe.isFavorite).toList();

    print('Updating favorite recipes...');
    saveFavoriteRecipes(favoriteRecipes);
    print('Favorite recipes updated.');
    _loadFavoriteRecipes();
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
            'Favorites',
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
            Expanded(
              child: RecipeListWidget(
                recipes: widget.recipes,
                toggleFavoriteStatus: toggleFavoriteStatus, // Pass the function
                isGridView: _isGridView,
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
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
