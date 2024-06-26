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
  final values = await db.rawQuery('SELECT * FROM student ');
  studentListNotifier.value = values.map((map) {
    return StudentModel.fromMap(map);
  }).toList();

  studentListNotifier.notifyListeners();
  print(values);
}

Future<void> deleteStudent(int id) async {
  await db.rawDelete('DELETE FROM student WHERE id = ?', [id]);
  await getData();
}

Future<void> updateStudent(StudentModel updatedStudent) async {
  try {
    await db.rawUpdate(
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
    throw e;
  }
  print('after update funct process');
}
