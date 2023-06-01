import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/detail_pages.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Uri.parse('https://the-lazy-media-api.vercel.app/api/tech');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var fechedData = json.decode(response.body);
      setState(() {
        data = List<Map<String, dynamic>>.from(fechedData);
      });
      print(fetchData());
      print(data);
    } else {
      print('Failed get data from api');
    }
  }

  Future<Map<String, dynamic>> fetchDetailsData(String itemId) async {
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
    String itemId = data[index]['key'].toString();
    print(itemId);
    fetchDetailsData(itemId).then(
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
        print("error sat");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          // var item = data[index];
          return Container(
            child: Column(
              children: [
                ListTile(
                  leading: Image.network(
                    data[index]['thumb'].toString(),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(data[index]['title'].toString()),
                  subtitle: Text(data[index]['author'].toString()),
                  onTap: () {
                    navigateToDetailPage(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
