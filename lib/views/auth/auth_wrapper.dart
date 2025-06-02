import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart'; // Corrected path
import '../dashboard/dashboard_screen.dart'; // Corrected path
import 'login_screen.dart'; // Corrected path

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Use a Consumer or listen directly to the provider's auth state
    if (authProvider.isAuthenticated) {
      // User is logged in, show the main app screen (Dashboard)
      return const DashboardScreen();
    } else {
      // User is not logged in, show the Login screen
      return const LoginScreen(); // Make sure LoginScreen exists
    }
    // Optional: Add a loading indicator while checking auth state initially
    // if (authProvider.isLoading && authProvider.user == null) {
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }
  }
}

