import 'package:budgetbuddy_client/features/auth/pages/root_page.dart';
import 'package:budgetbuddy_client/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart'; // make sure this file exists (from flutterfire configure)
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BudgetBuddy',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RootPage(),
    );
  }
}
