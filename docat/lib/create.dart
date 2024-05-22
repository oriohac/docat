import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

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
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/list/'),
    );

    request.fields["pettype"] = pettype;
    request.fields["breed"] = petbreedCon.text;
    request.fields["amount"] = petAmountCon.text;
    request.fields["description"] = petDescriptionCon.text;
    request.fields["location"] = location;
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
        // petImageCon.clear();
        // petTypeCon.clear();
        // petbreedCon.clear();
        // petAmountCon.clear();
        // petDescriptionCon.clear();
        // petLocationCon.clear();
        // Navigator.pushNamed(context, '/home');
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
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        getImage();
                      },
                      child: const Text('Select Image')),
                  selectedimage != null
                      ? Image.file(selectedimage!, width: 100, height: 60)
                      : const Text('Please select image'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: SizedBox(
                      width: 280,
                      height: 60,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextField(
                      controller: petbreedCon,
                      decoration: const InputDecoration(hintText: 'Breed'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: petAmountCon,
                      decoration: const InputDecoration(hintText: 'Amount'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextField(
                      decoration:
                          const InputDecoration(hintText: 'Description'),
                      controller: petDescriptionCon,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: SizedBox(
                      width: 280,
                      height: 60,
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
                  ),
                  ElevatedButton(
                    onPressed: () {
                      createnew();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                    child: const Text('Submit'),
                  )
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}
