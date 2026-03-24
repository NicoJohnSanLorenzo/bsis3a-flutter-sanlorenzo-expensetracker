import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/expenses_provider.dart';
import 'screens/home_screen.dart';

// WidgetsFlutterBinding.ensureInitialized() is required before any plugin
// (sqflite, shared_preferences) is used during app startup.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ExpensesProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      home: const HomeScreen(),
    );
  }
}
