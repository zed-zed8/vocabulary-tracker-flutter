import 'package:flutter/material.dart';

import 'package:vocabulary_tracker/features/auth/presentation/auth_screen.dart';
import 'package:vocabulary_tracker/features/vocabulary/data/vocabulary.dart';

import 'package:vocabulary_tracker/helpers.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              ),
            ),
            SizedBox(height: 10.0),
            ProfileBody(),
            SizedBox(height: 10.0),
            LogoutButton(),
          ],
        ),
      ),
    );
  }
}

class ProfileBody extends StatefulWidget {
  ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  late Future<List<Map<String, Object?>>> _userDataFuture;
  late Future<List<Map<String, Object?>>> _userVocabulary;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
    _userVocabulary = _fetchUserVocabulary();
  }

  Future<List<Map<String, dynamic>>> _fetchUserData() async {
    String username = await Authentication.getUsername();
    return await Authentication(AppDatabase.instance)
        .getUser(username: username);
  }

  Future<List<Map<String, dynamic>>> _fetchUserVocabulary() async {
    String username = await Authentication.getUsername();
    List<Map<String, dynamic>> vocabulary = await Vocabulary(
      AppDatabase.instance,
    ).getVocabulary(username: username);
    return vocabulary;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('ERROR: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No profile found'));
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
              FutureBuilder(
                future: _userVocabulary,
                builder: (context, asyncSnapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Words Tracked: ${asyncSnapshot.data?.length}'),
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
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
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
      child: Text('Logout', style: TextStyle(color: Colors.white)),
    );
  }
}
