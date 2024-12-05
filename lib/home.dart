import 'package:flutter/material.dart';
import 'blog.dart';
import 'login.dart';
import 'report.dart';
import 'news.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Text(
          'Hi, $username!',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCustomCard(
              context,
              assetPath: 'assets/news.png',
              title: 'News',
              subtitle: 'See more of our news',
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => NewsPage()));
              },
            ),
            _buildCustomCard(
              context,
              assetPath: 'assets/blog.png',
              title: 'Blog',
              subtitle: 'See more of our blog',
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => BlogPage()));
              },
            ),
            _buildCustomCard(
              context,
              assetPath: 'assets/report.png',
              title: 'Report',
              subtitle: 'See more of our report',
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ReportPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCard(BuildContext context,
      {required String assetPath,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
              child: Image.asset(
                assetPath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
