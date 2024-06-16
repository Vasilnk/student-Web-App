import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_app/dbHelper/db_functions.dart';
import 'package:student_app/dbModel/db_model.dart';
import 'home_page.dart';

class AddStudentPage extends StatefulWidget {
  AddStudentPage({Key? key}) : super(key: key);

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final inputName = TextEditingController();
  final inputAge = TextEditingController();
  final inputG_name = TextEditingController();
  final inputPhone = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? _imagePath;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Portal'),
      ),
      body: ListView(
        padding: EdgeInsets.all(40),
        children: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (builder) {
                    return SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.image,
                              size: 60,
                            ),
                            onTap: () {
                              _pickImage(ImageSource.gallery);
                              Navigator.pop(context);
                            },
                          ),
                          InkWell(
                            child: Icon(
                              Icons.camera_alt,
                              size: 60,
                            ),
                            onTap: () {
                              _pickImage(ImageSource.camera);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  });
              // _pickImage(ImageSource.camera);
            },
            child: CircleAvatar(
              radius: 80,
              backgroundImage:
                  _imagePath != null ? FileImage(File(_imagePath!)) : null,
              // child:
              // _imagePath == null ? Icon(Icons.camera_alt, size: 50) : null,
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 30),
                TextFormField(
                    controller: inputName,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Enter name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name required';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction),
                SizedBox(height: 20),
                TextFormField(
                  controller: inputAge,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter age'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Age required';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: inputG_name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter guardian name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Guardian name required';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: inputPhone,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter phone number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number required';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          addStudentButtonClicked();
                        }
                      },
                      child: Text('Save'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        clear();
                      },
                      child: Text('Clear'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addStudentButtonClicked() async {
    final name = inputName.text.trim();
    final age = inputAge.text.trim();
    final gName = inputG_name.text.trim();
    final phone = inputPhone.text.trim();

    if (name.isNotEmpty &&
        age.isNotEmpty &&
        gName.isNotEmpty &&
        phone.isNotEmpty) {
      final student = StudentModel(
        id: null,
        name: name,
        age: age,
        guardian: gName,
        contact: phone,
        // image: _imagePath,
      );
      await addStudent(student);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  void clear() {
    inputName.clear();
    inputAge.clear();
    inputG_name.clear();
    inputPhone.clear();
    setState(() {
      _imagePath = null;
    });
  }
}
