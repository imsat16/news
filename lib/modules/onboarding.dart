import 'package:flutter/material.dart';
import 'package:news/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news/modules/buildpage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<StatefulWidget> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  String urlImage = '';
  String title = '';
  String subtitle = '';
  final controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: const [
            BuildPage(
              urlImage: 'assets/images/slide1.png',
              title: 'Stay in the Know with Ready To Read The News',
              subtitle: 'Select the Trendiest Technology and Gaming Updates!',
            ),
            BuildPage(
              urlImage: 'assets/images/slide2.png',
              title: 'Stay Ahead with Ready To Read The News',
              subtitle:
                  'Choose the Cutting-Edge Updates on Technology and Gaming!',
            ),
            BuildPage(
              urlImage: 'assets/images/slide3.png',
              title: 'Ready To Read The News',
              subtitle: 'Handpick the Hottest News on Technology and Gaming!',
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, 
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: () async {
                //navigate to choose page
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showChoose', true);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const BottNav(title: 'T&G News')),
                );
              },
              child: const Text(
                'Get Started',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //skip
                  TextButton(
                    onPressed: () => controller.jumpToPage(2),
                    child: const Text(
                      'SKIP',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  //dots
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: const WormEffect(
                        spacing: 20,
                        dotColor: Colors.black26,
                        activeDotColor: Colors.black87,
                      ),
                      //to click on dots and move
                      onDotClicked: (index) => controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      ),
                    ),
                  ),
                  //next
                  TextButton(
                      onPressed: () => controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          ),
                      child: const Text(
                        'NEXT',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}
