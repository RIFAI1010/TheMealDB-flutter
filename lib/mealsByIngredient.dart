import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meal_api/mealDetails.dart';
import 'package:meal_api/widget/loading.dart';
import 'package:meal_api/widget/notfound.dart';

class MealsByIngredient extends StatefulWidget {
  final String ingredient;

  const MealsByIngredient({required this.ingredient});

  @override
  _MealsByIngredientState createState() => _MealsByIngredientState();
}

class _MealsByIngredientState extends State<MealsByIngredient> {
  List meals = [];
  bool isLoading = true;
  bool notFound = false;

  @override
  void initState() {
    super.initState();
    fetchMealsByIngredient();
  }

  // Fetch meals by ingredient from the API
  Future<void> fetchMealsByIngredient() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?i=${widget.ingredient}'));

    if (response.statusCode == 200) {
      try {
        setState(() {
          meals = json.decode(response.body)['meals'];
          isLoading = false;
          notFound = false;
        });
      } catch (e) {
        setState(() {
          notFound = true;
          isLoading = false;
        });

        print('not found');
      }
    } else {
      throw Exception('Failed to load meals');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals with ${widget.ingredient}'),
      ),
      body: notFound
          ? NotfoundWidget()
          : isLoading
              ? const LoadingWidget()
              : Column(
                  children: [
                    // Display ingredient name and placeholder image
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Display an image for the ingredient (placeholder or a custom image)
                          Image.network(
                            'https://www.themealdb.com/images/ingredients/${widget.ingredient}.png',
                            height: 90,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  size: 90);
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.ingredient.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    // Display list of meals below the ingredient details
                    // Expanded(
                    //   child: ListView.builder(
                    //     itemCount: meals.length,
                    //     itemBuilder: (context, index) {
                    //       return Card(
                    //         elevation: 5, // Tambahkan efek bayangan pada card
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius:
                    //               BorderRadius.circular(15), // Sudut membulat
                    //         ),
                    //         color: Color.fromARGB(255, 59, 48, 48),

                    //         margin: const EdgeInsets.symmetric(
                    //             vertical: 8,
                    //             horizontal: 16), // Margin antar card
                    //         child: ListTile(
                    //           title: Text(
                    //             meals[index]['strMeal'],
                    //             style: Theme.of(context).textTheme.bodyLarge,
                    //           ),
                    //           leading: ClipRRect(
                    //             borderRadius: BorderRadius.circular(
                    //                 10), // Membulatkan gambar
                    //             child: Image.network(
                    //               meals[index]['strMealThumb'],
                    //               errorBuilder: (context, error, stackTrace) {
                    //                 return const Icon(Icons.image_not_supported,
                    //                     size: 150);
                    //               },
                    //             ),
                    //           ),
                    //           onTap: () {
                    //             // Navigasi ke halaman detail meal saat ditekan
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) => MealDetailsPage(
                    //                   id: meals[index]['idMeal'],
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 items per row
                          mainAxisSpacing: 10, // vertical space between cards
                          crossAxisSpacing:
                              10, // horizontal space between cards
                          childAspectRatio: 0.75, // Aspect ratio of each card
                        ),
                        itemCount: meals.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Navigate to MealDetailsPage when a meal is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MealDetailsPage(
                                    id: meals[index]['idMeal'],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 5, // Add shadow to the card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Rounded corners
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
                                        meals[index]['strMealThumb'],
                                        fit: BoxFit
                                            .cover, // Cover the entire card width
                                        errorBuilder:
                                            (context, error, stackTrace) {
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
                                      meals[index]['strMeal'],
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
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
                  ],
                ),
    );
  }
}
