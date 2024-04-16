import 'package:flutter/material.dart';
import 'package:recipe_book/model/Ingredients_model.dart';

class IngredientList extends StatefulWidget {
  final List<RecipeIngredients> ingredients;

  const IngredientList({Key? key, required this.ingredients}) : super(key: key);

  @override
  State<IngredientList> createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  late List<bool> _isCheckedList;

  @override
  void initState() {
    super.initState();

    _isCheckedList = List<bool>.filled(_getIngredientCount(), false);
  }

  int _getIngredientCount() {
    int totalCount = 0;
    widget.ingredients.forEach((ingredient) {
      totalCount += ingredient.ingredient.length;
    });
    return totalCount;
  }

  int _getIngredientIndex(int index) {
    int currentIndex = 0;
    for (int i = 0; i < widget.ingredients.length; i++) {
      if (index >= currentIndex &&
          index < currentIndex + widget.ingredients[i].ingredient.length) {
        return i;
      }
      currentIndex += widget.ingredients[i].ingredient.length;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Ingredient List',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: _getIngredientCount(),
        itemBuilder: (context, index) {
          final ingredientIndex = _getIngredientIndex(index);
          final ingredient = widget.ingredients[ingredientIndex]
              .ingredient[index - _getIngredientIndex(index)];
          return CheckboxListTile(
            title: Text(ingredient),
            value: _isCheckedList[index],
            onChanged: (value) {
              setState(() {
                _isCheckedList[index] = value!;
              });
            },
          );
        },
      ),
    );
  }
}
