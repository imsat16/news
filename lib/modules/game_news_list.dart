import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GameNewsList extends StatefulWidget {
  const GameNewsList({super.key});

  @override
  State<GameNewsList> createState() => _GameNewsListState();
}

class _GameNewsListState extends State<GameNewsList> {
  List<Map<String, dynamic>> gameData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String apiUrl = "https://the-lazy-media-api.vercel.app/api/games";

    var response = await http.get(Uri.parse(apiUrl));

    if (mounted) {
      setState(() {
        var data = json.decode(response.body);
        gameData = List<Map<String, dynamic>>.from(data);
      });
      print(gameData);
    } else {
      print('Failed get data from api');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: gameData.length,
        itemBuilder: (context, index){
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    debugPrint('Card tapped.');
                  },
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        Image.network(gameData[index]['thumb'], height: 100,),
                        Flexible(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(gameData[index]['title']),
                        )),
                      ],
                    ),
                  ),
                ),
                ),
              )
              // Image.network(gameData[index]['thumb'])
            ],
          );
        }
    );
  }
}