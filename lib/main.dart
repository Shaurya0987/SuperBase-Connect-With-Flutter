
import 'package:MyAppSupaBase/todoListScreen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kgugelulxaiysvmjyvbx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtndWdlbHVseGFpeXN2bWp5dmJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwNjQ2OTksImV4cCI6MjA3ODY0MDY5OX0.q0YbBzSdqa5sAWqxkE9x751lkrLBjxD_1NhaxYSmusI'
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const mainScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  /// Fetch notes from Supabase
  Future<void> loadNotes() async {
    final result =
        await Supabase.instance.client.from('Notes').select() as List<dynamic>;

    setState(() {
      notes = result.reversed.toList(); // newest first
    });
  }

  /// Insert a new note
  Future<void> addNote(String text) async {
    await Supabase.instance.client.from('Notes').insert({'body': text});
    loadNotes(); // refresh UI
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController noteController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        centerTitle: true,
        elevation: 5,
      ),

      // Body UI
      body: notes.isEmpty
          ? const Center(
              child: Text(
                "No notes yet...",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      )
                    ],
                  ),
                  child: Text(
                    note['body'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add a Note"),
                content: TextField(
                  controller: noteController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Enter note...",
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final text = noteController.text.trim();
                      if (text.isNotEmpty) {
                        await addNote(text);
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
