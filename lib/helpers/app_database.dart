import 'dart:convert';

import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Required for Windows

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vocabulary_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // 1. Initialize FFI if running on Windows or Linux
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users(
        user_id INTEGER PRIMARY KEY, 
        username TEXT NOT NUll UNIQUE, 
        email TEXT NOT NUll UNIQUE,
        password TEXT NOT NUll
      );
      ''');

    // vocabulary table
    // date format: "Y-m-d H:m:s"
    // (optional) translation
    await db.execute('''
      CREATE TABLE vocabulary(
        vocabulary_id INTEGER PRIMARY KEY, 
        word TEXT NOT NUll, 
        description TEXT NOT NUll,
        source TEXT NOT NUll,
        translation TEXT,
        date TEXT NOT NUll, 
        username TEXT NOT NUll
      );
      ''');

    // Seed a default mock user for testing your side project
    await db.insert('users', {
      'username': 'user',
      'email': 'user@users.com',
      'password': base64Encode(utf8.encode('password')),
    });

    // Seed a default mock word for testing your side project
    await db.insert('vocabulary', {
      'word': 'synchronous'.toLowerCase(),
      'description': 'happening or done at the same time or speed:',
      'source': 'Cambridge Dictionary',
      'translation': 'Synchronous (atau sinkronus) artinya terjadi pada waktu yang bersamaan atau secara real-time',
      'date': DateTime.now().toString().split('.').first,
      'username': '1',
    });
  }
}
