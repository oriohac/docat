import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:docat/Profile.dart';
import 'package:docat/Signup.dart';
import 'package:docat/create.dart';
import 'package:docat/detail.dart';
import 'package:docat/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MaterialApp(routes: {
      '/create': (context) => const Create(),
      '/login': (context) => const Login(),
      '/signup': (context) => const Signup(),
      '/profile': (context) => const Profile(),
      '/home': (context) => const Docat(),
    }, debugShowCheckedModeBanner: false, home: const Docat()),
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
      location: json['location'] as String,
    );
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

  Future<void> goProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      Navigator.pushNamed(context, '/login');
    } else {
      Navigator.pushNamed(context, '/profile');
    }
  }

  Future<void> goCreate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      Navigator.pushNamed(context, '/login');
    } else {
      Navigator.pushNamed(context, '/create');
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          const Spacer(),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                goProfile();
              },
              child: ClipOval(
                  child: Image.asset(
                'lib/images/default.jpg',
                width: 48,
                height: 48,
              )),
            ),
          )
        ],
      ),
      drawer: Drawer(
        width: screenWidth / 1.5,
        child: ListView(
          children: [
            DrawerHeader(
                child: ListView(
              children: [
                const ListTile(
                  leading: Icon(Icons.pets),
                  title: Text('DOCAT'),
                )
              ],
            )),
            GestureDetector(
              onTap: () => goProfile(),
              child: const ListTile(
                leading: Icon(Icons.person),
                title: Text('PROFILE'),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.logout),
              title: Text('LOGOUT'),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 6, 4, 2),
              child: Row(
                children: [
                  const Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        hintText: 'Search...',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        goCreate();
                      },
                      child: const ClipOval(
                          child: Icon(
                        Icons.add_circle_outline,
                        size: 50,
                      )),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: FutureBuilder<List<Petdata>>(
              future: pet,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ClipOval(
                                  child: Image.network(
                                      'http://127.0.0.1:8000/${snapshot.data![index].petimage}',
                                      fit: BoxFit.cover,
                                      height: 60,
                                      width: 60)),
                            )
                          ],
                        );
                      });
                } else {
                  throw Exception('No image retrieved');
                }
              },
            )),
            Expanded(
              flex: 4,
              child: FutureBuilder<List<Petdata>>(
                  future: pet,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 4, 4, 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Image.network(
                                                  'http://127.0.0.1:8000/${snapshot.data![index].petimage}'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Text('Pet Type: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                            snapshot.data![index].pettype,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("Breed: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(snapshot.data![index].breed),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("Price: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text('₦${snapshot.data![index].amount}'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            snapshot.data![index].description,
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                          )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("Location: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(snapshot.data![index].location),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Detail(
                                                                pet: snapshot
                                                                        .data![
                                                                    index])));
                                              },
                                              child: const Text("Details")),
                                          const Spacer(),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          2)))),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Detail(
                                                                pet: snapshot
                                                                        .data![
                                                                    index])));
                                              },
                                              child: const Text("Adopt")),
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
            ),
          ],
        ),
      ),
    );
  }
}
