import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_book/model/recipebook_model.dart';

class RecipeListWidget extends StatelessWidget {
  final bool isGridView;
  final List<RecipeDetails> recipes;

  const RecipeListWidget({
    Key? key,
    required this.isGridView,
    required this.recipes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isGridView ? _buildGridView(recipes) : _buildListView(recipes);
  }

  Widget _buildGridView(List<RecipeDetails> recipes) {
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
                builder: (context) => const Placeholder(),
                // builder: (context) => ViewRecipe(recipe: recipe),
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
                        File(recipe.imageUrls[
                            0]), // Assuming imageUrls is a list of file paths
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
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            child: Text("Share"),
                          ),
                          const PopupMenuItem(
                            child: Text("Edit"),
                          ),
                          const PopupMenuItem(
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

  Widget _buildListView(recipes) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        final RecipeDetails recipe = recipes[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const Placeholder() //ViewRecipe(recipe: recipe),
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
                  File(recipe.imageUrls.isNotEmpty
                      ? recipe.imageUrls[0]
                      : ''), // Assuming imageUrls is a list of file paths
                  fit: BoxFit.cover,
                  width: 60, // Set width according to your design
                  height: 60, // Set height according to your design
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
                    onSelected: (value) {},
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'share',
                        child: Text('Share'),
                      ),
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
              subtitle:
                  Text('Cook time: ${recipe.cookTime}${recipe.selectedUnit}'),
            ),
          ),
        );
      },
    );
  }
}
