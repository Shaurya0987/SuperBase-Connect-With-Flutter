import 'package:flutter/material.dart';
import 'supabase_service.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final SupabaseService supabaseService = SupabaseService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  List<dynamic> students = [];
  String? selectedId; // will always be a String

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  // READ — fetch student list
  Future<void> fetchStudents() async {
    final data = await supabaseService.getStudents();
    setState(() {
      students = data;
    });
  }

  // CREATE
  Future<void> createStudent() async {
    await supabaseService.createStudent(
      nameController.text,
      int.parse(ageController.text),
    );

    nameController.clear();
    ageController.clear();
    fetchStudents();
  }

  // UPDATE
  Future<void> updateStudent() async {
    if (selectedId == null) return;

    await supabaseService.updateStudent(
      selectedId!,                        // always string now
      nameController.text,
      int.parse(ageController.text),
    );

    selectedId = null;
    nameController.clear();
    ageController.clear();
    fetchStudents();
  }

  // DELETE
  Future<void> deleteStudent(String id) async {
    await supabaseService.deleteStudent(id);
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade200,
      appBar: AppBar(title: const Text("Supabase CRUD Example")),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // FORM -------------------------
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Age"),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: createStudent,
                  child: const Text("Create"),
                ),
                ElevatedButton(
                  onPressed: updateStudent,
                  child: const Text("Update"),
                ),
              ],
            ),

            const Divider(height: 30),

            // LIST OF STUDENTS -------------------------
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];

                  return ListTile(
                    title: Text(student['name']),
                    subtitle: Text("Age: ${student['age']}"),

                    onTap: () {
                      // Load selected data into textfields for update
                      setState(() {
                        selectedId = student['id'].toString();   // FIXED
                        nameController.text = student['name'];
                        ageController.text = student['age'].toString();
                      });
                    },

                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteStudent(student['id'].toString()); // FIXED
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
