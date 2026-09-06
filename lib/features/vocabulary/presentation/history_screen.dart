import 'package:flutter/material.dart';

import 'package:vocabulary_tracker/features/vocabulary/state/history_state.dart';

import 'package:vocabulary_tracker/helpers.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key, required this.dbUpdateNotifier});

  final ValueNotifier<int> dbUpdateNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Your Vocabulary History',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: TextHelpers.responsiveFontSize(
                  context,
                  minSize: 22.0,
                  maxSize: 40.0,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: HistoryBody(dbUpdateNotifier: dbUpdateNotifier),
        ),
      ],
    );
  }
}

class HistoryBody extends StatefulWidget {
  HistoryBody({super.key, required this.dbUpdateNotifier});

  final ValueNotifier<int> dbUpdateNotifier;

  @override
  State<HistoryBody> createState() => HistoryState();
}
