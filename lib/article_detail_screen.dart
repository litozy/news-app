import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String articleUrl;

  ArticleDetailScreen({required this.articleUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green[800], title: Text('Article Detail')),
      body: WebView(
        initialUrl: Uri.encodeFull(articleUrl),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
