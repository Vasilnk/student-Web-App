// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'package:student_app/dbModel/db_model.dart';
// // import 'package:student_app/models/student_model.dart';
// import 'package:student_app/dbHelper/db_functions.dart';

// class EditStudentPage extends StatefulWidget {
//   final StudentModel student;

//   EditStudentPage({required this.student});

//   @override
//   _EditStudentPageState createState() => _EditStudentPageState();
// }

// class _EditStudentPageState extends State<EditStudentPage> {
//   final inputName = TextEditingController();
//   final inputAge = TextEditingController();
//   final inputGuardian = TextEditingController();
//   final inputContact = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   // final ImagePicker _picker = ImagePicker();
//   // String? imagePath;
//   File? image;
//   Uint8List? imageBytes;
//   // Uint8List? imagebytes1;
//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       final orginalimage =
//           img.decodeAnimation(File(pickedFile.path).readAsBytesSync());

//       if (orginalimage != null) {
//         final resizedImage = img.copyResize(orginalimage as img.Image, width: 300, height: 300);
//         final compressedImage = Uint8List.fromList(img.encodeJpg(resizedImage, quality: 85));

//         setState(() {
//           imageBytes = compressedImage;
//         });
//       }
//     }

//     // setState(() {
//       // if (pickedFile != null) {
//         // image = File(pickedFile.path);
//         // imageBytes = File(pickedFile.path).readAsBytesSync();
//       // }
//     // });
//   }

//   @override
//   void initState() {
//     super.initState();
//     inputName.text = widget.student.name;
//     inputAge.text = widget.student.age!;
//     inputGuardian.text = widget.student.guardian!;
//     inputContact.text = widget.student.contact!;
//     imageBytes = widget.student.image;
//   }

//   Future<void> updateStudentButtonClicked() async {
//     final name = inputName.text.trim();
//     final age = inputAge.text.trim();
//     final guardian = inputGuardian.text.trim();
//     final contact = inputContact.text.trim();
//     // final Image = imageBytes;

//     if (name.isNotEmpty &&
//         age.isNotEmpty &&
//         guardian.isNotEmpty &&
//         contact.isNotEmpty) {
//       final student = StudentModel(
//         id: widget.student.id,
//         name: name,
//         age: age,
//         guardian: guardian,
//         contact: contact,
//         image: imageBytes,
//       );

//       try {
//         await updateStudent(student);
//         Navigator.of(context).pop();
//       } catch (e) {
//         print("Error updating student: $e");
//         showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: Text('Error'),
//             content: Text('Failed to update student. Please try again.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                   // image = null;
//                   setState(() {
//                     image = null;
//                   });
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Student'),
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(40),
//             child: Column(
//               children: [
//                 // GestureDetector(
//                 // onTap: () => _pickImage(ImageSource.gallery),
//                 // child: CircleAvatar(
//                 // radius: 50,
//                 // backgroundImage: _imagePath != null
//                 // ? FileImage(File(_imagePath!))
//                 // : null,
//                 // child: _imagePath == null
//                 // ? Icon(Icons.camera_alt, size: 50)
//                 // : null,
//                 // ),
//                 // ),
//                 InkWell(
//                   onTap: () {
//                     showModalBottomSheet(
//                         context: context,
//                         builder: (builder) {
//                           return SizedBox(
//                             width: double.infinity,
//                             height: 150,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 InkWell(
//                                   child: Icon(
//                                     Icons.image,
//                                     size: 60,
//                                   ),
//                                   onTap: () {
//                                     _pickImage(ImageSource.gallery);
//                                     Navigator.pop(context);
//                                   },
//                                 ),
//                                 InkWell(
//                                   child: Icon(
//                                     Icons.camera_alt,
//                                     size: 60,
//                                   ),
//                                   onTap: () {
//                                     _pickImage(ImageSource.camera);
//                                     Navigator.pop(context);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           );
//                         });
//                     // _pickImage(ImageSource.camera);
//                   },
//                   child: Stack(children: [
//                     CircleAvatar(
//                       radius: 80,
//                       backgroundImage:
//                           // image != null ? FileImage(.image!) : null,
//                           // child:
//                           //     image == null ? Icon(Icons.camera_alt, size: 50) : null,
//                           imageBytes != null ? MemoryImage(imageBytes!) : null,
//                       child: imageBytes == null
//                           ? Icon(Icons.camera_alt, size: 50)
//                           : null,
//                     ),
//                     Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 // image = null;
//                                 imageBytes = null;
//                               });
//                             },
//                             child: Icon(Icons.delete)))
//                   ]),
//                 ),
//                 Form(
//                   key: formKey,
//                   child: Column(
//                     children: [
//                       SizedBox(height: 10),
//                       TextFormField(
//                         controller: inputName,
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: 'Name',
//                             hintText: 'Enter name'),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Name required';
//                           }
//                           return null;
//                         },
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: inputAge,
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: 'Age',
//                             hintText: 'Enter age'),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Age required';
//                           }
//                           return null;
//                         },
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: inputGuardian,
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: 'Guardian name',
//                             hintText: 'Enter guardian name'),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Guardian name required';
//                           }
//                           return null;
//                         },
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: inputContact,
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: 'Phone number',
//                             hintText: 'Phone number'),
//                         keyboardType: TextInputType.phone,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Phone number required';
//                           }
//                           return null;
//                         },
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                       ),
//                       SizedBox(height: 15),
//                       Row(
//                         children: [
//                           SizedBox(width: 10),
//                           TextButton(
//                             onPressed: () {
//                               if (formKey.currentState!.validate()) {
//                                 print('pressed');
//                                 updateStudentButtonClicked();
//                               }
//                             },
//                             child: Text('Update'),
//                             style: ButtonStyle(
//                               backgroundColor:
//                                   MaterialStateProperty.all(Colors.green),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           TextButton(
//                             onPressed: () {
//                               clear();
//                             },
//                             child: Text('Clear'),
//                             style: ButtonStyle(
//                               backgroundColor:
//                                   MaterialStateProperty.all(Colors.red),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void clear() {
//     inputName.clear();
//     inputAge.clear();
//     inputGuardian.clear();
//     inputContact.clear();
//     setState(() {
//       image = null;
//       imageBytes = null;
//     });
//   }
// }
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
        image: imageBytes, // Assign compressed image bytes
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
                            ? Icon(Icons.camera_alt, size: 50)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              imageFile = null; // Clear image file
                              imageBytes = null; // Clear image bytes
                            });
                          },
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ],
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
                      SizedBox(height: 20),
                      TextFormField(
                        controller: inputAge,
                        decoration: InputDecoration(
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
                      SizedBox(height: 20),
                      TextFormField(
                        controller: inputGuardian,
                        decoration: InputDecoration(
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
                      SizedBox(height: 20),
                      TextFormField(
                        controller: inputContact,
                        decoration: InputDecoration(
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
                      SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(width: 10),
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
      imageFile = null; // Clear image file
      imageBytes = null; // Clear image bytes
    });
  }
}
