import 'package:flutter/material.dart';

import 'package:vocabulary_tracker/features/vocabulary/presentation/track_screen.dart';
import 'package:vocabulary_tracker/features/vocabulary/data/vocabulary.dart';

import 'package:vocabulary_tracker/helpers.dart';

class TrackState extends State<TrackScreen> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _word = '';
  String _description = '';
  String _source = '';
  String _translation = '';

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // Always dispose your controllers to avoid memory leaks!
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: 500,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Form(
          key: _formGlobalKey,
          child: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              children: [
                // heading
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Track',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),

                // input word
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLength: 255,
                    decoration: InputDecoration(
                      label: Text('word'),
                      hint: Text('Diligence...'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      errorMaxLines: 3,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'word can\'t be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _word = value!.toLowerCase().capitalize();
                    },
                  ),
                ),

                // input description
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    maxLength: 511,
                    decoration: InputDecoration(
                      label: Text('Description'),
                      hint: Text(
                        'the quality of working carefully and with a lot of effort...',
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior
                          .always, // Keeps label at the top
                      alignLabelWithHint: true,
                      errorMaxLines: 3,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description can\'t be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description = value!;
                    },
                  ),
                ),

                // input source
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLength: 255,
                    decoration: InputDecoration(
                      label: Text('Source'),
                      hint: Text('Cambridge Dictionary...'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      errorMaxLines: 3,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Source can\'t be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _source = value!;
                    },
                  ),
                ),

                // input translation
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLength: 511,
                    decoration: InputDecoration(
                      label: Text('Translation (optional)'),
                      hint: Text('ketekunan...'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      errorMaxLines: 3,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    onSaved: (value) {
                      _translation = value!;
                    },
                  ),
                ),

                // submit button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    onPressed: () async {
                      if (_formGlobalKey.currentState!.validate()) {
                        _formGlobalKey.currentState!.save();
                        print('tracking...');

                        String result = await Vocabulary(AppDatabase.instance)
                            .track(
                              _word,
                              _description,
                              _source,
                              translation: _translation,
                            );

                        setState(() {
                          if (result == 'success') {
                            if (context.mounted) {
                              // Show the backend error message (e.g., 'Email already in use') via SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Tracked successfully')),
                              );
                              widget.dbUpdateNotifier.value++;
                            }
                          } else {
                            if (context.mounted) {
                              // Show the backend error message (e.g., 'Email already in use') via SnackBar
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(result)));
                            }
                          }
                        });
                        _formGlobalKey.currentState!.reset();
                      }
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Track'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
