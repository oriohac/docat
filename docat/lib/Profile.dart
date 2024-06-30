import 'dart:convert';

import 'package:docat/main.dart';
import 'package:docat/updatepet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProfile {
  final String firstname;
  final String lastname;
  final String username;
  final String email;
  final String phone;
  UserProfile({
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.phone,
  });
  factory UserProfile.fromJson(dynamic json) {
    return UserProfile(
        firstname: json['first_name'] as String,
        lastname: json['last_name'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String);
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<UserProfile> userinfo;
  late Future<List<Petdata>> pet;
  @override
  void initState() {
    super.initState();
    userinfo = getUser();
    pet = getPetdata();
  }

  Future<List<Petdata>> getPetdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = prefs.getInt('id');

    if (token == null || id == null) {
      throw Exception('No auth token or user ID found');
    }
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/userpet/'), headers: {
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> petAPI = jsonDecode(response.body);
      List<Petdata> petModelData =
          petAPI.map((json) => Petdata.fromJson(json)).toList();
      return petModelData;
    } else {
      throw Exception("error: could not retrieve data!!!");
    }
  }

  Future<UserProfile> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = prefs.getInt('id');

    if (token == null || id == null) {
      throw Exception('No auth token or user ID found');
    }
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/users/$id'), headers: {
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Data not retrieved.');
    }
  }

  Future<void> delete(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http
        .delete(Uri.parse('http://127.0.0.1:8000/deleteA/$id'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token'
    });
    if (response.statusCode == 204) {
      setState(() {
        getPetdata();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Deleted'),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
      ));
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to delete'),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
      ));
      throw Exception('failed to delete');
    }
  }

  Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    if (token == null) {
      ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(
        content: Text('user not found'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/logoutA/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token'
        });
    if (response.statusCode == 204) {
      pref.remove('token');
      ScaffoldMessenger.of(context!)
          .showSnackBar(const SnackBar(content: Text('Logout success')));
      Navigator.pop(context);
      Navigator.pushNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
          content: Text('Logout Failed: ${response.body}'),
          duration: const Duration(seconds: 7),
          behavior: SnackBarBehavior.floating));
    }
  }

  
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () {
                    logout();
                  },
                  child: const Icon(Icons.logout_sharp)),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: userinfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                // tileColor:const Color.fromARGB(255, 200, 215, 222),
                                leading: ClipOval(
                                    child: Image.asset(
                                  'lib/images/default.jpg',
                                  fit: BoxFit.cover,
                                  height: 40,
                                  width: 40,
                                )),
                                title: Text(
                                    '${snapshot.data!.lastname} ${snapshot.data!.firstname}'),
                                subtitle: Text('@${snapshot.data!.username}'),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Text('${snapshot.error}');
                    }
                  }),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              flex: 4,
              child: FutureBuilder<List<Petdata>>(
                  future: pet,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No pets found.'));
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              elevation: 2.0,
                              // color: const Color.fromARGB(255, 244, 248, 244),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                        Text(
                                            '₦${snapshot.data![index].amount}'),
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
                                    const SizedBox(height: 6,),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:const Color.fromARGB(255, 3, 99, 244),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius
                                                                    .circular(
                                                                        9)))),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Updatepet(
                                                              pet: snapshot
                                                                      .data![
                                                                  index])));
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(Icons.edit_outlined),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  "Edit",
                                                  style:
                                                      TextStyle(fontSize: 16,color: Colors.white),
                                                ),
                                              ],
                                            )),
                                        const Spacer(),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await delete(snapshot.data![index].id);
                                            setState(() {
                                              getPetdata();
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color.fromARGB(
                                                  255, 212, 16, 2),
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              9)))),
                                          child: const Row(
                                            children: [
                                              Icon(
                                                  Icons.delete_outline_sharp),
                                              Text("Delete",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
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
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 3, 99, 244),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)))),
                    onPressed: () {
                      Navigator.pushNamed(context, '/create');
                    },
                    child: const Text("Create New",style: TextStyle(color: Colors.white),)),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
