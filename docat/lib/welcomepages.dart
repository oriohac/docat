import 'package:flutter/material.dart';

class Welcomepages extends StatefulWidget {
  const Welcomepages({super.key});

  @override
  State<Welcomepages> createState() => _WelcomepagesState();
}

class _WelcomepagesState extends State<Welcomepages> {
  PageController pageController = PageController(initialPage: 0);
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                children: [
                  _buildPage(text: 'thie sjdu that'),
                  _buildPage1(text: 'Min who san fram mia'),
                  _buildPage2(text: 'quagularela insigne cardoxo lakaka')
                ],
              ),
            ),
            _buildPageIndicator()
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required String text}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Handle button press
              },
              child: const Text(
                'Archive',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1({required String text}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Handle button press
              },
              child: const Text(
                'Archive',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage2({required String text}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: const Text(
                'Archive',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIndicator(isActive: true),
          _buildIndicator(isActive: false),
          _buildIndicator(isActive: false),
        ],
      ),
    );
  }

  Widget _buildIndicator({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.grey, shape: BoxShape.circle),
    );
  }
}
