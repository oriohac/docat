import 'package:docat/main.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  const Detail({super.key, required this.pet});
  final Petdata pet;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Image.network('http://127.0.0.1:8000/${pet.petimage}'),
              Text('Pet Type: ${pet.pettype}', style: TextStyle(fontSize: 18)),
              Text('Breed: ${pet.breed}', style: TextStyle(fontSize: 18)),
              Text('Price: ${pet.amount}', style: TextStyle(fontSize: 18)),
              Text('Description: ${pet.description}', style: TextStyle(fontSize: 18)),
              Text('Location: ${pet.location}', style: TextStyle(fontSize: 18)),
              Text('Note: Before Agreeing to pay, make sure you contact owner and physically see the pet.', style: TextStyle(fontWeight: FontWeight.bold),),
              Text('Owner No: ${pet.ownerphone}')
            ],
          ),
        ),
      ),
      ),
    );
  }
}
