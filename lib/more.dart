import 'package:flutter/material.dart';

class MorePages extends StatelessWidget {
  const MorePages({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Anggota Kapal Laut',
              style: TextStyle( fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
          Image.network('https://tse4.mm.bing.net/th?id=OIP.pdOQzGrPZAXTD6lgvPYLLwHaFk&pid=Api&P=0&h=160'),
          Row(
            children: [
              Image.network('https://tse2.mm.bing.net/th?id=OIP.anboSQA8C3FNtghi512mYAHaIM&pid=Api&P=0&h=90'),
              const SizedBox(width: 10,),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ALIKA KHANSA FADILA'),
                  Text('NIM : 172131'),
                ],
              )
            ],
          ),
              const SizedBox(height: 10,),
          Row(
            children: [
              Image.network('https://tse4.mm.bing.net/th?id=OIP.QDKGOLoem95oGRz_LjZSIwHaHa&pid=Api&P=0&h=90'),
              const SizedBox(width: 10,),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('IMAM SATRIO PRAKOSO'),
                  Text('NIM : 17214034'),
                ],
              )
            ],
          ),
              const SizedBox(height: 10,),
          Row(
            children: [
              Image.network('https://tse4.mm.bing.net/th?id=OIP.b7kOc8za5hMgEvwy6T5USAHaHa&pid=Api&P=0&h=90'),
              const SizedBox(width: 10,),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CANDRA PURNAMA ALAM'),
                  Text('NIM : 171314'),
                ],
              )
            ],
          ),
              const SizedBox(height: 10,),
          Row(
            children: [
              Image.network('https://tse3.mm.bing.net/th?id=OIP.yoOiQCLGrgf_J_B-HSif6wHaHa&pid=Api&P=0&h=90'),
              const SizedBox(width: 10,),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OGI RAHMANSYAH'),
                  Text('NIM : 171314'),
                ],
              )
            ],
          ),
        ],
          ),
        ),
      ),
    );
  }
}
