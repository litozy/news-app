import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'article_detail_screen.dart';

class NewsArticlesScreen extends StatefulWidget {
  final String category;

  NewsArticlesScreen({required this.category});

  @override
  _NewsArticlesScreenState createState() => _NewsArticlesScreenState();
}

class _NewsArticlesScreenState extends State<NewsArticlesScreen> {
  int currentPage = 1;
  List articles = [];
  bool isLoading = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchArticles(widget.category);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchArticles(widget.category);
      }
    });
  }

  Future<void> fetchArticles(String category) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=id&category=$category&page=$currentPage&pageSize=10&apiKey=6ba0cc4f0ff04deab22482f4b0ef3118'));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        List newArticles = jsonResponse['articles'] ?? [];

        setState(() {
          isLoading = false;
          articles.addAll(newArticles);
          currentPage++;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to load articles: $e"),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> searchNews(String query) async {
    try {
      final apiKey = '6ba0cc4f0ff04deab22482f4b0ef3118';
      final response = await http.get(Uri.parse(
          'https://newsapi.org/v2/everything?qInTitle=$query&apiKey=$apiKey&language=id'));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        List newArticles = jsonResponse['articles'] ?? [];

        setState(() {
          articles = newArticles;
          currentPage = 1;
        });
      } else {
        throw Exception('Failed to search news');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to search news: $e"),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3c096c),
        title: Text('${widget.category}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final selectedQuery = await showSearch(
                context: context,
                delegate: NewsSearchDelegate(),
              );

              if (selectedQuery != null) {
                searchNews(selectedQuery);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: articles.length + 1,
        itemBuilder: (context, index) {
          if (index == articles.length) {
            return isLoading
                ? Center(child: CircularProgressIndicator())
                : TextButton(
                    onPressed: () {
                      fetchArticles(widget.category);
                    },
                    child: Text('Load More'),
                  );
          } else {
            return ListTile(
              title: Text(articles[index]['title']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(
                      articleUrl: articles[index]['url'],
                    ),
                  ),
                );
              },
            );
          }
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
          List<String> titles = snapshot.data ?? [];
          return ListView.builder(
            itemCount: titles.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(titles[index]),
                onTap: () {
                  close(context, titles[index]);
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
        'https://newsapi.org/v2/everything?qInTitle=$query&apiKey=$apiKey&language=id'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      List<String> titles = [];
      for (var article in jsonResponse['articles']) {
        String title = article['title'];
        if (!titles.contains(title)) {
          titles.add(title);
        }
      }
      return titles;
    } else {
      throw Exception('Failed to search news');
    }
  }
}
