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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('${widget.category} News'),
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
