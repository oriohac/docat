import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
                child: Row(children: [
                  Text('firstname surname'),
                  Spacer(),
                  ClipOval(
                    child: Image.asset('lib/images/default.jpg',fit: BoxFit.cover,height: 40, width: 40,)
                    ),
                ],),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/home");
                  },
                  child: const Text('Home'))
            ],
          ),
        ),
      ),
    );
  }
}
