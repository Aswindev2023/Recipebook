import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_book/model/Ingredients_model.dart';
import 'package:recipe_book/model/recipe_categorymodel.dart';

import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/model/steps_model.dart';
import 'package:recipe_book/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(RecipeAdapter().typeId) &&
      !Hive.isAdapterRegistered(StepsModelAdapter().typeId) &&
      !Hive.isAdapterRegistered(IngredientsModelAdapter().typeId) &&
      !Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(RecipeAdapter());
    Hive.registerAdapter(StepsModelAdapter());
    Hive.registerAdapter(IngredientsModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/cover.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 3, 193, 227),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Image.asset(
                    'lib/assets/cake.jpg',
                    width: 169,
                    height: 169,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            top: 220,
            left: 10,
            right: 10,
            child: Center(
              child: Text(
                'Recipe Book',
                style: TextStyle(
                  fontFamily: 'Irish Grover',
                  fontSize: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 115,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 150,
                  height: 70,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Homepage()));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 26, 243, 34),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      )),
                ),
              ))
        ],
      ),
    );
  }
}
