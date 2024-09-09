// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'package:student_app/database/db_functions.dart';
// import 'package:student_app/database/db_model.dart';

// class AddStudentPage extends StatefulWidget {
//   const AddStudentPage({super.key});

//   @override
//   _AddStudentPageState createState() => _AddStudentPageState();
// }

// class _AddStudentPageState extends State<AddStudentPage> {
//   final inputName = TextEditingController();
//   final inputAge = TextEditingController();
//   final inputGuardian = TextEditingController();
//   final inputContact = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   late final String classNumber;
//   late final String division;
//   File? imageFile;
//   Uint8List? imageBytes;

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       final originalImage =
//           img.decodeImage(File(pickedFile.path).readAsBytesSync());

//       if (originalImage != null) {
//         final resizedImage =
//             img.copyResize(originalImage, width: 300, height: 300);
//         final compressedImage =
//             Uint8List.fromList(img.encodeJpg(resizedImage, quality: 85));

//         setState(() {
//           imageFile = File(pickedFile.path);
//           imageBytes = compressedImage;
//         });
//       }
//     }
//   }

//   Future<void> addStudentButtonClicked() async {
//     final name = inputName.text.trim();
//     final age = inputAge.text.trim();
//     final guardian = inputGuardian.text.trim();
//     final contact = inputContact.text.trim();
//     final classNumber = classNumber;

//     if (name.isNotEmpty &&
//         age.isNotEmpty &&
//         guardian.isNotEmpty &&
//         contact.isNotEmpty &&
//         classNumber.isNotEmpty) {
//       final newStudent = StudentDBModel(
//           name: name,
//           age: age,
//           guardian: guardian,
//           contact: contact,
//           image: imageBytes,
//           classNumber: classNumber,
//           division: division);

//       try {
//         await addStudent(newStudent);

//         Navigator.of(context).pop();
//       } catch (e) {
//         print("Error adding student: $e");

//         showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: const Text('Error'),
//             content: const Text('Failed to add student. Please try again.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(ctx).pop(),
//                 child: const Text('OK'),
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
//         title: const Text('Add Student'),
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(40),
//             child: Column(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       builder: (builder) {
//                         return SizedBox(
//                           width: double.infinity,
//                           height: 150,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               InkWell(
//                                 child: const Icon(
//                                   Icons.image,
//                                   size: 60,
//                                 ),
//                                 onTap: () {
//                                   _pickImage(ImageSource.gallery);
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                               InkWell(
//                                 child: const Icon(
//                                   Icons.camera_alt,
//                                   size: 60,
//                                 ),
//                                 onTap: () {
//                                   _pickImage(ImageSource.camera);
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   child: CircleAvatar(
//                     radius: 80,
//                     backgroundImage:
//                         imageBytes != null ? MemoryImage(imageBytes!) : null,
//                     child: imageBytes == null
//                         ? const Icon(Icons.camera_alt, size: 50)
//                         : null,
//                   ),
//                 ),
//                 Form(
//                   key: formKey,
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: inputName,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Name',
//                           hintText: 'Enter name',
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Name required';
//                           }
//                           return null;
//                         },
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: inputAge,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Age',
//                           hintText: 'Enter age',
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Age required';
//                           }
//                           return null;
//                         },
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: DropdownButtonFormField<String>(
//                               hint: const Text('Class'),
//                               decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   contentPadding: EdgeInsets.all(10)),
//                               items: [
//                                 '1',
//                                 '2',
//                                 '3',
//                                 '4',
//                                 '5',
//                                 '6',
//                                 '7',
//                                 '8',
//                                 '9',
//                                 '10'
//                               ].map((String classValue) {
//                                 return DropdownMenuItem<String>(
//                                   value: classValue,
//                                   child: Text(classValue),
//                                 );
//                               }).toList(),
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   if (value != null) {
//                                     classNumber = value;
//                                   }
//                                 });
//                               },
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Class required';
//                                 }
//                                 return null;
//                               },
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 90,
//                           ),
//                           Expanded(
//                             child: DropdownButtonFormField<String>(
//                               hint: const Text('Division'),
//                               decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   contentPadding: EdgeInsets.all(8)),
//                               items: [
//                                 'A',
//                                 'B',
//                                 'C',
//                                 'D',
//                                 'E',
//                                 'F',
//                                 'G',
//                                 'H',
//                                 'I',
//                                 'J'
//                               ].map((String classValue1) {
//                                 return DropdownMenuItem<String>(
//                                   value: classValue1,
//                                   child: Text(classValue1),
//                                 );
//                               }).toList(),
//                               onChanged: (String? value) {},
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Division required';
//                                 }
//                                 return null;
//                               },
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: inputGuardian,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Guardian name',
//                           hintText: 'Enter guardian name',
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Guardian name required';
//                           }
//                           return null;
//                         },
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: inputContact,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Phone number',
//                           hintText: 'Phone number',
//                         ),
//                         keyboardType: TextInputType.phone,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Phone number required';
//                           }
//                           return null;
//                         },
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                       ),
//                       const SizedBox(height: 15),
//                       Row(
//                         children: [
//                           const SizedBox(width: 10),
//                           TextButton(
//                             onPressed: () {
//                               if (formKey.currentState!.validate()) {
//                                 addStudentButtonClicked();
//                               }
//                             },
//                             style: ButtonStyle(
//                               backgroundColor:
//                                   MaterialStateProperty.all(Colors.green),
//                             ),
//                             child: const Text(
//                               'Add',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           TextButton(
//                             onPressed: () {
//                               clear();
//                             },
//                             style: ButtonStyle(
//                               backgroundColor:
//                                   WidgetStateProperty.all(Colors.red),
//                             ),
//                             child: const Text(
//                               'Clear',
//                               style: TextStyle(color: Colors.white),
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
//       imageFile = null;
//       imageBytes = null;
//     });
//   }
// }
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class AddStudentPage extends StatefulWidget {
//   const AddStudentPage({super.key});

//   @override
//   _AddStudentPageState createState() => _AddStudentPageState();
// }

// class _AddStudentPageState extends State<AddStudentPage> {
//   final inputName = TextEditingController();
//   final inputAge = TextEditingController();
//   final formKey = GlobalKey<FormState>();

//   String classNumber = '1';
//   String division = 'A';
//   File? imageFile;

//   final ImagePicker _picker = ImagePicker();

//   // Function to pick image from gallery or camera
//   Future<void> _pickImage(ImageSource source) async {
//     final XFile? pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         imageFile = File(pickedFile.path); // Convert XFile to File
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Student'),
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(40),
//             child: Column(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       builder: (builder) {
//                         return SizedBox(
//                           width: double.infinity,
//                           height: 150,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               InkWell(
//                                 child: const Icon(
//                                   Icons.image,
//                                   size: 60,
//                                 ),
//                                 onTap: () {
//                                   _pickImage(ImageSource.gallery);
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                               InkWell(
//                                 child: const Icon(
//                                   Icons.camera_alt,
//                                   size: 60,
//                                 ),
//                                 onTap: () {
//                                   _pickImage(ImageSource.camera);
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   child: CircleAvatar(
//                     radius: 80,
//                     backgroundImage:
//                         imageFile != null ? FileImage(imageFile!) : null,
//                     child: imageFile == null
//                         ? const Icon(Icons.camera_alt, size: 50)
//                         : null,
//                   ),
//                 ),
//                 Form(
//                   key: formKey,
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: inputName,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Name',
//                           hintText: 'Enter name',
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Name required';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: inputAge,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Age',
//                           hintText: 'Enter age',
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Age required';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: DropdownButtonFormField<String>(
//                               value: classNumber,
//                               hint: const Text('Class'),
//                               decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   contentPadding: EdgeInsets.all(10)),
//                               items: [
//                                 '1',
//                                 '2',
//                                 '3',
//                                 '4',
//                                 '5',
//                                 '6',
//                                 '7',
//                                 '8',
//                                 '9',
//                                 '10'
//                               ].map((String classValue) {
//                                 return DropdownMenuItem<String>(
//                                   value: classValue,
//                                   child: Text(classValue),
//                                 );
//                               }).toList(),
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   classNumber = value!;
//                                 });
//                               },
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 90,
//                           ),
//                           Expanded(
//                             child: DropdownButtonFormField<String>(
//                               value: division,
//                               hint: const Text('Division'),
//                               decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   contentPadding: EdgeInsets.all(8)),
//                               items: [
//                                 'A',
//                                 'B',
//                                 'C',
//                                 'D',
//                                 'E',
//                                 'F',
//                                 'G',
//                                 'H',
//                                 'I',
//                                 'J'
//                               ].map((String divisionValue) {
//                                 return DropdownMenuItem<String>(
//                                   value: divisionValue,
//                                   child: Text(divisionValue),
//                                 );
//                               }).toList(),
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   division = value!;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       // Other form fields...
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
// }
import 'package:flutter/material.dart';
import 'dart:typed_data'; // For handling byte data for web
import 'package:file_picker/file_picker.dart';
import 'package:student_app/database/db_functions.dart';
import 'package:student_app/database/db_model.dart'; // For picking files in web

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final inputName = TextEditingController();
  final inputAge = TextEditingController();
  final inputGuardian = TextEditingController();
  final inputContact = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? classNumber; // Default value for class number
  String? division; // Default value for division
  Uint8List? webImage; // To store image bytes for web

  // Function to pick image for web
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        webImage = result.files.first.bytes; // Store image bytes
      });
    }
  }

  Future<void> addStudentButtonClicked() async {
    final name = inputName.text.trim();
    final age = inputAge.text.trim();
    final guardian = inputGuardian.text.trim();
    final contact = inputContact.text.trim();

    if (name.isNotEmpty &&
        age.isNotEmpty &&
        guardian.isNotEmpty &&
        contact.isNotEmpty &&
        classNumber!.isNotEmpty &&
        division!.isNotEmpty) {
      final newStudent = StudentDBModel(
          name: name,
          age: age,
          guardian: guardian,
          contact: contact,
          image: webImage,
          classNumber: classNumber!,
          division: division!);

      try {
        await addStudent(newStudent);

        Navigator.of(context).pop();
      } catch (e) {
        print("Error adding student: $e");

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to add student. Please try again.'),
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
        title: const Text('Add Student'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                // Profile picture picker (for web)
                InkWell(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: webImage != null
                        ? MemoryImage(webImage!)
                        : null, // Display picked image or camera icon
                    child: webImage == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Name input field
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
                      // Age input field
                      TextFormField(
                        controller: inputAge,
                        keyboardType: TextInputType.number,
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
                      // Class and Division dropdown fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: classNumber,
                              hint: const Text('Class'),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(10)),
                              items: [
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                                '6',
                                '7',
                                '8',
                                '9',
                                '10'
                              ].map((String classValue) {
                                return DropdownMenuItem<String>(
                                  value: classValue,
                                  child: Text(classValue),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  classNumber = value!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Class required';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(width: 90),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: division,
                              hint: const Text('Division'),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(8)),
                              items: [
                                'A',
                                'B',
                                'C',
                                'D',
                                'E',
                                'F',
                                'G',
                                'H',
                                'I',
                                'J'
                              ].map((String divisionValue) {
                                return DropdownMenuItem<String>(
                                  value: divisionValue,
                                  child: Text(divisionValue),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  division = value!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Divition required';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),
                        ],
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
                                addStudentButtonClicked();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.green),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              clear();
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.red),
                            ),
                            child: const Text(
                              'Clear',
                              style: TextStyle(color: Colors.white),
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
      webImage = null;
    });
  }
}
