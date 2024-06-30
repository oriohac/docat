import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confpasswordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void signupApi() async {
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/signupA/'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'first_name': _firstnameController.text,
          'last_name': _lastnameController.text,
          'email': _emailController.text,
          'username': _usernameController.text,
          'phone': _phoneController.text,
          'password': _passwordController.text,
        }));
    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      String token = data['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Signup success'),
          behavior: SnackBarBehavior.floating));
      Navigator.pop(context);
      Navigator.pushNamed(context, '/login');
    } else {
      throw Exception('Faileed to signup, check server');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confpasswordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
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
                'New User?',
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
                'Enter your Username, Email and Password to register your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppinsr',
                  fontSize: 17,
                ),
              ),
            ),
            // firstName
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
              child: SizedBox(
                height: 62,
                width: 320,
                child: TextField(
                  controller: _firstnameController,
                  style: const TextStyle(
                    fontFamily: 'Poppinsr',
                    fontSize: 17,
                    color: Colors.white
                  ),
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 30, 11, 76),
                      hintText: 'Firstname',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
            ),
            // LastName
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
              child: SizedBox(
                height: 62,
                width: 320,
                child: TextField(
                  controller: _lastnameController,
                  style: const TextStyle(
                    fontFamily: 'Poppinsr',
                    fontSize: 17,
                    color: Colors.white
                  ),
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 30, 11, 76),
                      hintText: 'LastName',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
            ),
            // Username
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
              child: SizedBox(
                height: 62,
                width: 320,
                child: TextField(
                  controller: _usernameController,
                  style: const TextStyle(
                    fontFamily: 'Poppinsr',
                    fontSize: 17,
                    color: Colors.white
                  ),
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 30, 11, 76),
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
            ),
// phone
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
              child: SizedBox(
                height: 62,
                width: 320,
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  style: const TextStyle(
                    fontFamily: 'Poppinsr',
                    fontSize: 17,
                    color: Colors.white
                  ),
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 30, 11, 76),
                      hintText: 'Phone',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
            ),

            // email
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
              child: SizedBox(
                height: 62,
                width: 320,
                child: TextField(
                  controller: _emailController,
                  style: const TextStyle(
                    fontFamily: 'Poppinsr',
                    fontSize: 17,
                    color: Colors.white
                  ),
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 30, 11, 76),
                      hintText: AutofillHints.email,
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
            ),
            // Password
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
              child: SizedBox(
                height: 62,
                width: 320,
                child: TextField(
                  controller: _passwordController,
                  style: const TextStyle(
                    fontFamily: 'Poppinsr',
                    fontSize: 17,
                    color: Colors.white
                  ),
                  textAlign: TextAlign.start,
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

            // Password
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
              child: SizedBox(
                height: 62,
                width: 320,
                child: TextField(
                  controller: _confpasswordController,
                  style: const TextStyle(
                    fontFamily: 'Poppinsr',
                    fontSize: 17,
                    color: Colors.white
                  ),
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 30, 11, 76),
                      hintText: 'Re-enter Password',
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
                  "Already have an account? ",
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
                      Navigator.pushNamed(context, "/login");
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontFamily: 'Poppinsr',
                        fontSize: 17,
                      ),
                    )),
              ],
            ),

            // Signup Button
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 32),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffDB7D95),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      minimumSize: const Size(250, 62)),
                  onPressed: () {
                    if (_usernameController.text.isEmpty ||
                        _emailController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _confpasswordController.text.isEmpty ||
                        _firstnameController.text.isEmpty ||
                        _lastnameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please fill all fields'),
                          behavior: SnackBarBehavior.floating));
                    } else if (_passwordController.text !=
                        _confpasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Passwords Not Matched'),
                          behavior: SnackBarBehavior.floating,
                          dismissDirection: DismissDirection.horizontal));
                    } else {
                      setState(() {
                        signupApi();
                      });
                    }
                  },
                  child: const Text(
                    "REGISTER",
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
}
