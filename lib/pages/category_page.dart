import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';
import 'package:recipe_book/model/recipe_categorymodel.dart';
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
    final categories = await Hive.openBox<CategoryModel>('Category_db');
    setState(() {
      _categories = categories.values.toList();
    });
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
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
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
                return Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(_categories[index].categoryName),
                    leading: CircleAvatar(
                      backgroundImage: _categories[index].image.isNotEmpty
                          ? FileImage(File(_categories[index].image))
                          : const AssetImage('assets/placeholder_image.png')
                              as ImageProvider,
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          child: Text("Edit"),
                        ),
                        const PopupMenuItem(
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
                                    categoryname:
                                        _categories[index].categoryName,
                                    image: _categories[index].image,
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
