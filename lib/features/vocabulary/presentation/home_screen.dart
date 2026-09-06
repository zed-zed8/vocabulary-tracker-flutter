import 'package:flutter/material.dart';

import 'package:vocabulary_tracker/helpers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Welcome To Vocabulary Tracker',
        style: TextStyle(
          fontSize: TextHelpers.responsiveFontSize(
            context,
            minSize: 22.0,
            maxSize: 40.0,
          ),
        ),
      ),
    );
  }
}
