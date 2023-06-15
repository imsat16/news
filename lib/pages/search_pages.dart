import 'dart:convert';
import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:news/modules/game_news_list.dart';
import 'package:news/modules/tech_carousel.dart';
import 'package:news/modules/tech_news_list.dart';
import 'package:news/modules/view_all_news.dart';
import 'package:news/pages/detail_pages.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> results = [];
  List<Map<String, dynamic>> getNews = [];

  @override
  void initState() {
    super.initState();
    fetchImageFromAPI();
  }

  void searchData(String query) async {
    // Ganti "API_URL" dengan URL API yang sesuai
    var apiUrl =
        'https://the-lazy-media-api.vercel.app/api/search?search=$query';

    var response = await http.get(Uri.parse(apiUrl));

    // print(json.decode(response.body));
    if (mounted) {
      var data = json.decode(response.body);
      setState(() {
        results = List<Map<String, dynamic>>.from(data);
      });
    }
    print(results.length);
  }

  void handleItemTap(int index) {
    // Aksi yang ingin Anda lakukan ketika pengguna mengetuk item pencarian
    // Misalnya, navigasi ke halaman detail atau tampilan rinci item tertentu
    print('Item tapped: ${results[index]['key']}');
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

  void navigateToDetailPage(int index) {
    String itemId = results[index]['key'].toString();
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

  Future<void> fetchImageFromAPI() async {
    String apiUrl = "https://the-lazy-media-api.vercel.app/api/tech";

    var response = await http.get(Uri.parse(apiUrl));

    if (mounted) {
      setState(() {
        var data = json.decode(response.body);
        // print(json.decode(response.body));
        getNews = List<Map<String, dynamic>>.from(data);
      });
      print(getNews);
    } else {
      print('Failed get data from api');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 10, top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SearchBar(
                            hintText:
                                "Cari berita Teknologi & Game dengan mudah",
                            onChanged: (value) {
                              searchData(value);
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(8.0)),
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.black87,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            onPressed: () {
                              print("anjing");
                            },
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  results.isEmpty
                      ? const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 20.0),
                                  child: Text(
                                    "All News",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 500, child: AllNews()),
                              ],
                            )
                          ],
                        )
                      :
                      // results.isEmpty?const Text("Cari berita terupdate tentang Teknologi & Games"):
                      SizedBox(
                          height: 700,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: ListView.builder(
                              itemCount: results.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Image.network(
                                    results[index]['thumb'].toString(),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(
                                    results[index]['title'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  subtitle:
                                      Text(results[index]['tag'].toString()),
                                  trailing: const Icon(Icons.arrow_forward),
                                  onTap: () {
                                    handleItemTap(index);
                                    navigateToDetailPage(index);
                                  },
                                );
                              },
                            ),
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
