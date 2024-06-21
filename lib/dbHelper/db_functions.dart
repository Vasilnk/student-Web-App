// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:student_app/dbModel/db_model.dart';

// ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);
// late Database db;
// Future<void> inisializrDatabase() async {
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, 'student.db');
//   db = await openDatabase(
//     'student.db',
//     version: 1,
//     onCreate: (db, version) async {
//       await db.execute(
//           'CREATE TABLE student (id INTEGER PRIMARY KEY, name TEXT, age TEXT,guardian TEXT , contact TEXT)');
//     },
//   );
// }

// Future<void> addStudent(StudentModel student1) async {
//   db.rawInsert(
//       'INSERT INTO student (name,age,guardian,contact) VALUES  (?,?,?,?)',
//       [student1.name, student1.age, student1.guardian, student1.contact]);
//   getData();
//   // studentListNotifier.value.add(student1);
//   // studentListNotifier.notifyListeners();
// }

// Future<void> getData() async {
//   //
//   final values = await db.rawQuery('SELECT * FROM student');

//   studentListNotifier.value.clear();
//   values.forEach((map) {
//     final student = StudentModel.fromMap(map);
//     studentListNotifier.value.add(student);
//     studentListNotifier.notifyListeners();
//     print(values);
//   });
// }

// Future<void> deleteStudent(int id) async {
//   await db.rawDelete('DELETE FROM student WHERE id = ?', [id]);
//   await getData();
//   studentListNotifier.notifyListeners();
// }

// updateStudent(updateStudent) async {
//   int count = await db
//       .rawUpdate('UPDATE student SET name = ?, value = ? WHERE name = ?', [
//     updateStudent.name,
//     updateStudent.age,
//     updateStudent.guardian,
//     updateStudent.contact
//   ]);
//   await getData();
//   print('updated: $count');

// }

// Load initial data
// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_app/dbModel/db_model.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);
late Database db;

Future<void> initializeDatabase() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'student.db');
  db = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE student (id INTEGER PRIMARY KEY, name TEXT, age TEXT, guardian TEXT, contact TEXT, image BLOB)');
    },
  );
  await getData();
}

Future<void> addStudent(StudentModel student) async {
  print('hello');
  try {
    await db.rawInsert(
      'INSERT INTO student (name, age, guardian, contact, image) VALUES (?, ?, ?, ?, ?)',
      [
        student.name,
        student.age,
        student.guardian,
        student.contact,
        student.image,
      ],
    );
    await getData();
  } catch (e) {
    print("Error inserting student: $e");
  }
}

Future<void> getData() async {
  final values = await db.rawQuery('SELECT * FROM student');
  studentListNotifier.value = values.map((map) {
    return StudentModel.fromMap(map);
  }).toList();

  studentListNotifier.notifyListeners();
}

Future<void> deleteStudent(int id) async {
  await db.rawDelete('DELETE FROM student WHERE id = ?', [id]);
  await getData();
}

Future<void> updateStudent(StudentModel updatedStudent) async {
  print('in function');
  try {
    int count = await db.rawUpdate(
        'UPDATE student SET name = ?, age = ?, guardian = ?, contact = ?, image = ? WHERE id = ?',
        [
          updatedStudent.name,
          updatedStudent.age,
          updatedStudent.guardian,
          updatedStudent.contact,
          updatedStudent.image,
          updatedStudent.id
        ]);
    await getData();
  } catch (e) {
    print('Error during update: $e');
    throw e; // Re-throw the exception to be handled by the caller
  }
  print('after update funct process');
}
