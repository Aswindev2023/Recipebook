import 'package:flutter/material.dart';
import 'package:recipe_book/classes/navigate_pages.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;

  const BottomNavigationBarWidget({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Category',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'New',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        NavigationService.navigateToHomePage(context);
        break;
      case 1:
        NavigationService.navigateToCategoryPage(context);
        break;
      case 2:
        NavigationService.navigateToFavoritesPage(context);
        break;
      case 3:
        NavigationService.navigateToNewRecipePage(context);
        break;
    }
  }
}
