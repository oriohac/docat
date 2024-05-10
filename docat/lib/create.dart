import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  String pettype = 'Dog';
  String location = 'ABIA';
  TextEditingController petImageCon = TextEditingController();
  TextEditingController petTypeCon = TextEditingController();
  TextEditingController petbreedCon = TextEditingController();
  TextEditingController petAmountCon = TextEditingController();
  TextEditingController petDescriptionCon = TextEditingController();
  TextEditingController petLocationCon = TextEditingController();

  File? selectedimage;
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
                      ? Image.file(selectedimage!, width: 80, height: 8)
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
                        items: <String>['Dog', 'Cat']
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
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextField(
                      controller: petbreedCon,
                      decoration: InputDecoration(hintText: 'Breed'),
                    ),
                  ),
                   Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      controller: petAmountCon,
                      decoration: InputDecoration(hintText: 'Amount'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Description'),
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
                        items: <String>['ABIA','ADAMAWA','AKWA IBOM','ANAMBRA','BAUCHI','BAYELSA','BENUE','BORNO','CROSS RIVER','DELTA','EBONYI','EDO','EKITI','ENUGU','GOMBE','IMO','JIGAWA','KADUNA','KANO','KATSINA','KEBBI','KOGI','KWARA','LAGOS','NASSARAWA','NIGER','OGUN','ONDO','OSUN','OYO','PLATEAU','RIVERS','SOKOTO','TARABA','YOBE','ZAMFARA','ABUJA']
                        .map<DropdownMenuItem<String>>((String value) {
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;

    setState(() {
      selectedimage = File(img!.path);
    });
  }
}
