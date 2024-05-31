import 'dart:convert';

import 'package:docat/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Future<Petdata> getDetail() async{
    final response = await http.get(Uri.parse("http://127.0.0.1/detail/"));

    if (response.statusCode == 200) {
      return Petdata.fromJson(jsonDecode(response.body));
     
    } else {
      throw Exception("Not Retrieved");
    }
  }
  late Future<Petdata> pet;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pet = getDetail();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: pet, 
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if(snapshot.hasData){
              return Column(
                children: [
                   Card(
                                  margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  elevation: 2.0,
                                  color:
                                      const Color.fromARGB(255, 244, 248, 244),
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
                                                      'http://127.0.0.1:8000/${snapshot.data!.petimage}'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Text('Pet Type: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                snapshot.data!.pettype,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text("Breed: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(snapshot.data!.breed),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text("Price: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  snapshot.data!.amount),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                snapshot
                                                    .data!.description,
                                                overflow: TextOverflow.visible,
                                              )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text("Location: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(snapshot
                                                  .data!.location),
                                            ],
                                          ),
                                         
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                ],
              );
            }else{
              throw Exception('${snapshot.error} Check all parts of your code');
            }
        }),
      ),
    );
  }
}