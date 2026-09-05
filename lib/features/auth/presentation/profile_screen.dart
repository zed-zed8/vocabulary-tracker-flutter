import 'package:flutter/material.dart';

import 'package:vocabulary_tracker/features/auth/data/authentication.dart';
import 'package:vocabulary_tracker/features/auth/presentation/auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: FloatingActionButton(
        onPressed: () async {
          await Authentication.logout();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const LoginScreen(),
              ),
              (Route<dynamic> route) =>
                  false, // This condition removes all previous routes
            );
          }
        },
        backgroundColor: Colors.red,
        child: Text('Logout'),
      ),
    );
  }
}
