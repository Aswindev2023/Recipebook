import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_book/db/ingredients_function.dart';
import 'package:recipe_book/db/recipe_functions.dart';
import 'package:recipe_book/db/step_function.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/pages/detailedview_page.dart';

class RecipeListWidget extends StatefulWidget {
  final bool isGridView;
  final List<RecipeDetails> recipes;
  final Future<void> Function() fetchRecipes;

  const RecipeListWidget({
    Key? key,
    required this.isGridView,
    required this.recipes,
    required this.fetchRecipes,
  }) : super(key: key);

  @override
  State<RecipeListWidget> createState() => _RecipeListWidgetState();
}

class _RecipeListWidgetState extends State<RecipeListWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.isGridView
        ? _buildGridView(widget.recipes)
        : _buildListView(widget.recipes);
  }

  Widget _buildGridView(List<RecipeDetails> recipes) {
    if (recipes.isEmpty) {
      return const Center(
        child: Text(
          'No recipes available.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        final RecipeDetails recipe = recipes[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailedPage(
                  recipe: recipe,
                ),
              ),
            );
          },
          child: Card(
            elevation: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: GridTile(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (recipe.imageUrls.isNotEmpty)
                      Image.file(
                        File(recipe.imageUrls[0]),
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Center(
                            child: Icon(Icons.error),
                          );
                        },
                      )
                    else
                      const Center(
                        child: Icon(Icons.error),
                      ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 5,
                      child: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'delete') {
                            setState(() {
                              deleteRecipe(recipe.id);
                              deleteIngredient(recipe.id);
                              deleteStep(recipe.id);
                              widget.fetchRecipes();
                            });
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            child: Text("Edit"),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text("Delete"),
                          ),
                        ],
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color.fromARGB(255, 94, 93, 93)
                                    .withOpacity(0.4),
                                const Color.fromARGB(0, 75, 75, 75)
                                    .withOpacity(0.3),
                              ],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.overlay,
                          child: Text(
                            recipe.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(List<RecipeDetails> recipes) {
    if (recipes.isEmpty) {
      return const Center(
        child: Text(
          'No recipes available.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        final RecipeDetails recipe = recipes[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailedPage(recipe: recipe),
              ),
            );
          },
          child: Card(
            color: const Color.fromARGB(255, 255, 254, 234),
            elevation: 8,
            child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.file(
                    File(
                        recipe.imageUrls.isNotEmpty ? recipe.imageUrls[0] : ''),
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                ),
                title: Text(recipe.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          setState(() {
                            deleteRecipe(recipe.id);
                            deleteIngredient(recipe.id);
                            deleteStep(recipe.id);
                            widget.fetchRecipes();
                          });
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: Text(
                  'Cook time: ${recipe.cookTime} ${recipe.selectedUnit ?? ''}',
                )),
          ),
        );
      },
    );
  }
}
