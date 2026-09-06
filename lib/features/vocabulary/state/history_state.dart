import 'package:flutter/material.dart';

import 'package:vocabulary_tracker/features/vocabulary/data/vocabulary.dart';
import 'package:vocabulary_tracker/features/vocabulary/presentation/history_screen.dart';

import 'package:vocabulary_tracker/helpers.dart';

class HistoryState extends State<HistoryBody> {
  @override
  Widget build(BuildContext context) {
    return
    // 1. Listen to the shared notifier passed from the Dashboard
    ValueListenableBuilder<int>(
      valueListenable: widget.dbUpdateNotifier,
      builder: (context, updateCount, child) {
        // 2. Every time updateCount changes, this FutureBuilder fires again
        return FutureBuilder(
          future: Vocabulary(AppDatabase.instance).getVocabulary(),
          builder: (context, snapshot) {
            // 1. Show loading spinner while waiting
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Show error message if something goes wrong
            if (snapshot.hasError) {
              return Center(child: Text('ERROR: ${snapshot.error}'));
            }

            // 3. Handle empty or null data
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No tracking found'));
            }

            // 4. Extract data and build a list widget
            final List<Map<String, dynamic>> vocabulary = snapshot.data!;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dataRowMaxHeight: double.infinity,
                  headingTextStyle: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  columns: [
                    DataColumn(label: Text('Word')),
                    DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Source')),
                    DataColumn(label: Text('Translation')),
                    DataColumn(label: Text('Learned At')),
                    DataColumn(label: Text('Learned By')),
                  ],
                  rows: vocabulary.map((word) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(word['word']),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                word['description'],
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(word['source']),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(word['translation']),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              DateTime.parse(word['date']).readableFormat(),
                            ),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(word['username']),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
