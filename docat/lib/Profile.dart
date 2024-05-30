import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lougout success')));
      Navigator.pop(context);
      Navigator.pushNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Logout Failed: ${response.body}'),
          duration: Duration(seconds: 7),
          behavior: SnackBarBehavior.floating));
    }
  }

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
                child: Row(
                  children: [
                    Text('firstname surname'),
                    Spacer(),
                    ClipOval(
                        child: Image.asset(
                      'lib/images/default.jpg',
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    )),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/home");
                  },
                  child: const Text('Home')),
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
                                                Navigator.pushNamed(
                                                    context, '/create');
                                              },
                                              child: const Text("Create New")),
              ElevatedButton(
                  onPressed: () {
                    logout();
                  },
                  child: Text("Logout"))
            ],
          ),
        ),
      ),
    );
  }
}
