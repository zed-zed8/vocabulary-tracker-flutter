import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Required for Windows

import 'package:vocabulary_tracker/database/app_database.dart';
import 'package:vocabulary_tracker/helpers/preference_manager.dart';

class Authentication {
  final AppDatabase _db;
  Authentication(this._db);

  /// Register a new user
  ///
  /// returns a string 'success' on success or an error message
  Future<String> register(
    String username,
    String email,
    String password,
  ) async {
    final db = await _db.database;
    // Encode password using dart:convert
    String encodedPassword = base64Encode(utf8.encode(password));
    Map<String, Object?> values = {
      'username': username,
      'email': email,
      'password': encodedPassword,
    };

    try {
      await db.insert(
        'users',
        values,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      print('User $username registered successfully.');
      return 'success';
    } on DatabaseException catch (e) {
      // Check if it's a unique constraint failure (SQLite error code 1555 or string match)
      if (e.isUniqueConstraintError()) {
        return 'Failed: This username or email already exists';
      } else {
        return 'Database error: ${e.toString()}';
      }
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  /// Authenticate an existing user
  /// returns a string 'success' on success or an error message
  Future<String> login(String username, String password) async {
    final db = await _db.database;
    if (!await isUserExist(username)) {
      print('User not found');
      return 'User not found';
    }

    // Encode input and compare with stored data
    String encodedInput = base64Encode(utf8.encode(password));
    final List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT password FROM users WHERE username = ?',
      [username],
    );
    if (results.isNotEmpty) {
      // Extract string value from the map key
      String storedPassword = results.first['password'] as String;

      if (storedPassword == encodedInput) {
        print('success');
        PreferenceManager.setLoginStatus(true, username);
        return 'success';
      }
    }

    print('Incorrect password');
    return 'Incorrect password';
  }

  Future<bool> isUserExist(String username) async {
    final db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );

    return maps.isNotEmpty;
  }

  /// logout of the current user
  static Future<void> logout() async {
    await PreferenceManager.sessionLogout();
  }

  /// check if logged in but from auth
  static Future<bool> isLoggedIn() async {
    return await PreferenceManager.isLoggedIn();
  }

  /// get username but from auth
  static Future<String> getUsername() async {
    return await PreferenceManager.getUsername();
  }

  /// get the user profile
  /// make sure user isnt empty
  Future<Map<String, Object?>> profile(String username) async {
    final db = await _db.database;
    final List<Map<String, Object?>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1, // Optional: Optimizes the query since you only need one row
    );

    return maps.first;
  }
}

// Auth Helpers
class AuthHelpers {
  /// determine if email is valid using regex
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@'
      r'((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    return emailRegex.hasMatch(email);
  }
}
