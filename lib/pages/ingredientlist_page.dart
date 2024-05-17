import 'package:flutter/material.dart';
import 'package:recipe_book/model/ingredientmodels_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IngredientList extends StatefulWidget {
  final List<RecipeIngredients> ingredients;

  const IngredientList({Key? key, required this.ingredients}) : super(key: key);

  @override
  State<IngredientList> createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  late List<bool> _isCheckedList;
  late Future<void> _loadingState;

  @override
  void initState() {
    super.initState();
    _loadingState = _loadCheckboxesState();
  }

  Future<void> _loadCheckboxesState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCheckedList = List.generate(_getIngredientCount(), (index) {
        return prefs.getBool('checkbox_$index') ?? false;
      });
    });
  }

  void _saveCheckboxState(int index, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checkbox_$index', value);
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
      body: FutureBuilder<void>(
        future: _loadingState,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
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
                      _saveCheckboxState(index, value);
                    });
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          setState(() {
            _isCheckedList = List<bool>.filled(_getIngredientCount(), false);
            _isCheckedList.forEachIndexed((index, _) {
              _saveCheckboxState(index, false);
            });
          });
        },
        child: const Text(
          'Clear All',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  int _getIngredientCount() {
    int totalCount = 0;
    for (var ingredient in widget.ingredients) {
      totalCount += ingredient.ingredient.length;
    }
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
}

extension ListExtensions<T> on List<T> {
  void forEachIndexed(void Function(int index, T item) f) {
    for (var i = 0; i < length; i++) {
      f(i, this[i]);
    }
  }
}
