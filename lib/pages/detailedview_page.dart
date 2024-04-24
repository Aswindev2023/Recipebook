import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe_book/db/ingredients_function.dart';
import 'package:recipe_book/db/step_function.dart';
import 'package:recipe_book/model/Ingredients_model.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/model/steps_model.dart';
import 'package:recipe_book/pages/ingredientlist_page.dart';
import 'package:recipe_book/pages/stepbystep_page.dart';

class DetailedPage extends StatefulWidget {
  final RecipeDetails recipe;

  const DetailedPage({Key? key, required this.recipe}) : super(key: key);

  @override
  State<DetailedPage> createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {
  late List<RecipeSteps> _steps = [];
  late List<RecipeIngredients> _ingredients = [];

  @override
  void initState() {
    super.initState();
    _fetchSteps();
    _fetchIngredients();
  }

  void _fetchSteps() async {
    List<RecipeSteps> steps = await getSteps(widget.recipe.recipeId);
    setState(() {
      _steps = steps;
    });
    print('_fetchstep recipeId:${widget.recipe.recipeId}');
    print('fetchstep:$_steps');
  }

  void _fetchIngredients() async {
    List<RecipeIngredients> ingredients =
        await getIngredients(widget.recipe.recipeId);
    setState(() {
      _ingredients = ingredients;
    });
    print('_fetchingredient recipeId:${widget.recipe.recipeId}');
    print('fetch ingredients: $_ingredients');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recipe Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.recipe.imageUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(widget.recipe.imageUrls[index])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.recipe.name,
                style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.recipe.description,
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 1.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  const Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  IngredientList(ingredients: _ingredients),
                            ));
                      },
                      icon: const Icon(Icons.content_paste_go_outlined))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _ingredients
                    .map((ingredient) => ingredient.ingredient.join(', '))
                    .toList()
                    .join(', '),
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Category: ${widget.recipe.selectedCategory}',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Estimated Cook Time: ${widget.recipe.cookTime}${widget.recipe.selectedUnit}',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Steps:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Displaying Steps
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _steps.map((step) {
                  return Text(
                    step.step.join(
                        ', '), // Joining the list of strings into a single string
                    style: const TextStyle(fontSize: 18.0),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 54, 255, 9))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Stepbystep(
                            steps: _steps,
                            recipe: widget.recipe,
                          ),
                        ));
                  },
                  child: const Text(
                    'Start Cooking',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
