import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/modules/tech_news_list.dart';

class TechListPage extends StatelessWidget {
  const TechListPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Tech News",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(child: const TechNewsList()),
    );
  }
}
