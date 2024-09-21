import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:http/http.dart';
import 'package:meal_api/categories.dart';
import 'package:meal_api/ingredient.dart';
import 'package:meal_api/mealDetails.dart';
import 'package:meal_api/mealsByCategory.dart';
import 'package:meal_api/mealsByIngredient.dart';

import 'home.dart'; // Import the pages
// import 'category_page.dart';
// import 'item_page.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Routing',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 102, 67, 67),
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Color.fromARGB(
                  255, 255, 255, 255)), // Atur warna default di sini
          bodyMedium: TextStyle(
              color: Color.fromARGB(
                  215, 255, 255, 255)), // Atur warna untuk teks lainnya
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor:
              Color.fromARGB(255, 59, 48, 48), // Warna background AppBar
          titleTextStyle: TextStyle(
            color: Colors.white, // Warna teks di AppBar
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.white, // Warna ikon di AppBar
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        // '/': (context) => CategoriesPage(),
        // '/': (context) => IngredientsPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/meal/')) {
          final id = settings.name!.replaceFirst('/meal/', '');
          return MaterialPageRoute(
            builder: (context) => MealDetailsPage(id: id),
          );
        } else if (settings.name != null &&
            settings.name!.startsWith('/category/')) {
          final category = settings.name!.replaceFirst('/category/', '');
          return MaterialPageRoute(
            builder: (context) => MealByCategory(category: category),
          );
        } else if (settings.name != null &&
            settings.name!.startsWith('/ingredient/')) {
          final ingredient = settings.name!.replaceFirst('/ingredient/', '');
          return MaterialPageRoute(
            builder: (context) => MealsByIngredient(
              ingredient: ingredient,
            ),
          );
        }
        return null;
      },
    );
  }
}
