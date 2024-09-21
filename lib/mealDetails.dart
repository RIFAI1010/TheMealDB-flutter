import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meal_api/mealsByCategory.dart';
import 'package:meal_api/mealsByIngredient.dart';
import 'package:meal_api/widget/loading.dart';
import 'package:meal_api/widget/notfound.dart';

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
      home: MealDetailsPage(
        id: '53085',
      ),
    );
  }
}

class MealDetailsPage extends StatefulWidget {
  final String id;

  const MealDetailsPage({required this.id});

  @override
  _MealDetailsPageState createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  Map<String, dynamic>? meal;
  bool isLoading = true;
  bool notFound = false;

  @override
  void initState() {
    super.initState();
    fetchMeal();
  }

  Future<void> fetchMeal() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.id}'));

    if (response.statusCode == 200) {
      try {
        setState(() {
          meal = json.decode(response.body)['meals'][0];
          isLoading = false;
          notFound = false;
        });
      } catch (e) {
        setState(() {
          notFound = true;
          isLoading = false;
        });
        print('not found');
        // throw Exception('not found');
      }
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Details'),
      ),
      body: notFound
          ? NotfoundWidget()
          : isLoading
              ? const LoadingWidget()
              : meal != null
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.network(
                                meal!['strMealThumb'],
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported,
                                      size: 150);
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              meal!['strMeal'],
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            // Text('Category: ${meal!['strCategory']}'),
                            Row(
                              children: [
                                SizedBox(width: 8),
                                Text(
                                  "Category: ",
                                ),
                                InkWell(
                                  onTap: () {
                                    // Navigate ke halaman browse berdasarkan kode negara
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MealByCategory(
                                            category: meal!['strCategory']),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "${meal!['strCategory']}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Spacer(),
                                _buildCountryTag(meal!['strArea']),
                                SizedBox(width: 8),
                              ],
                            ),
                            // SizedBox(height: 8),
                            // _buildCountryTag(meal!['strArea']),
                            SizedBox(height: 16),
                            Text('Ingredients:',
                                style: TextStyle(fontSize: 18)),
                            SizedBox(height: 8),
                            _buildIngredientsList(),
                            SizedBox(height: 16),
                            Text('Instructions:',
                                style: TextStyle(fontSize: 18)),
                            SizedBox(height: 8),
                            Text(meal!['strInstructions'] ?? ''),
                          ],
                        ),
                      ),
                    )
                  : Center(child: Text('No meal found')),
    );
  }

  Widget _buildCountryTag(String country) {
    // Map negara ke kode negara
    final countryCodes = {
      "American": "US",
      "British": "GB",
      "Canadian": "CA",
      "Chinese": "CN",
      "Dutch": "NL",
      "Egyptian": "EG",
      "French": "FR",
      "Greek": "GR",
      "Indian": "IN",
      "Irish": "IE",
      "Italian": "IT",
      "Jamaican": "JM",
      "Japanese": "JP",
      "Kenyan": "KE",
      "Malaysian": "MY",
      "Mexican": "MX",
      "Moroccan": "MA",
      "Polish": "PL",
      "Portuguese": "PT",
      "Russian": "RU",
      "Spanish": "ES",
      "Thai": "TH",
      "Tunisian": "TN",
      "Turkish": "TR",
      "Vietnamese": "VN"
    };

    final countryCode = countryCodes[country] ?? 'US';

    return Row(
      children: [
        Image.network(
          'https://www.themealdb.com/images/icons/flags/big/32/$countryCode.png',
          width: 30,
          height: 20,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image_not_supported, size: 150);
          },
        ),
        SizedBox(width: 8),
        InkWell(
          onTap: () {
            // Navigate ke halaman browse berdasarkan kode negara
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BrowseAreaPage(countryCode),
              ),
            );
          },
          child: Text(
            country,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsList() {
    final ingredients = <Widget>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = meal!['strIngredient$i'];
      final measure = meal!['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
        final imageUrl =
            'https://www.themealdb.com/images/ingredients/$ingredient.png';

        ingredients.add(ListTile(
          tileColor: Color.fromARGB(255, 121, 87, 87),
          leading: Image.network(
            imageUrl,
            width: 50,
            height: 50,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image_not_supported, size: 150);
            },
          ),
          title: Text(
            '$measure $ingredient',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          onTap: () {
            // Navigate ke halaman ingredient berdasarkan nama
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealsByIngredient(ingredient: ingredient),
              ),
            );
          },
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients,
    );
  }
}

// Halaman BrowseAreaPage untuk negara tertentu
class BrowseAreaPage extends StatelessWidget {
  final String countryCode;

  BrowseAreaPage(this.countryCode);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse by $countryCode'),
      ),
      body: Center(
        child: Text('Showing meals from $countryCode'),
      ),
    );
  }
}

// Halaman IngredientDetailsPage untuk ingredient tertentu
class IngredientDetailsPage extends StatelessWidget {
  final String ingredientName;

  IngredientDetailsPage(this.ingredientName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ingredientName),
      ),
      body: Center(
        child: Text('Details for $ingredientName'),
      ),
    );
  }
}
