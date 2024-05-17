import 'package:flutter/material.dart';
import 'package:recipe_book/db/ingredients_function.dart';
import 'package:recipe_book/db/step_function.dart';
import 'package:recipe_book/model/ingredientmodels_class.dart';
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
  }

  void _fetchIngredients() async {
    List<RecipeIngredients> ingredients =
        await getIngredients(widget.recipe.recipeId);
    setState(() {
      _ingredients = ingredients;
    });
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.recipe.imageByteList.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                MemoryImage(widget.recipe.imageByteList[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16.0),
              // Display Recipe Name and Description
              Text(
                widget.recipe.name,
                style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.recipe.description,
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 16.0),
              // Display Ingredients
              Row(
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
              Text(
                _ingredients
                    .map((ingredient) => ingredient.ingredient.join(', '))
                    .toList()
                    .join(', '),
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 16.0),
              // Display Category and Cook Time
              Text(
                'Category: ${widget.recipe.selectedCategory}',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Estimated Cook Time: ${widget.recipe.cookTime}${widget.recipe.selectedUnit}',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              // Display Steps
              const Text(
                'Steps:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _steps.map((step) {
                  return Text(
                    step.step.join(', '),
                    style: const TextStyle(fontSize: 18.0),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32.0),
              // Button to Start Cooking
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 54, 255, 9),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Stepbystep(
                          steps: _steps,
                          recipe: widget.recipe,
                        ),
                      ),
                    );
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
            ],
          ),
        ),
      ),
    );
  }
}
