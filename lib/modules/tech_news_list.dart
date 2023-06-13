import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TechNewsList extends StatefulWidget {
  const TechNewsList({super.key});

  @override
  State<TechNewsList> createState() => _TechNewsListState();
}

class _TechNewsListState extends State<TechNewsList> {
  List<Map<String, dynamic>> techData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String apiUrl = "https://the-lazy-media-api.vercel.app/api/tech";

    var response = await http.get(Uri.parse(apiUrl));

    if (mounted) {
      setState(() {
        var data = json.decode(response.body);
        techData = List<Map<String, dynamic>>.from(data);
      });
      print(techData);
    } else {
      print('Failed get data from api');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: techData.length,
        itemBuilder: (context, index) {
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
                          Image.network(
                            techData[index]['thumb'],
                            height: 100,
                          ),
                          Flexible(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(techData[index]['title']),
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
        });
  }
}
