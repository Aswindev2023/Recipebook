import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/recipe_categorymodel.dart';

class CategoryDropdown extends StatefulWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({
    Key? key,
    required this.onChanged,
    this.selectedCategory,
  }) : super(key: key);

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  late List<String> categoryNames;

  @override
  void initState() {
    super.initState();
    categoryNames = [];
    _getCategoryNames();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedCategory,
      items: categoryNames.map((categoryName) {
        return DropdownMenuItem<String>(
          value: categoryName,
          child: Text(categoryName),
        );
      }).toList(),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: 'Category',
        hintText: 'Select Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Future<void> _getCategoryNames() async {
    final categories = await Hive.openBox<CategoryModel>('Category_db');
    setState(() {
      categoryNames =
          categories.values.map((category) => category.categoryName).toList();
    });
  }
}
