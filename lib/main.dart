import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Removed Provider imports

// Import Views (ensure paths are correct after potential restructuring)
import 'views/auth/login_screen.dart'; // Start with login
import 'views/auth/register_screen.dart';
import 'views/dashboard/dashboard_screen.dart';
import 'views/add_transaction/add_transaction_screen.dart';
import 'views/budgets/budget_screen.dart';
import 'views/goals/goal_screen.dart';
import 'views/reminders/reminder_screen.dart';
import 'views/profile/profile_screen.dart';

// Removed Firebase imports and initialization
// Removed Provider setup

void main() async {
  // No Firebase initialization needed
  // No Provider setup needed
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyAppSimplified());
}

class MyAppSimplified extends StatelessWidget {
  const MyAppSimplified({super.key});

  @override
  Widget build(BuildContext context) {
    // Removed MultiProvider wrapper
    return MaterialApp(
      title: 'Gestão Financeira (Screens Only)', // Updated title
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A1D37),
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A1D37),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
           backgroundColor: Color(0xFF0A1D37),
           foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF0A1D37), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: const TextStyle(color: Color(0xFF0A1D37)),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Start directly with LoginScreen
      home: const LoginScreen(),
      routes: {
        // Define routes for navigation between screens
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/add_transaction': (context) => const AddTransactionScreen(),
        '/budgets': (context) => const BudgetScreen(),
        '/goals': (context) => const GoalScreen(),
        '/reminders': (context) => const ReminderScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

