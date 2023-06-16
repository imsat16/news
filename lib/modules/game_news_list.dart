import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/pages/detail_pages.dart';

class GameNewsList extends StatefulWidget {
  const GameNewsList({super.key});

  @override
  State<GameNewsList> createState() => _GameNewsListState();
}

class _GameNewsListState extends State<GameNewsList> {
  List<Map<String, dynamic>> results = [];
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
    return ListView.builder(
        itemCount: gameData.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      navigateToDetailPage(gameData[index]['key']);
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
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Text(
                                        gameData[index]['title'],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.bold),
                                      ),
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
