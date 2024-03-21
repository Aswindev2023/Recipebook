import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:recipe_book/db/type_adapter.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/pages/home_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  //Hive.registerAdapter(RecipeAdapter());
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox('recipebook');
  List<Recipe> recipes = Hive.box('recipebook').values.cast<Recipe>().toList();
  runApp(MyApp(recipes: recipes));
}

class MyApp extends StatelessWidget {
  final List<Recipe> recipes;
  const MyApp({Key? key, required this.recipes}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(recipes: recipes),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Recipe> recipes;
  const MyHomePage({Key? key, required this.recipes}) : super(key: key);
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
                                builder: (context) =>
                                    Homepage(recipes: recipes)));
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
