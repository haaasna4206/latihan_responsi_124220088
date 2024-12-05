import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsDetailPage extends StatefulWidget {
  final int articleId;

  NewsDetailPage({required this.articleId});

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  Map article = {};

  @override
  void initState() {
    super.initState();
    _fetchArticleDetail();
  }

  Future<void> _fetchArticleDetail() async {
    final response = await http.get(
      Uri.parse(
          'https://api.spaceflightnewsapi.net/v4/articles/${widget.articleId}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        article = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load article');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article['title'] ?? 'Loading...')),
      body: article.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    article['image_url'] ?? '',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),
                  Text(
                    article['title'] ?? '',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(article['published_at'] ?? '',
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 16),
                  Text(
                    article['summary'] ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}