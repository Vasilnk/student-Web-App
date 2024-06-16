import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_app/dbModel/db_model.dart';
// import 'package:student_app/models/student_model.dart';
import 'package:student_app/dbHelper/db_functions.dart';

class EditStudentPage extends StatefulWidget {
  final StudentModel student;

  EditStudentPage({required this.student});

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final inputName = TextEditingController();
  final inputAge = TextEditingController();
  final inputGuardian = TextEditingController();
  final inputContact = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    inputName.text = widget.student.name;
    inputAge.text = widget.student.age!;
    inputGuardian.text = widget.student.guardian!;
    inputContact.text = widget.student.contact!;
  }

  Future<void> updateStudentButtonClicked() async {
    final name = inputName.text.trim();
    final age = inputAge.text.trim();
    final guardian = inputGuardian.text.trim();
    final contact = inputContact.text.trim();

    if (name.isNotEmpty &&
        age.isNotEmpty &&
        guardian.isNotEmpty &&
        contact.isNotEmpty) {
      final updatedStudent = StudentModel(
        id: widget.student.id,
        name: name,
        age: age,
        guardian: guardian,
        contact: contact,
        // image: image,
      );

      try {
        await updateStudent(updatedStudent);
        Navigator.of(context).pop();
      } catch (e) {
        print("Error updating student: $e");
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to update student. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              children: [
                // GestureDetector(
                // onTap: () => _pickImage(ImageSource.gallery),
                // child: CircleAvatar(
                // radius: 50,
                // backgroundImage: _imagePath != null
                // ? FileImage(File(_imagePath!))
                // : null,
                // child: _imagePath == null
                // ? Icon(Icons.camera_alt, size: 50)
                // : null,
                // ),
                // ),
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
                    backgroundImage: _imagePath != null
                        ? FileImage(File(_imagePath!))
                        : null,
                    // child:
                    // _imagePath == null ? Icon(Icons.camera_alt, size: 50) : null,
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      TextFormField(
                        controller: inputName,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                            hintText: 'Enter name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name required';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: inputAge,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Age',
                            hintText: 'Enter age'),
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
                        controller: inputGuardian,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Guardian name',
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
                        controller: inputContact,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Phone number',
                            hintText: 'Phone number'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number required';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                print('pressed');
                                updateStudentButtonClicked();
                              }
                            },
                            child: Text('Update'),
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
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void clear() {
    inputName.clear();
    inputAge.clear();
    inputGuardian.clear();
    inputContact.clear();
    setState(() {
      // _imagePath = null;
    });
  }
}
