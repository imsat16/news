import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/detail_pages.dart';

class TechCarousel extends StatefulWidget {
  const TechCarousel({super.key});

  @override
  State<TechCarousel> createState() => _TechCarouselState();
}

class _TechCarouselState extends State<TechCarousel> {
  @override
  void initState() {
    super.initState();
    fetchTechAPI();
  }

  List<Map<String, dynamic>> getTech = [];

  Future<void> fetchTechAPI() async {
    String apiUrl = "https://the-lazy-media-api.vercel.app/api/tech";

    var response = await http.get(Uri.parse(apiUrl));

    if (mounted) {
      setState(() {
        var data = json.decode(response.body);
        // print(json.decode(response.body));
        getTech = List<Map<String, dynamic>>.from(data);
      });
      print(getTech);
    } else {
      print('Failed get data from api');
    }
  }

  void navigateToDetail(String item) {
    // String itemId = getNews[i][].toString();
    // print(itemId);

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
    return 
          CarouselSlider(
            options: CarouselOptions(height: 200.0),
            items: getTech.map(
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
                              Colors
                                  .transparent, // Start with a transparent color
                              Colors.white.withOpacity(
                                  1), // Add the desired gradient color
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
                                    color: Colors.white),
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
