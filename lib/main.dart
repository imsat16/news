import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news/pages/homePage.dart';
import 'package:news/modules/onboarding.dart';
import 'package:news/pages/morePage.dart';
import 'package:news/pages/search_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            color: Colors.black87,
            foregroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
          ),
          primarySwatch: Colors.blue,
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Colors.black)),
      //home: const BottNav(title: 'T&G News'),
      //  home: const GameNewsList(),
      home: const OnBoarding(),
    );
  }
}

class BottNav extends StatefulWidget {
  const BottNav({super.key, required this.title});

  final String title;

  @override
  State<BottNav> createState() => _BottNavState();
}

class _BottNavState extends State<BottNav> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePages(),
    SearchPage(),
    MorePages(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, // <-- SEE HERE
          ),
          centerTitle: true,
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Lainnya',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black87,
        onTap: _onItemTapped,
      ),
    );
  }
}
