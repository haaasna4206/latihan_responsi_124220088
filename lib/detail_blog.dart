import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class BlogDetailPage extends StatefulWidget {
  final int blogId;

  BlogDetailPage({required this.blogId});

  @override
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  Map blog = {};

  @override
  void initState() {
    super.initState();
    _fetchBlogDetail();
  }

  Future<void> _fetchBlogDetail() async {
    final response = await http.get(
      Uri.parse(
          'https://api.spaceflightnewsapi.net/v4/blogs/${widget.blogId}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        blog = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load blog details');
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog['title'] ?? 'Loading...'),
      ),
      body: blog.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    blog['image_url'] ?? '',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),
                  Text(
                    blog['title'] ?? '',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    blog['published_at'] ?? '',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    blog['summary'] ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}