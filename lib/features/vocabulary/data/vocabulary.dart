import 'package:sqflite/sqflite.dart';
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
    } on DatabaseException catch (e) {
      // Check if it's a unique constraint failure (SQLite error code 1555 or string match)
      if (e.isUniqueConstraintError()) {
        return 'Failed: This word already exists';
      } else {
        return 'Database error: ${e.toString()}';
      }
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  Future<List<Map<String, dynamic>>> getVocabulary({String? username}) async {
    final db = await _db.database;

    if (username == null) {
      return db.query('vocabulary');
    }
    return db.query('vocabulary', where: 'username = ?', whereArgs: [username]);
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
