import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:student_app/database/db_functions.dart';
import 'package:student_app/database/db_model.dart';

class EditStudentPage extends StatefulWidget {
  final StudentDBModel student;

  const EditStudentPage({super.key, required this.student});

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final inputName = TextEditingController();
  final inputAge = TextEditingController();
  final inputGuardian = TextEditingController();
  final inputContact = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? classNumber; // Default value for class number
  String? division; // Default value for division
  Uint8List? webImage; // To store image bytes for web

  @override
  void initState() {
    super.initState();
    inputName.text = widget.student.name;
    inputAge.text = widget.student.age;
    inputGuardian.text = widget.student.guardian;
    inputContact.text = widget.student.contact;
    webImage = widget.student.image;
    classNumber = widget.student.classNumber;
    division = widget.student.division;
  }

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

  Future<void> updateStudentButtonClicked() async {
    final name = inputName.text.trim();
    final age = inputAge.text.trim();
    final guardian = inputGuardian.text.trim();
    final contact = inputContact.text.trim();
    if (name.isNotEmpty &&
        age.isNotEmpty &&
        guardian.isNotEmpty &&
        contact.isNotEmpty &&
        classNumber!.isNotEmpty) {
      final updatedStudent = StudentDBModel(
        classNumber: classNumber!,
        division: division!,
        id: widget.student.id,
        name: name,
        age: age,
        guardian: guardian,
        contact: contact,
        image: webImage,
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
        title: const Text('Edit Student'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              hint: Text(classNumber!),
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
                                  if (value != null) {
                                    classNumber = value;
                                  }
                                });
                              },
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Class required';
                              //   }
                              //   return null;
                              // },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(
                            width: 90,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 40,
                              child: DropdownButtonFormField<String>(
                                hint: Text(division!),
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
                                  'J',
                                  'K',
                                ].map((String division) {
                                  return DropdownMenuItem<String>(
                                    value: division,
                                    child: Text(division),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    if (value != null) {
                                      division = value;
                                    }
                                  });
                                },
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'Division required';
                                //   }
                                //   return null;
                                // },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
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
                                updateStudentButtonClicked();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.green),
                            ),
                            child: Text('Update'),
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
      webImage = null;
    });
  }
}

// 2
// import 'dart:typed_data';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:student_app/database/db_functions.dart';
// import 'package:student_app/database/db_model.dart';

// class EditStudentPage extends StatefulWidget {
//   final StudentDBModel student;

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

//   String? classNumber; // Default value for class number
//   String? division; // Default value for division
//   Uint8List? image; // To store image bytes for web

//   // Function to pick image for web
//   Future<void> _pickImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: false,
//     );

//     if (result != null) {
//       setState(() {
//         image = result.files.first.bytes; // Store image bytes
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     inputName.text = widget.student.name;
//     inputAge.text = widget.student.age!;
//     inputGuardian.text = widget.student.guardian!;
//     inputContact.text = widget.student.contact!;
//     image = widget.student.image;
//   }

//   Future<void> updateStudentButtonClicked() async {
//     final name = inputName.text.trim();
//     final age = inputAge.text.trim();
//     final guardian = inputGuardian.text.trim();
//     final contact = inputContact.text.trim();

//     if (name.isNotEmpty &&
//         age.isNotEmpty &&
//         guardian.isNotEmpty &&
//         contact.isNotEmpty &&
//         classNumber!.isNotEmpty &&
//         division!.isNotEmpty) {
//       final updatedStudent = StudentDBModel(
//         id: widget.student.id,
//         name: name,
//         age: age,
//         guardian: guardian,
//         contact: contact,
//         classNumber: classNumber!,
//         division: division!,
//         image: image,
//       );

//       try {
//         await updateStudent(updatedStudent);
//         Navigator.of(context).pop();
//       } catch (e) {
//         print("Error updating student: $e");
//         showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: const Text('Error'),
//             content: const Text('Failed to update student. Please try again.'),
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
//         title: const Text('Edit Student'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(40),
//         children: [
//           Column(
//             children: [
//               InkWell(
//                 onTap: _pickImage,
//                 child: CircleAvatar(
//                   radius: 80,
//                   backgroundImage: image != null
//                       ? MemoryImage(image!)
//                       : null, // Display picked image or camera icon
//                   child: image == null
//                       ? const Icon(Icons.camera_alt, size: 50)
//                       : null,
//                 ),
//               ),
//               Form(
//                 key: formKey,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 20),
//                     TextFormField(
//                       controller: inputName,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Name',
//                         hintText: 'Enter name',
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Name required';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     TextFormField(
//                       controller: inputAge,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Age',
//                         hintText: 'Enter age',
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Age required';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: DropdownButtonFormField<String>(
//                             hint: const Text('Class'),
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.all(10),
//                             ),
//                             items: List.generate(10, (index) {
//                               return DropdownMenuItem<String>(
//                                 value: (index + 1).toString(),
//                                 child: Text((index + 1).toString()),
//                               );
//                             }),
//                             onChanged: (String? value) {
//                               if (value != null) {
//                                 setState(() {
//                                   classNumber = value;
//                                 });
//                               }
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Class required';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         Expanded(
//                           child: DropdownButtonFormField<String>(
//                             hint: const Text('Division'),
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.all(10),
//                             ),
//                             items: ['A', 'B', 'C', 'D', 'E']
//                                 .map((String divisionValue) {
//                               return DropdownMenuItem<String>(
//                                 value: divisionValue,
//                                 child: Text(divisionValue),
//                               );
//                             }).toList(),
//                             onChanged: (String? value) {
//                               if (value != null) {
//                                 setState(() {
//                                   division = value;
//                                 });
//                               }
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Division required';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     TextFormField(
//                       controller: inputGuardian,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Guardian name',
//                         hintText: 'Enter guardian name',
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Guardian name required';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     TextFormField(
//                       controller: inputContact,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Phone number',
//                         hintText: 'Phone number',
//                       ),
//                       keyboardType: TextInputType.phone,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Phone number required';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             if (formKey.currentState!.validate()) {
//                               updateStudentButtonClicked();
//                             }
//                           },
//                           child: const Text('Update'),
//                         ),
//                         const SizedBox(width: 20),
//                         ElevatedButton(
//                           onPressed: () {
//                             clear();
//                           },
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red),
//                           child: const Text('Clear'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
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
//     });
//   }
// }
