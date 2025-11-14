import 'package:MyAppSupaBase/supabase_service.dart';
import 'package:flutter/material.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  SupabaseService supabaseService = SupabaseService();

  List<dynamic> students = [];
  String? selectedId;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final data = await supabaseService.getStudents();
    setState(() {
      students = data;
    });
  }

  Future<void> createStudent() async {
    await supabaseService.createStudent(
      nameController.text,
      int.parse(ageController.text),
    );

    nameController.clear();
    ageController.clear();
    fetchStudents();
  }

  Future<void> updateStudent() async {
    if (selectedId == null) return;

    await supabaseService.updateStudent(
      selectedId!,
      nameController.text,
      int.parse(ageController.text),
    );

    selectedId = null;
    nameController.clear();
    ageController.clear();
    fetchStudents();
  }

  Future<void> deleteStudent(String id) async {
    await supabaseService.deleteStudent(id);
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title: Text(
          "SupaBase Demo With UI",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.help_outline,
              color: Colors.blue.shade900,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                label: Text("Enter Name..."),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13)),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: Text("Enter Age..."),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13)),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: createStudent, child: Text("Create")),
                ElevatedButton(
                    onPressed: updateStudent, child: Text("Update")),
              ],
            ),
            Divider(height: 50, color: Colors.black),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];

                  return ListTile(
                    title: Text(student['name']),
                    subtitle: Text("Age: ${student['age']}"),
                    onTap: () {
                      setState(() {
                        selectedId = student['id'].toString();
                        nameController.text = student['name'];
                        ageController.text =
                            student['age'].toString();
                      });
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteStudent(student['id'].toString());
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
