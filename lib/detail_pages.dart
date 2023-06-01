// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class DetailPage extends StatelessWidget {
//   final Map<String, dynamic> data;

//   const DetailPage({super.key, required this.data});

//   List<String> extractImageLinks(String text) {
//     RegExp regex = RegExp(
//         r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');
//     List<String> imageLinks =
//         regex.allMatches(text).map((match) => match.group(0)!).toList();
//     return imageLinks;
//   }

//   Future<Map<String, dynamic>> fetchDetailData(String key) async {
//     final String apiUrl =
//         'https://the-lazy-media-api.vercel.app/api/detail/$key';

//     var response = await http.get(Uri.parse(apiUrl));
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to fetch detail data');
//     }
//   }

//   String? findImageLink(List<dynamic> content) {
//     for (var item in content) {
//       if (item is String && item.startsWith('https://thelazy.media')) {
//         return item;
//       }
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print({"anjing", data['results']['content'].length});
//     List<dynamic> content = data['results']['content'];
//     List<String> imageLinks = [];

//     for (var item in content) {
//       if (item is String) {
//         List<String> links = extractImageLinks(item);
//         imageLinks.addAll(links);
//       }
//     }

//     print(content);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Detail Page'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             if (data['results']['thumb'] != null)
//               Image.network(data['results']['thumb']
//                   // data.isNotEmpty ? data[0]['thumb']:''
//                   )
//             else
//               const Text(""),
//             Text(
//               data['results']['title'].toString(),
//               style: const TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10.0),
//             Text(
//               data['results']['author'].toString(),
//               style: const TextStyle(
//                 fontSize: 16.0,
//               ),
//             ),
//             for (var link in imageLinks) Image.network(link),
//             const SizedBox(height: 10.0),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ListView.builder(
//                   itemCount: content.length,
//                   itemBuilder: (context, index) {
//                     if (content[index] is String &&
//                         !imageLinks.contains(content[index])) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: Text(
//                           content[index],
//                           style: const TextStyle(fontSize: 16.0),
//                         ),
//                       );
//                     } else {
//                       return const SizedBox.shrink();
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
        List<String> links = regex.allMatches(item).map((match) => match.group(0)!).toList();
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
    List<dynamic> content = data['results']['content'];
    List<String> imageLinks = extractImageLinks(content);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech & Game News App', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Penulis :", 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        author, 
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  Text(
                    terbit, 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              for (var index = 0; index < content.length; index++) 
                if (content[index] is String && imageLinks.contains(content[index]))
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
