import 'package:flutter/material.dart';

import 'package:vocabulary_tracker/features/vocabulary/presentation/home_screen.dart';
import 'package:vocabulary_tracker/features/vocabulary/presentation/track_screen.dart';
import 'package:vocabulary_tracker/features/vocabulary/presentation/history_screen.dart';
import 'package:vocabulary_tracker/features/auth/presentation/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // 1. Create a shared notifier. It can just track an incrementing integer
  // or a boolean to signal "data has changed".
  final ValueNotifier<int> _dbUpdateNotifier = ValueNotifier<int>(0);

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // 3. Initialize the pages and pass the shared notifier
    _pages = [
      HomeScreen(),
      TrackScreen(dbUpdateNotifier: _dbUpdateNotifier),
      HistoryScreen(dbUpdateNotifier: _dbUpdateNotifier),
      ProfileScreen(),
    ];
  }

  @override
  void dispose() {
    _dbUpdateNotifier.dispose(); // Always clean up your notifiers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: 'Write',
          ),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
