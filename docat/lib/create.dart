import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  String pettype = 'DOG';
  String location = 'ABIA';
  TextEditingController petbreedCon = TextEditingController();
  TextEditingController petAmountCon = TextEditingController();
  TextEditingController petDescriptionCon = TextEditingController();

  File? selectedimage;

  Future<void> createnew() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/list/'),
    );

    request.fields["pettype"] = pettype;
    request.fields["breed"] = petbreedCon.text;
    request.fields["amount"] = petAmountCon.text;
    request.fields["description"] = petDescriptionCon.text;
    request.fields["location"] = location;
    request.fields["owner"] = id.toString();
    request.files.add(await http.MultipartFile.fromPath(
        'petimage', selectedimage!.path,
        contentType: MediaType('image', 'jpeg')));
    try {
      final response = await request.send();
      if (petbreedCon.text.isEmpty ||
          petAmountCon.text.isEmpty ||
          petDescriptionCon.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(children: [
            Text("Please fill all inputs"),
            SizedBox(
              width: 16,
            ),
            Icon(Icons.warning, color: Colors.red)
          ]),
          behavior: SnackBarBehavior.floating,
        ));
      } else if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Post Success'),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.horizontal,
          duration: Duration(seconds: 5),
        ));
        petbreedCon.clear();
        petAmountCon.clear();
        petDescriptionCon.clear();
        Navigator.pop(context);
        Navigator.pushNamed(context, '/profile');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Error Sending data'),
            behavior: SnackBarBehavior.floating));
        print(response.statusCode);
      }
    } catch (e) {
      print("Error : $e");
    }
  }

  Future<void> getImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;

    setState(() {
      selectedimage = File(img.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 2,
                                  color: Colors.black))),
                      value: pettype,
                      items: <String>['DOG', 'CAT']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          pettype = newValue!;
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextField(
                      controller: petbreedCon,
                      decoration: const InputDecoration(
                          hintText: 'Breed',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: petAmountCon,
                      decoration: const InputDecoration(
                          hintText: 'Amount',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextField(
                      controller: petDescriptionCon,
                      maxLines: 4,
                      decoration: const InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 2,
                                  color: Colors.black))),
                      value: location,
                      items: <String>[
                        'ABIA',
                        'ADAMAWA',
                        'AKWA IBOM',
                        'ANAMBRA',
                        'BAUCHI',
                        'BAYELSA',
                        'BENUE',
                        'BORNO',
                        'CROSS RIVER',
                        'DELTA',
                        'EBONYI',
                        'EDO',
                        'EKITI',
                        'ENUGU',
                        'GOMBE',
                        'IMO',
                        'JIGAWA',
                        'KADUNA',
                        'KANO',
                        'KATSINA',
                        'KEBBI',
                        'KOGI',
                        'KWARA',
                        'LAGOS',
                        'NASSARAWA',
                        'NIGER',
                        'OGUN',
                        'ONDO',
                        'OSUN',
                        'OYO',
                        'PLATEAU',
                        'RIVERS',
                        'SOKOTO',
                        'TARABA',
                        'YOBE',
                        'ZAMFARA',
                        'ABUJA'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          location = newValue!;
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        onPressed: () {
                          getImage();
                        },
                        child: const Icon(Icons.image)),
                    const SizedBox(
                      width: 4,
                    ),
                    selectedimage != null
                        ? Image.file(selectedimage!, width: 100, height: 60)
                        : GestureDetector(
                            onTap: () {
                              getImage();
                            },
                            child: const Text('Please select image')),
                  ]),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          createnew();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 3, 99, 244),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
