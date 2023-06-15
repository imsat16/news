import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailPage({super.key, required this.data});

  List<String> extractImageLinks(List<dynamic> content) {
    RegExp regex = RegExp(
        r'http[s]?://thelazy.media/(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');
    List<String> imageLinks = [];

    for (var item in content) {
      if (item is String) {
        List<String> links =
            regex.allMatches(item).map((match) => match.group(0)!).toList();
        imageLinks.addAll(links);
      }
    }

    return imageLinks;
  }

  @override
  Widget build(BuildContext context) {
    String title = data['results']['title'];
    String author = data['results']['author'];
    String terbit = data['results']['date'];
    List<dynamic> category = data['results']['categories'];
    List<dynamic> content = data['results']['content'];
    List<String> imageLinks = extractImageLinks(content);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black, // <-- SEE HERE
        ),
        title: Text(
          category[0],
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Penulis :",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        author,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  Text(
                    terbit,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              for (var index = 0; index < content.length; index++)
                if (content[index] is String &&
                    imageLinks.contains(content[index]))
                  Image.network(content[index])
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      content[index],
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
              if (imageLinks.isEmpty && content.isEmpty)
                const Center(
                  child: Text(
                    'Data tidak tersedia',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
