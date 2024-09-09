import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/database/db_functions.dart';
import 'package:student_app/database/db_model.dart';
import 'package:student_app/screens/about_page.dart';
import 'package:student_app/screens/add_page.dart';
import 'package:student_app/screens/grid_view.dart';
import 'package:student_app/screens/list_view.dart';
import 'package:student_app/screens/logout.dart';
import 'package:student_app/screens/privacy_policy.dart';
import 'package:student_app/screens/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGridView = false;
  TextEditingController searchController = TextEditingController();
  List<StudentDBModel> filteredStudents = [];
  String? schoolName;

  @override
  void initState() {
    super.initState();
    getStudents();
    searchController.addListener(_filterStudents);
    get();
  }

  @override
  void dispose() {
    searchController.removeListener(_filterStudents);
    searchController.dispose();
    super.dispose();
  }

  get() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    final school = sharedPreference.get('schoolName');
    setState(() {
      schoolName = school.toString();
    });
  }

  void _filterStudents() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredStudents = studentListNotifier.value
          .where((student) => student.name.toLowerCase().contains(query))
          .toList();
    });
  }

  final List<Map<String, dynamic>> sidePanelItems = [
    {
      'icon': Icons.person,
      'title': 'Profile',
      'screen': const SchoolProfileScreen()
    },
    {
      'icon': Icons.grid_view_sharp,
      'title': 'Grid view',
    },
    {
      'icon': Icons.logout_outlined,
      'title': 'Log Out',
    },
    {
      'icon': Icons.privacy_tip,
      'title': 'Privacy and Policy',
      'screen': const PrivacyPolicyPage()
    },
    {'icon': Icons.info, 'title': 'About', 'screen': const AboutPage()}
  ];
  bool switchOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Row(
        children: [
          Container(
            color: Colors.blue[200],
            width: 230,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/images/school.jpeg'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        schoolName!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 5,
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final item = sidePanelItems[index];
                      return ListTile(
                        trailing: index == 1
                            ? Transform.scale(
                                scale: 0.7,
                                child: Switch(
                                    value: switchOn,
                                    onChanged: (value) {
                                      setState(() {
                                        switchOn = value;
                                      });
                                    }),
                              )
                            : null,
                        leading: Icon(item['icon']),
                        title: Text(item['title']),
                        onTap: () {
                          if (index != 1 && index != 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => item['screen'],
                              ),
                            );
                          } else if (index == 2) {
                            logoutFunction(context);
                          }
                        },
                      );
                    },
                    itemCount: sidePanelItems.length,
                  ),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddStudentPage(),
                      ),
                    );
                  },
                  label: const Text('Add Student'),
                  icon: const Icon(Icons.add),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                        child: Icon(Icons.search),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<List<StudentDBModel>>(
                    valueListenable: studentListNotifier,
                    builder: (context, students, child) {
                      if (searchController.text.isEmpty) {
                        filteredStudents = students;
                      }
                      if (filteredStudents.isEmpty) {
                        return const Center(
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school,
                                size: 150,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'No students added',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )),
                        );
                      }
                      return switchOn
                          ? GridViewBuilder(filteredStudents)
                          : ListViewBuilder(filteredStudents);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
