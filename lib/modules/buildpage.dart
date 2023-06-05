import 'package:flutter/material.dart';

class BuildPage extends StatelessWidget {


  final String urlImage;
  final String title;
  final String subtitle;

  const BuildPage({super.key,  required this.urlImage,required this.title, required this.subtitle });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
       mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            urlImage,
            width: 250,
            height: 200,
          ),
    
          const SizedBox(height: 30,),
    
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
    
          const SizedBox(height: 30,),
    
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    ); }}
