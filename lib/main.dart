import 'package:flutter/material.dart';
import 'package:vocabulary_tracker/features/auth/data/authentication.dart';

import 'helpers/app_database.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/auth/presentation/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database baseline right before running the visual tree
  await AppDatabase.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoTra',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.tealAccent,
          brightness: Brightness.dark, // Crucial for dark mode configuration
        ),
      ),
      themeMode: ThemeMode.system,

      home: AuthWrapper(),
    );
  }
}

// Separate widget handles the conditional UI rendering
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Authentication.isLoggedIn(),
      builder: (context, snapshot) {
        // 1. While waiting for the async function to finish, show a loading spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Once finished, route the user based on the boolean result
        if (snapshot.hasData && snapshot.data == true) {
          return const DashboardScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
