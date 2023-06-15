import 'package:flutter/material.dart';
import 'package:news/modules/game_news_list.dart';

class GameNewsPage extends StatelessWidget {
  const GameNewsPage({required Key key}) : super(key: key);

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
          "Games News",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: const GameNewsList(),
    );
  }
}
