import 'package:flutter/material.dart';

class MorePages extends StatelessWidget {
  const MorePages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Kelompok Mobile Programing'),
          Expanded(
            child: Image.network(
                'https://tse4.mm.bing.net/th?id=OIP.pdOQzGrPZAXTD6lgvPYLLwHaFk&pid=Api&P=0&h=180'),
          ),
          const Text('ALIKA'),
          const Text('NIM : 172131'),
          Expanded(
            child: Image.network(
                'https://tse2.mm.bing.net/th?id=OIP.anboSQA8C3FNtghi512mYAHaIM&pid=Api&P=0&h=180'),
          ),
          const Text('IMAM'),
          const Text('NIM : 171314'),
          Expanded(
            child: Image.network(
                'https://tse4.mm.bing.net/th?id=OIP.QDKGOLoem95oGRz_LjZSIwHaHa&pid=Api&P=0&h=180'),
          ),
          const Text('CHANDRA'),
          const Text('NIM : 171512'),
          Expanded(
            child: Image.network(
                'https://tse4.mm.bing.net/th?id=OIP.b7kOc8za5hMgEvwy6T5USAHaHa&pid=Api&P=0&h=180'),
          ),
          const Text('OGI'),
          const Text('NIM : 176153'),
          Expanded(
            child: Image.network(
                'https://tse3.mm.bing.net/th?id=OIP.yoOiQCLGrgf_J_B-HSif6wHaHa&pid=Api&P=0&h=180'),
          ),
        ],
      ),
    );
  }
}
