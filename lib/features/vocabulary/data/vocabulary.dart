import 'package:vocabulary_tracker/helpers.dart';

class Vocabulary {
  final AppDatabase _db;
  Vocabulary(this._db);

  Future<String> track(
    String word,
    String description,
    String source, {
    String translation = '',
  }) async {
    final db = await _db.database;

    Map<String, Object?> values = {
      'word': word,
      'description': description,
      'source': source,
      'translation': translation,
      'date': DateTime.now().toString().split('.').first,
      'username': await PreferenceManager.getUsername(),
    };

    try {
      await db.insert('vocabulary', values);
      return 'success';
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  Future<List<Map<String, dynamic>>> getVocabulary({int id = 0}) async {
    final db = await _db.database;

    if (id == 0) {
      return db.query('vocabulary');
    }
    return db.query('vocabulary', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateWord(
    int id,
    String word,
    String description,
    String source,
    String translation,
  ) async {
    // Get a reference to the database.
    final db = await _db.database;

    Map<String, Object?> values = {
      'word': word,
      'description': description,
      'source': source,
      'translation': translation,
      'date': DateTime.now().toString().split('.').first,
      'username': await PreferenceManager.getUsername(),
    };

    await db.update(
      'vocabulary',
      values,
      where: 'vocabulary_id = id',
      whereArgs: [id],
    );
  }

  void deleteWord(String word) async {
    final db = await _db.database;

    await db.delete('vocabulary', where: 'word = ?', whereArgs: [word]);
  }
}
