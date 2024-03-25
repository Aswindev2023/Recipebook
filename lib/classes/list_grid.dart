import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_book/model/recipebook_model.dart';
//import 'package:recipe_book/pages/view_recipe.dart';

class RecipeListWidget extends StatelessWidget {
  final List<Recipe> recipes;
  final Function(int) toggleFavoriteStatus;

  final bool isGridView;

  const RecipeListWidget({
    Key? key,
    required this.recipes,
    required this.toggleFavoriteStatus,
    required this.isGridView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isGridView ? _buildGridView() : _buildListView();
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        final Recipe recipe = recipes[index];
        final List<File> images =
            recipe.imagePaths.map((path) => File(path)).toList();
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const Placeholder() // ViewRecipe(recipe: recipe),
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
                    images.isNotEmpty && images[0].existsSync()
                        ? Image.file(
                            File(images[0].path),
                            fit: BoxFit.cover,
                          )
                        : const Placeholder(),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        onPressed: () {
                          toggleFavoriteStatus(index);
                        },
                        icon: Icon(
                          recipes[index].isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: recipes[index].isFavorite
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        final Recipe recipe = recipes[index];
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
                  File((recipe.imagePaths.isNotEmpty
                      ? recipe.imagePaths[0]
                      : '')),
                  width: 60,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(recipe.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      toggleFavoriteStatus(index);
                    },
                    icon: Icon(
                      recipes[index].isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          recipes[index].isFavorite ? Colors.red : Colors.black,
                    ),
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
              subtitle: Text(recipe.description),
            ),
          ),
        );
      },
    );
  }
}
