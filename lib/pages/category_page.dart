import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';
import 'package:recipe_book/db/category_functions.dart';
import 'package:recipe_book/db/recipe_functions.dart';
import 'package:recipe_book/model/recipe_categorymodel.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/pages/addcategory_page.dart';
import 'package:recipe_book/pages/categoryview_page.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final int _selectedIndex = 1;

  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  Future<void> getCategory() async {
    print('getCategory in view page is called');
    List<CategoryModel> categoriesList = await getCategoryList();
    print('category list is:$categoriesList');

    setState(() {
      _categories = categoriesList;
    });
  }

  Future<void> deleteCategories(String name, int id) async {
    final List<RecipeDetails> recipes = await getRecipes();
    final updatedRecipes =
        recipes.any((recipe) => recipe.selectedCategory == name);
    if (!updatedRecipes) {
      deleteCategory(id);
      setState(() {
        getCategory();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          'Categories',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCategory(),
                ),
              ).then((value) {
                getCategory();
              });
            },
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: _categories.isEmpty
          ? const Center(
              child: Text(
                'No categories available.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final CategoryModel categories = _categories[index];
                print('Base64 string: ${categories.image}');

                return Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(categories.categoryName),
                    leading: CircleAvatar(
                      backgroundImage: categories.image.isNotEmpty
                          ? MemoryImage(base64Decode(categories.image))
                              as ImageProvider<Object>
                          : const AssetImage('assets/placeholder_image.png'),
                    ),
                    trailing: PopupMenuButton(
                      onSelected: (value) async {
                        if (value == 'delete') {
                          await deleteCategories(
                              categories.categoryName, categories.id);
                          setState(() {});
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text("Edit"),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text("Delete"),
                        ),
                      ],
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryViewpage(
                                    categoryname: categories.categoryName,
                                    image: categories.image,
                                  )));
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
