import 'package:docat/main.dart';
import 'package:docat/welcomepages.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> textSizeAnimation;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    textSizeAnimation =
        Tween<double>(begin: 8.0, end: 200.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dog = 'lib/images/dogoico.png';
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 4)),
      builder: (context, timer) => timer.connectionState == ConnectionState.done
          ? const Welcomepages()
          : Scaffold(
              backgroundColor: const Color(0xff0367D7),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    // "Welcome to Docat, \n your onestop hub to find pets around you to adopt\n and \nalso post pets for adoption!")
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 12, end: 38),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, value, child) {
                        return Text(
                          'Docat',
                          style: TextStyle(fontSize: value,color: Colors.white,fontWeight: FontWeight.w600, fontFamily: 'Seriff'),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TweenAnimationBuilder(
                        tween: Tween<double>(begin: 200, end: 160),
                        duration: Duration(seconds: 2),
                        builder: (context, value, child) {
                          return ClipOval(
                              child: Image.asset(dog,
                                  height: value, width: value));
                        }),
                    const SizedBox(
                      height: 12,
                    ),
                    
                    const Text(
                      'Your Best Place \nto get pets',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Seriff',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
