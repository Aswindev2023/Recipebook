/*import 'package:flutter/material.dart';

class Ingredients extends StatefulWidget {
  const Ingredients({super.key});

  @override
  State<Ingredients> createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  final List<String> ingredients = [
    'Ingredient 1',
    'Ingredient 2',
    'Ingredient 3',
    'Ingredient 4',
    'Ingredient 5',
  ];

  List<bool> checkedIngredients = List.generate(5, (index) => false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ingredients',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: ListView.builder(
        itemCount: ingredients.length,
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
            title: Text(
              ingredients[index],
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            value: checkedIngredients[index],
            onChanged: (bool? value) {
              setState(() {
                checkedIngredients[index] = value!;
              });
            },
          );
        },
      ),
    );
  }
}
*/