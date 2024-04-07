import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';
import 'package:recipe_book/model/recipe_categorymodel.dart';
import 'package:recipe_book/pages/addcategory_page.dart';

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
    print('Fetching categories...');
    final categories = await Hive.openBox<CategoryModel>('Category_db');
    setState(() {
      _categories = categories.values.toList();
    });
    print('Categories fetched: $_categories');
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
      body: ListView.builder(
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
              onTap: () {},
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
