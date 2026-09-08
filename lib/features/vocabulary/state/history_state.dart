import 'package:flutter/material.dart';

import 'package:vocabulary_tracker/features/vocabulary/data/vocabulary.dart';
import 'package:vocabulary_tracker/features/vocabulary/presentation/history_screen.dart';

import 'package:vocabulary_tracker/helpers.dart';

class HistoryState extends State<HistoryBody> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      // 1. Listen to the shared notifier passed from the Dashboard
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

            final List<Map<String, dynamic>> vocabulary;
            final bool action;

            // 3. Handle empty or null data
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              vocabulary = [
                {
                  'word': '',
                  'description': '',
                  'source': '',
                  'translation': '',
                  'date': '',
                  'username': '',
                },
              ];
              action = false;
            } else {
              // 4. Extract data and build a list widget
              vocabulary = snapshot.data!;
              action = true;
            }

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
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
                  DataColumn(
                    label: Visibility(visible: action, child: Text('Action')),
                  ),
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
                          child: Text(
                            word['translation'] == ''
                                ? 'No Translation Added'
                                : word['translation'],
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            word['date'] == ''
                                ? ''
                                : DateTime.parse(word['date']).readableFormat(),
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(word['username']),
                        ),
                      ),
                      DataCell(
                        Visibility(
                          visible: action,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: FilledButton(
                              onPressed: () async {
                                Vocabulary(AppDatabase.instance)
                                    .deleteWord(word['word']);
                                setState(() {});
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Colors.red,
                                ),
                              ),
                              child: Text(
                                'Remove',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}
