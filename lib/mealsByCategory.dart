import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:meal_api/mealDetails.dart';
import 'package:meal_api/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meal_api/widget/loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pagination Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MealByCategory(
        category: 'dessert',
      ),
    );
  }
}

class MealByCategory extends StatefulWidget {
  final String category;

  const MealByCategory({required this.category});

  @override
  MealByCategoryState createState() => MealByCategoryState();
}

class MealByCategoryState extends State<MealByCategory> {
  List meals = [];
  int currentPage = 1;
  final int itemsPerPage = 10;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  // Fetch meals from the API
  Future<void> fetchMeals() async {
    final response = await http
        .get(Uri.parse('${Util.baseUrl}/filter.php?c=${widget.category}'));

    if (response.statusCode == 200) {
      setState(() {
        meals = json.decode(response.body)['meals'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load meals');
    }
  }

  // Get the items for the current page
  List getCurrentPageItems() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return meals.sublist(startIndex, endIndex.clamp(0, meals.length));
  }

  // Change page
  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    List currentMeals = getCurrentPageItems();

    return Scaffold(
      appBar: AppBar(
        title: Text('Meals by ${widget.category}'),
      ),
      body: isLoading
          ? const LoadingWidget()
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      mainAxisSpacing: 10, // vertical space between cards
                      crossAxisSpacing: 10, // horizontal space between cards
                      childAspectRatio: 0.75, // Aspect ratio of each card
                    ),
                    itemCount: currentMeals.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigate to MealDetailsPage when a meal is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MealDetailsPage(
                                id: currentMeals[index]['idMeal'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5, // Add shadow to the card
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Rounded corners
                          ),
                          color: Color.fromARGB(255, 59, 48, 48),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: Image.network(
                                    currentMeals[index]['strMealThumb'],
                                    fit: BoxFit
                                        .cover, // Cover the entire card width
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported,
                                        size: 100,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  currentMeals[index]['strMeal'],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: currentPage > 1
                          ? () => changePage(currentPage - 1)
                          : null,
                      child: const Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: currentPage * itemsPerPage < meals.length
                          ? () => changePage(currentPage + 1)
                          : null,
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
