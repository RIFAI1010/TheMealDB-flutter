import 'package:flutter/material.dart';
import 'package:meal_api/mealsByCategory.dart';
import 'package:meal_api/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meal_api/widget/navbar.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  // Fetch categories from the API
  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('${Util.baseUrl}/categories.php'));

    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body)['categories'];
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(
                    category['strCategory'],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  leading: Image.network(
                    category['strCategoryThumb'],
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 150);
                    },
                  ),
                  subtitle: Text(
                    category['strCategoryDescription'],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () {
                    // Navigate to ItemsByCategory when a category is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealByCategory(
                          category: category['strCategory'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      // bottomNavigationBar: const NavbarWidget(),
    );
  }
}
