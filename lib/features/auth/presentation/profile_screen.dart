import 'package:flutter/material.dart';

import 'package:vocabulary_tracker/features/auth/presentation/auth_screen.dart';

import 'package:vocabulary_tracker/helpers.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  late Future<List<Map<String, Object?>>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
  }

  Future<List<Map<String, Object?>>> _fetchUserData() async {
    String username = await Authentication.getUsername();
    return await Authentication(AppDatabase.instance)
        .getUser(username: username);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        width: 500,
        child: FutureBuilder<List<Map<String, Object?>>>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('ERROR: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No tracking found'));
            }

            final List<Map<String, Object?>> vocabulary = snapshot.data!;

            return ListView(
              shrinkWrap: true,
              children: [
                for (var user in vocabulary) ...[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('Username: ${user['username']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('Email: ${user['email']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Created At: ${DateTime.parse(user['created_at'].toString()).readableFormat()}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(child: LogoutButton()),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await Authentication.logout();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) =>
                false, // This condition removes all previous routes
          );
        }
      },
      backgroundColor: Colors.red,
      child: SizedBox(child: Text('Logout')),
    );
  }
}
