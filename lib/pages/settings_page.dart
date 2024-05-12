import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/main_page.dart';

import 'package:recipe_book/pages/about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider instance from the context
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.nightlight_round),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeProvider
                  .isDarkMode, // Use themeProvider to get the current theme state
              onChanged: (bool newValue) {
                // Update the theme state using the themeProvider
                themeProvider.toggleTheme(newValue);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Reset App'),
            onTap: () {
              // Implement logic to reset the app
            },
          ),
        ],
      ),
    );
  }
}
