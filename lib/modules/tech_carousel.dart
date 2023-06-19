import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/pages/detail_pages.dart';

class TechCarousel extends StatefulWidget {
  const TechCarousel({Key? key});

  @override
  State<TechCarousel> createState() => _TechCarouselState();
}

class _TechCarouselState extends State<TechCarousel> {
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

    return combinedData.isEmpty ? 
      Center(
        child: AspectRatio(
        aspectRatio: 16/9,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
        ),
           ),
      )
    : CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      items: combinedData.map(
        (i) {
          return Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  print(i['key']);
                  navigateToDetail(i['key']);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: i['thumb'] != 'noImage'
                          ? NetworkImage(i['thumb'])
                          : const AssetImage('assets/images/slide1.png')
                              as ImageProvider,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          i['title'],
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ).toList(),
    );
  }
}
