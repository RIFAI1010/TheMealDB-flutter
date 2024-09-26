import 'package:flutter/material.dart';
import 'package:meal_api/mealsByIngredient.dart';
import 'package:meal_api/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meal_api/widget/loading.dart';

class IngredientsPage extends StatefulWidget {
  @override
  _IngredientsPageState createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  List ingredients = [];
  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    fetchIngredients();
  }

  // Fetch ingredients from the API
  Future<void> fetchIngredients() async {
    final response =
        await http.get(Uri.parse('${Util.baseUrl}/list.php?i=list'));

    if (response.statusCode == 200) {
      setState(() {
        ingredients = json.decode(response.body)['meals'];
      });
    } else {
      throw Exception('Failed to load ingredients');
    }
  }

  // Get the items for the current page
  List getCurrentPageItems() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return ingredients.sublist(
        startIndex, endIndex.clamp(0, ingredients.length));
  }

  // Change page
  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    List currentIngredients = getCurrentPageItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredients'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ingredients.isEmpty
                ? const LoadingWidget()
                : ListView.builder(
                    itemCount: currentIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = currentIngredients[index];
                      return ListTile(
                        title: Text(
                          ingredient['strIngredient'],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        leading: Image.network(
                          'https://www.themealdb.com/images/ingredients/${ingredient['strIngredient']}.png',
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported,
                                size: 150);
                          },
                        ),
                        onTap: () {
                          // Navigate to MealsByIngredient when an ingredient is tapped
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
                    },
                  ),
          ),
          // SizedBox(height: 16.0,),
          Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 240, 209),
                ),
                onPressed:
                currentPage > 1 ? () => changePage(currentPage - 1) : null,
                child: const Text('Previous'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 240, 209),
                ),
                onPressed: currentPage * itemsPerPage < ingredients.length
                    ? () => changePage(currentPage + 1)
                    : null,
                child: const Text('Next'),
              ),
            ],
          ),

          ),

        ],
      ),
    );
  }
}
