import 'package:flutter/material.dart';

void main() => runApp(const TryPages());

class TryPages extends StatelessWidget {
  const TryPages({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Monyet'),
            Expanded(
            child:  Image.network('https://tse2.mm.bing.net/th?id=OIP.oHuJ6HFOuSpg00ZQwB1lIgHaE8&pid=Api&P=0&h=180'),
            ),
            const Text('D'),

            Expanded(
            child: Image.network('https://tse4.mm.bing.net/th?id=OIP.8o2qvLl86neYTfZGXVGgNwHaEo&pid=Api&P=0&h=180'),
            ),
            
            const Text('jancok'),
            Expanded(
            child: Image.network('https://tse2.mm.bing.net/th?id=OIP.fy2NmYZpjQrC36KM2p0y7wAAAA&pid=Api&P=0&h=180'),
            ),
          ],
        )),
      ),
    );
  }
}
