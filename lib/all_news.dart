import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/detail_pages.dart';

class AllNewsPage extends StatelessWidget {
  const AllNewsPage({required Key key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchData() async {
    String techApiUrl = "https://the-lazy-media-api.vercel.app/api/tech";
    String gameApiUrl = "https://the-lazy-media-api.vercel.app/api/games";

    var techResponse = await http.get(Uri.parse(techApiUrl));
    var gameResponse = await http.get(Uri.parse(gameApiUrl));

    if (techResponse.statusCode == 200 && gameResponse.statusCode == 200) {
      var techDataJson = json.decode(techResponse.body);
      var gameDataJson = json.decode(gameResponse.body);

      List<Map<String, dynamic>> techData =
          List<Map<String, dynamic>>.from(techDataJson);
      List<Map<String, dynamic>> gameData =
          List<Map<String, dynamic>>.from(gameDataJson);

      List<Map<String, dynamic>> combinedData = [
        ...techData, // Batasan jumlah data menjadi 5 dari endpoint pertama
        ...gameData, // Batasan jumlah data menjadi 5 dari endpoint kedua
      ];

      return combinedData;
    } else {
      throw Exception('Failed to get data from API');
    }
  }

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

  void navigateToDetail(BuildContext context, String item) {
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
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "All News",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load data'));
          } else {
            List<Map<String, dynamic>> combinedData = snapshot.data;
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
                            navigateToDetail(
                                context, combinedData[index]['id'].toString());
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
