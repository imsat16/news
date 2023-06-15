import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/pages/detail_pages.dart';

class GameLimitList extends StatefulWidget {
  const GameLimitList({super.key});

  @override
  State<GameLimitList> createState() => _GameLimitListState();
}

class _GameLimitListState extends State<GameLimitList> {
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
    return Column(
      children: gameData.take(3).map((data) {
        return Container(
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
                navigateToDetailPage(data['key']);
              },
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Image.network(
                      data['thumb'],
                      height: 100,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                data['title'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  data['author'],
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 11),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Icon(
                                    Icons.remove,
                                    size: 10,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                Text(
                                  data['time'],
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 11),
                                ),
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
        );
      }).toList(),
    );
  }
}
