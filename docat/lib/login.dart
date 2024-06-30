import 'dart:convert';

import 'package:docat/Profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void loginApi() async {
    final response = await http.post(Uri.parse('http://127.0.0.1:8000/loginA/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'username': _usernameController.text,
          'password': _passwordController.text,
        }));
    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      String token = data['token'];
      int id = data['id'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setInt('id', id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login success'),
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Profile()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to Login Check your details'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 8),
        dismissDirection: DismissDirection.horizontal,
      ));
      throw Exception('Login failed');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0A001E),
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
              child: Text(
                'Welcome',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 24,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(35, 31, 35, 31),
              child: Text(
                'Enter your Email and Password to log into your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppinsr',
                  fontSize: 17,
                ),
              ),
            ),
            // email
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
              child: SizedBox(
                height: 62,
                width: 320,
                child: TextField(
                  controller: _usernameController,
                  style: const TextStyle(
                      fontFamily: 'Poppinsr',
                      fontSize: 17,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 30, 11, 76),
                      hintText: AutofillHints.username,
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
            ),
            // Password
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 18),
              child: SizedBox(
                height: 62,
                width: 320,
                child: TextField(
                  controller: _passwordController,
                  style: const TextStyle(
                      fontFamily: 'Poppinsr',
                      fontSize: 17,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 30, 11, 76),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                  obscureText: true,
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppinsr',
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontFamily: 'Poppinsr',
                        fontSize: 17,
                      ),
                    )),
              ],
            ),

            // Button
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 32),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    minimumSize: const Size(250, 62),
                    backgroundColor: const Color(0xffDB7D95),
                  ),
                  onPressed: () {
                    setState(() {
                      login();
                    });
                  },
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 24,
                    ),
                  )),
            ),
          ]),
        ),
      ),
    );
  }

  void login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fill all fields')));
    } else {
      loginApi();
    }
  }
}
