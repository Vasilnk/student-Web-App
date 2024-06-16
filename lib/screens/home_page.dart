import 'package:flutter/material.dart';
import 'package:student_app/dbHelper/db_functions.dart';
import 'package:student_app/dbModel/db_model.dart';
import 'package:student_app/screens/add_page.dart';
import 'package:student_app/screens/edit_page.dart';
import 'package:student_app/screens/student_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGridView = true;
  TextEditingController searchController = TextEditingController();
  List<StudentModel> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterStudents);
    searchController.dispose();
    super.dispose();
  }

  void _filterStudents() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredStudents = studentListNotifier.value
          .where(
              (student) => (student.name?.toLowerCase() ?? '').contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search',
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<StudentModel>>(
              valueListenable: studentListNotifier,
              builder: (context, students, child) {
                if (searchController.text.isEmpty) {
                  filteredStudents = students;
                }
                return isGridView
                    ? buildGridView(filteredStudents)
                    : buildListView(filteredStudents);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudentPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildGridView(List<StudentModel> students) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 1,
      ),
      itemCount: students.length,
      padding: EdgeInsets.all(20),
      itemBuilder: (context, index) {
        final student = students[index];
        return Container(
          color: Colors.blue[200],
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(student)));
            },
            child: GridTile(
              header: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  CircleAvatar(
                    radius: 30,
                    // backgroundImage: student.imagePath != null
                    //     ? FileImage(File(student.imagePath!))
                    //     : null,
                    // child: student.imagePath == null
                    //     ? const Icon(Icons.person)
                    //     : null,
                  ),
                  SizedBox(height: 10),
                  Text(student.name),
                  // Text('Age: ${student.age}'),
                ],
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => EditStudentPage(student: student),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this student?'),
                            actions: [
                              TextButton(
                                child: const Text('No'),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () async {
                                  await deleteStudent(student.id!);
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildListView(List<StudentModel> students) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final student = students[index];
        return Container(
          color: Colors.blue[200],
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(student)));
            },
            title: Text(student.name),
            leading: CircleAvatar(
                // backgroundImage: student.imagePath != null
                //     ? FileImage(File(student.imagePath!))
                //     : null,
                // child: student.imagePath == null
                //     ? const Icon(Icons.person)
                //     : null,
                ),
            // subtitle: Text('Age: ${student.age}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => EditStudentPage(student: student),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text(
                            'Are you sure you want to delete this student?'),
                        actions: [
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () async {
                              await deleteStudent(student.id!);
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: students.length,
    );
  }
}
