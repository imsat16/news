import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:news/modules/game_news_list.dart';
import 'package:news/modules/tech_news_list.dart';
import 'package:news/modules/view_all_news.dart';
import 'package:news/pages/detail_pages.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> results = [];
  List<Map<String, dynamic>> getNews = [];

  int _selectedIndex = 0;
  List<Widget> _pages = [
    const AllNews(),
    const TechNewsList(),
    const GameNewsList(),
  ];

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
          child: Column(
            children: [
              ClipPath(
                clipper: BackgroundWaveClipper(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 285,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 54, 176, 247),
                        Color.fromARGB(255, 54, 93, 116)
                      ],
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Discover",
                                  style: TextStyle(
                                      fontSize: 50,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Tech And Games News from all around the world",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText:
                                  "Cari berita Teknologi & Game dengan mudah",
                              hintStyle: const TextStyle(fontSize: 15),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              prefixIcon: const Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              searchData(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: results.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 100.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ChoiceChip(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  label: const Text(
                                    'All',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 54, 176, 247),
                                  selectedColor:
                                      Color.fromARGB(255, 54, 93, 116),
                                  selected: _selectedIndex == 0,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedIndex =
                                          selected ? 0 : _selectedIndex;
                                    });
                                  },
                                ),
                                ChoiceChip(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  label: const Text(
                                    'Technology',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 54, 176, 247),
                                  selectedColor:
                                      Color.fromARGB(255, 54, 93, 116),
                                  selected: _selectedIndex == 1,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedIndex =
                                          selected ? 1 : _selectedIndex;
                                    });
                                  },
                                ),
                                ChoiceChip(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  label: const Text(
                                    'Games',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 54, 176, 247),
                                  selectedColor:
                                      Color.fromARGB(255, 54, 93, 116),
                                  selected: _selectedIndex == 2,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedIndex =
                                          selected ? 2 : _selectedIndex;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: IndexedStack(
                              index: _selectedIndex,
                              children: _pages,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 600,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
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
                                    fontSize: 12.5,
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
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackgroundWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    final p0 = size.height * 0.75;
    path.lineTo(0.10, p0);

    final controlPoint = Offset(size.width * 0.20, size.height);
    final endPoint = Offset(size.width, size.height / 1);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BackgroundWaveClipper oldClipper) => oldClipper != this;
}
