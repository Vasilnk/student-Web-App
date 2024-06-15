import 'package:flutter/material.dart';
import 'package:student_app/screens/home_page.dart';
import 'package:student_app/dbHelper/db_functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(centerTitle: true, color: Colors.green)),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
