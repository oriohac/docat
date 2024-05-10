import 'dart:convert';

import 'package:docat/create.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    const Docat(),
  );
}

class Petdata {
  final String petimage;
  final String pettype;
  final String breed;
  final String amount;
  final String description;
  final String location;
  Petdata(
      {required this.pettype,
      required this.breed,
      required this.amount,
      required this.description,
      required this.petimage,
      required this.location});
  factory Petdata.fromJson(dynamic json) {
    return Petdata(
        pettype: json['pettype'] as String,
        breed: json['breed'] as String,
        amount: json['amount'] as String,
        description: json['description'] as String,
        petimage: json['petimage'] as String,
        location: json['location'] as String);
  }
}

class Docat extends StatefulWidget {
  const Docat({super.key});

  @override
  State<Docat> createState() => _DocatState();
}

class _DocatState extends State<Docat> {
  Future<List<Petdata>> getPetdata() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/list/'));
    if (response.statusCode == 200) {
      List<dynamic> petAPI = jsonDecode(response.body);
      List<Petdata> petModelData =
          petAPI.map((json) => Petdata.fromJson(json)).toList();
      return petModelData;
    } else {
      throw Exception("error: could not retrieve data!!!");
    }
  }

  late Future<List<Petdata>> pet;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pet = getPetdata();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/create':(context) => const Create()},
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
        child: FutureBuilder<List<Petdata>>(
            future: pet,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                          margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        elevation: 2.0,
                        color: const Color.fromARGB(255, 244, 248, 244),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Image.network('http://127.0.0.1:8000' +
                                            snapshot.data![index].petimage),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text('Pet Type: ',style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(snapshot.data![index].pettype, textAlign: TextAlign.start,style: const TextStyle(),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Breed: ",style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(snapshot.data![index].breed),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Price: ",style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(snapshot.data![index].amount),
                                  ],
                                ),
                                Row(
                                  children: [

                                    Expanded(child: Text(snapshot.data![index].description, maxLines: 2, overflow: TextOverflow.fade,)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Location: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(snapshot.data![index].location),
                                  ],
                                ),
                                Row(
                                  children: [
                                    TextButton(onPressed: (){}, child: const Text("Details")),
                                    const Spacer(),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2)))
                                      ),
                                      onPressed: (){
                                      Navigator.pushNamed(context, '/create');
                                    }, child: const Text("Adopt")),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                throw Exception(
                    ' ${snapshot.error} Check all parts of your code oga');
              }
            }),
      )),
    );
  }
}
