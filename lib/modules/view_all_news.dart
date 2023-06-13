import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/detail_pages.dart';

class AllNews extends StatefulWidget {
  const AllNews({super.key});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<Map<String, dynamic>> techData = [];
  List<Map<String, dynamic>> gameData = [];

  Future<void> fetchData() async {
    String techApiUrl = "https://the-lazy-media-api.vercel.app/api/tech";
    String gameApiUrl = "https://the-lazy-media-api.vercel.app/api/games";

    var techResponse = await http.get(Uri.parse(techApiUrl));
    var gameResponse = await http.get(Uri.parse(gameApiUrl));

    if (mounted) {
      setState(() {
        var techDataJson = json.decode(techResponse.body);
        var gameDataJson = json.decode(gameResponse.body);
        techData = List<Map<String, dynamic>>.from(techDataJson);
        gameData = List<Map<String, dynamic>>.from(gameDataJson);
      });
    } else {
      print('Failed to get data from API');
    }
  }

  void navigateToDetail(String item) {
    Future<Map<String, dynamic>> fetchDetailData(String itemId) async {
      final String apiUrl =
          'https://the-lazy-media-api.vercel.app/api/detail/$itemId';

      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch detail data');
      }
    }

    fetchDetailData(item).then(
      (detailData) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(data: detailData),
          ),
        );
      },
    ).catchError(
      (error) {
        print("error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> combinedData = [
      ...techData
          .take(5), // Batasan jumlah data menjadi 5 dari endpoint pertama
      ...gameData.take(5), // Batasan jumlah data menjadi 5 dari endpoint kedua
    ];
    return ListView.builder(
        itemCount: combinedData.length,
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
                            combinedData[index]['thumb'],
                            height: 100,
                          ),
                          Flexible(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(combinedData[index]['title']),
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
