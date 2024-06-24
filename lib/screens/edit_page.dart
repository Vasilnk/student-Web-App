import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:student_app/dbModel/db_model.dart';
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
  File? imageFile;
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    inputName.text = widget.student.name;
    inputAge.text = widget.student.age!;
    inputGuardian.text = widget.student.guardian!;
    inputContact.text = widget.student.contact!;
    imageBytes = widget.student.image;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final originalImage =
          img.decodeImage(File(pickedFile.path).readAsBytesSync());

      if (originalImage != null) {
        final resizedImage =
            img.copyResize(originalImage, width: 300, height: 300);
        final compressedImage =
            Uint8List.fromList(img.encodeJpg(resizedImage, quality: 85));

        setState(() {
          imageFile = File(pickedFile.path);
          imageBytes = compressedImage;
        });
      }
    }
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
        image: imageBytes,
      );

      try {
        await updateStudent(updatedStudent);
        Navigator.of(context).pop();
      } catch (e) {
        print("Error updating student: $e");
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to update student. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
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
                                child: const Icon(
                                  Icons.image,
                                  size: 60,
                                ),
                                onTap: () {
                                  _pickImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                              ),
                              InkWell(
                                child: const Icon(
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
                      },
                    );
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: imageBytes != null
                            ? MemoryImage(imageBytes!)
                            : null,
                        child: imageBytes == null
                            ? const Icon(Icons.camera_alt, size: 50)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              imageFile = null;
                              imageBytes = null;
                            });
                          },
                          child: const Icon(Icons.delete),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: inputName,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                          hintText: 'Enter name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name required';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: inputAge,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Age',
                          hintText: 'Enter age',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Age required';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: inputGuardian,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Guardian name',
                          hintText: 'Enter guardian name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Guardian name required';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: inputContact,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone number',
                          hintText: 'Phone number',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number required';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                updateStudentButtonClicked();
                              }
                            },
                            child: Text('Update'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              clear();
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            child: const Text('Clear'),
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
      imageFile = null;
      imageBytes = null;
    });
  }
}
