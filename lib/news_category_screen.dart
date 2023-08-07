import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsCategoryScreen extends StatefulWidget {
  @override
  _NewsCategoryScreenState createState() => _NewsCategoryScreenState();
}

class _NewsCategoryScreenState extends State<NewsCategoryScreen> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final apiKey = '6ba0cc4f0ff04deab22482f4b0ef3118';
    final response = await http
        .get(Uri.parse('https://newsapi.org/v2/sources?apiKey=$apiKey'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<String> categoriesList = [];
      for (var source in jsonData['sources']) {
        String category = source['category'];
        if (!categoriesList.contains(category)) {
          categoriesList.add(category);
        }
      }
      setState(() {
        categories = categoriesList;
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> searchNews(String query) async {
    final apiKey = '6ba0cc4f0ff04deab22482f4b0ef3118';
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=id&q=$query&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<String> newCategories = [];
      for (var article in jsonResponse['articles']) {
        String category = article['source']['category'];
        if (!newCategories.contains(category)) {
          newCategories.add(category);
        }
      }
      setState(() {
        categories = newCategories;
      });
    } else {
      throw Exception('Failed to search news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('News Categories'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: NewsSearchDelegate());
            },
          ),
        ],
      ),
      body: categories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Center(
                        child: Text(
                          categories[index],
                          style: TextStyle(fontFamily: 'Montserrat'),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/articles',
                            arguments: categories[index]);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class NewsSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _searchNews(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<String> categories = snapshot.data ?? [];
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categories[index]),
                onTap: () {
                  close(context, categories[index]);
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox.shrink();
  }

  Future<List<String>> _searchNews(String query) async {
    final apiKey = '6ba0cc4f0ff04deab22482f4b0ef3118';
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=id&q=$query&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<String> categories = [];
      for (var article in jsonResponse['articles']) {
        String category = article['source']['category'];
        if (!categories.contains(category)) {
          categories.add(category);
        }
      }
      return categories;
    } else {
      throw Exception('Failed to search news');
    }
  }
}
