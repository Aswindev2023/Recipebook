import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:recipe_book/model/recipe_categorymodel.dart';

class CategorySelectionBottomSheet extends StatefulWidget {
  final Function(List<String>) onDone;

  const CategorySelectionBottomSheet({Key? key, required this.onDone})
      : super(key: key);

  @override
  State<CategorySelectionBottomSheet> createState() =>
      _CategorySelectionBottomSheetState();
}

class _CategorySelectionBottomSheetState
    extends State<CategorySelectionBottomSheet> {
  late List<String> categoryNames = [];
  late List<bool> selectedCategories = [];
  late List<bool> initialSelectedCategories = [];
  late Future<void> _loadingState;

  @override
  void initState() {
    super.initState();
    _getCategoryNames();
    _loadingState = _loadSelectedCategories();
  }

  Future<void> _loadSelectedCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? selected = prefs.getStringList('selectedCategories');
    if (selected != null) {
      setState(() {
        selectedCategories = List.generate(
          categoryNames.length,
          (index) => selected.contains(categoryNames[index]),
        );
        initialSelectedCategories = List.from(selectedCategories);
      });
    } else {
      setState(() {
        selectedCategories = List.filled(categoryNames.length, false);
        initialSelectedCategories = List.from(selectedCategories);
      });
    }
  }

  Future<void> _getCategoryNames() async {
    final categories = await Hive.openBox<CategoryModel>('Category_db');
    setState(() {
      categoryNames =
          categories.values.map((category) => category.categoryName).toList();
      if (selectedCategories.isEmpty) {
        selectedCategories = List.filled(categoryNames.length, false);
        initialSelectedCategories = List.from(selectedCategories);
      }
    });
  }

  Future<void> _saveSelectedCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'selectedCategories',
      categoryNames.where((name) {
        int index = categoryNames.indexOf(name);
        return selectedCategories[index];
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<void>(
              future: _loadingState,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: categoryNames.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(categoryNames[index]),
                        value: selectedCategories[index],
                        onChanged: (value) async {
                          setState(() {
                            selectedCategories[index] = value!;
                          });
                          await _saveSelectedCategories();
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              widget.onDone(selectedCategories
                  .asMap()
                  .entries
                  .where((entry) => entry.value)
                  .map((entry) => categoryNames[entry.key])
                  .toList());
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
