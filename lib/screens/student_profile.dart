import 'package:flutter/material.dart';
import 'package:student_app/dbModel/db_model.dart';
// import 'package:student_app/models/student_model.dart';

class ProfilePage extends StatelessWidget {
  final StudentModel student;

  ProfilePage(this.student, {super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 28,
      color: Colors.black,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Container(
          // padding: EdgeInsets.all(16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              CircleAvatar(
                radius: 60,
                // backgroundImage: AssetImage(''),
              ),
              SizedBox(height: 80),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name        : ${student.name}', style: textStyle),
                    Text('Age           : ${student.age}', style: textStyle),
                    Text('Guardian  : ${student.guardian}', style: textStyle),
                    Text('Phone      : ${student.contact}', style: textStyle),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                ),
                padding: EdgeInsets.all(18.0),
                width: double.infinity,
                height: 300,
              )
            ],
          ),
        ),
      ),
    );
  }
}
