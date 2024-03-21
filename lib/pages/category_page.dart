import 'package:flutter/material.dart';
import 'package:recipe_book/classes/bottomnavigationbar.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final int _selectedIndex = 1;

  final List<Map<String, dynamic>> categories = [
    {'title': 'Cakes', 'image': 'lib/assets/cake.jpg'},
    {'title': 'Mexican', 'image': 'lib/assets/cover.png'},
  ];

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
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                size: 30,
              )),
          const SizedBox(
            width: 15,
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: ListTile(
              title: Text(categories[index]['title']),
              trailing: CircleAvatar(
                backgroundImage: AssetImage(categories[index]['image']),
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
