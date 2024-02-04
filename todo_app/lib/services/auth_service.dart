import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/database/database.dart';

class AuthService {
  AppDatabase _db;
  final _userController = StreamController<User?>.broadcast();

  AuthService(BuildContext context)
      : _db = Provider.of<AppDatabase>(context, listen: false) {
    _db = Provider.of<AppDatabase>(context, listen: false);
  }

  Stream<User?> get userStream => _userController.stream;

  Future<User?> getUserByUsername(String username) =>
      _db.getUserByUsername(username);

  Future<int> createUser(String username) async {
    final UsersCompanion user = UsersCompanion(username: Value(username));
    return _db.addUser(user);
  }

  Future<bool> login(String username) async {
    final user = await getUserByUsername(username);
    if (user == null) {
      return false;
    }

    await _saveUsernameToSharedPrefs(username);
    _userController.add(user);

    return true;
  }

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username != null) {
      await login(username);
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    _userController.add(null);
  }

  Future<void> _saveUsernameToSharedPrefs(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }
}
