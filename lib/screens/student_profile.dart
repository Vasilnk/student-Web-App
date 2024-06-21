import 'package:flutter/material.dart';
import 'package:student_app/dbModel/db_model.dart';

class ProfilePage extends StatelessWidget {
  final StudentModel student;

  const ProfilePage(this.student, {super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            CircleAvatar(
              radius: 80,
              backgroundImage:
                  student.image != null ? MemoryImage(student.image!) : null,
              child: student.image == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(height: 80),
            Container(
              decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(18.0),
              width: 350,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name        : ${student.name}', style: textStyle),
                  const SizedBox(
                    height: 13,
                  ),
                  Text('Age           : ${student.age}', style: textStyle),
                  const SizedBox(
                    height: 13,
                  ),
                  Text('Guardian  : ${student.guardian}', style: textStyle),
                  const SizedBox(
                    height: 13,
                  ),
                  Text('Phone      : ${student.contact}', style: textStyle),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
