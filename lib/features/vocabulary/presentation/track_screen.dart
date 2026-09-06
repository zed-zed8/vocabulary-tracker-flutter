import 'package:flutter/material.dart';

import 'package:vocabulary_tracker/features/vocabulary/state/track_state.dart';

class TrackScreen extends StatefulWidget {
  TrackScreen({super.key, required this.dbUpdateNotifier});
  final ValueNotifier<int> dbUpdateNotifier;

  @override
  State<TrackScreen> createState() => TrackState();
}
