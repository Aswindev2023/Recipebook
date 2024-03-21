import 'package:flutter/material.dart';
import 'package:recipe_book/pages/ingredients_page.dart';

class ViewRecipe extends StatefulWidget {
  const ViewRecipe({super.key});

  @override
  State<ViewRecipe> createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 245, 243),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 350,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('lib/assets/Black_Forest_Cake-4-768x1152.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Black Forest Cake',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Ingredients:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Ingredients(),
                                ));
                          },
                          icon: const Icon(Icons.content_paste_go_outlined))
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ingredient 1, Ingredient 2, Ingredient 3,Ingredient 4,Ingredient 5',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Short description about the recipe...',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Number of steps: 5',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Estimated time: 30 minutes',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all(const Size(200, 60)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 90, 255, 7)),
                          elevation: MaterialStateProperty.all(6)),
                      onPressed: () {},
                      child: const Text(
                        'Start Cooking',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
