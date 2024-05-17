import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/model/ingredientmodels_class.dart';
import 'package:recipe_book/model/favourite_model.dart';
import 'package:recipe_book/model/recipe_categorymodel.dart';
import 'package:recipe_book/model/recipebook_model.dart';
import 'package:recipe_book/model/steps_model.dart';
import 'package:recipe_book/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(RecipeDetailsAdapter().typeId) &&
      !Hive.isAdapterRegistered(RecipeStepsAdapter().typeId) &&
      !Hive.isAdapterRegistered(RecipeIngredientsAdapter().typeId) &&
      !Hive.isAdapterRegistered(CategoryModelAdapter().typeId) &&
      !Hive.isAdapterRegistered(FavouritesAdapter().typeId)) {
    Hive.registerAdapter(RecipeDetailsAdapter());
    Hive.registerAdapter(RecipeStepsAdapter());
    Hive.registerAdapter(RecipeIngredientsAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(FavouritesAdapter());
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('darkMode') ?? false;
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(isDarkMode),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme:
              themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: const MyHomePage(),
        );
      },
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
      body: SafeArea(
        child: Stack(
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
            FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.8,
              child: Align(
                alignment: Alignment.center,
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
            ),
            FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.4,
              alignment: Alignment.topCenter,
              child: Center(
                child: Text(
                  'Recipe Book',
                  style: TextStyle(
                    fontFamily: 'Irish Grover',
                    fontSize: MediaQuery.of(context).size.width * 0.15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.2,
              alignment: Alignment.bottomCenter,
              child: Center(
                child: SizedBox(
                  width: 150,
                  height: 70,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Homepage()),
                      );
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider(this._isDarkMode);

  void toggleTheme(bool isDarkMode) async {
    _isDarkMode = isDarkMode;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode);
  }

  void reset() async {
    _isDarkMode = false;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
  }
}
