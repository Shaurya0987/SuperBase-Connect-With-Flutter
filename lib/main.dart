
import 'package:MyAppSupaBase/screens/loginScreen.dart';
import 'package:MyAppSupaBase/screens/todoListScreen.dart';
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
      home: const LoginScreen(),
    );
  }
}

