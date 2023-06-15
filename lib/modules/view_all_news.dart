import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/pages/detail_pages.dart';

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

  Future<Map<String, dynamic>> fetchDetailData(String itemId) async {
    final String apiUrl =
        'https://the-lazy-media-api.vercel.app/api/detail/$itemId';

    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch detail data');
    }
  }

  void navigateToDetailPage(String data) {
    String itemId = data.toString();
    print(itemId);
    fetchDetailData(itemId).then(
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

  void navigateToDetail(String item) {
    // String itemId = getNews[i][].toString();
    // print(itemId);
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
                      navigateToDetailPage(combinedData[index]['key']);
                    },
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Image.network(
                            gameData[index]['thumb'],
                            height: 100,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      gameData[index]['title'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.account_circle_rounded,
                                          size: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        gameData[index]['author'],
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 11),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Icon(
                                          Icons.remove,
                                          size: 10,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                      Text(gameData[index]['time'],
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
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
