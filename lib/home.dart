import 'package:flutter/material.dart';
import 'package:meal_api/ingredient.dart';
import 'package:meal_api/categories.dart';
import 'package:meal_api/mealsByCategory.dart';
import 'package:meal_api/mealsByIngredient.dart';
import 'package:meal_api/util.dart';
import 'package:meal_api/widget/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List ingredients = [];
  List categories = [];

  @override
  void initState() {
    super.initState();
    fetchIngredients();
    fetchCategories();
  }

  // Fetch ingredients from the API (limit to 5)
  Future<void> fetchIngredients() async {
    final response =
        await http.get(Uri.parse('${Util.baseUrl}/list.php?i=list'));

    if (response.statusCode == 200) {
      setState(() {
        ingredients = json.decode(response.body)['meals'].take(5).toList();
      });
    } else {
      throw Exception('Failed to load ingredients');
    }
  }

  // Fetch categories from the API (limit to 5)
  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('${Util.baseUrl}/categories.php'));

    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body)['categories'].take(5).toList();
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ingredients section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to IngredientsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IngredientsPage()),
                      );
                    },
                    child: Row(
                      children: const [
                        Text(
                          'See all',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 240,
                                  209)), // Change to black or other color
                        ),
                        Icon(Icons.arrow_right,
                            color: Color.fromARGB(255, 255, 240, 209)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ingredients.isEmpty
                  ? const LoadingWidget()
                  : Column(
                      children: ingredients.map((ingredient) {
                        return ListTile(
                          title: Text(
                            ingredient['strIngredient'],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          leading: Image.network(
                            'https://www.themealdb.com/images/ingredients/${ingredient['strIngredient']}.png',
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  size: 50);
                            },
                          ),
                          onTap: () {
                            // Navigate ke halaman ingredient berdasarkan nama
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MealsByIngredient(
                                  ingredient: ingredient['strIngredient'],
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 20),

              // Categories section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to CategoriesPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesPage()),
                      );
                    },
                    child: Row(
                      children: const [
                        Text(
                          'See all',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 240,
                                  209)), // Change to black or other color
                        ),
                        Icon(Icons.arrow_right,
                            color: Color.fromARGB(255, 255, 240, 209)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              categories.isEmpty
                  ? const LoadingWidget()
                  : Column(
                      children: categories.map((category) {
                        return ListTile(
                          title: Text(
                            category['strCategory'],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          leading: Image.network(
                            category['strCategoryThumb'],
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                size: 50,
                              );
                            },
                          ),
                          onTap: () {
                            // Navigate ke halaman ingredient berdasarkan nama
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MealByCategory(
                                    category: category['strCategory']),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
