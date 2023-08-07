import 'package:flutter/material.dart';
import 'news_category_screen.dart';
import 'news_articles_screen.dart';
import 'article_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      initialRoute: '/',
      routes: {
        '/': (context) => NewsCategoryScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/articles') {
          final category = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => NewsArticlesScreen(category: category),
          );
        } else if (settings.name == '/articleDetail') {
          final articleUrl = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(articleUrl: articleUrl),
          );
        }
        // Handle other named routes if needed
        return null;
      },
    );
  }
}
