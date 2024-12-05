import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ReportDetailPage extends StatefulWidget {
  final int reportId;

  ReportDetailPage({required this.reportId});

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  Map report = {};

  @override
  void initState() {
    super.initState();
    _fetchReportDetail();
  }

  Future<void> _fetchReportDetail() async {
    final response = await http.get(
      Uri.parse(
          'https://api.spaceflightnewsapi.net/v4/reports/${widget.reportId}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        report = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load report details');
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
        title: Text(report['title'] ?? 'Loading...'),
      ),
      body: report.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    report['image_url'] ?? '',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),
                  Text(
                    report['title'] ?? '',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    report['published_at'] ?? '',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    report['summary'] ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}