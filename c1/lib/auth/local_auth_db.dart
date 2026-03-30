import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthDb {
  LocalAuthDb._();

  static final LocalAuthDb instance = LocalAuthDb._();

  static const String _usersKey = 'local_users_v1';

  Future<Map<String, String>> _readUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null || raw.isEmpty) {
      return <String, String>{};
    }

    final dynamic decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return <String, String>{};
    }

    return decoded.map((key, value) => MapEntry(key, value?.toString() ?? ''));
  }

  Future<void> _writeUsers(Map<String, String> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<bool> register({
    required String account,
    required String password,
  }) async {
    final normalizedAccount = account.trim();
    final normalizedPassword = password.trim();
    if (normalizedAccount.isEmpty || normalizedPassword.isEmpty) {
      return false;
    }

    final users = await _readUsers();
    if (users.containsKey(normalizedAccount)) {
      return false;
    }

    users[normalizedAccount] = normalizedPassword;
    await _writeUsers(users);
    return true;
  }

  Future<bool> validateLogin({
    required String account,
    required String password,
  }) async {
    final normalizedAccount = account.trim();
    final normalizedPassword = password.trim();
    if (normalizedAccount.isEmpty || normalizedPassword.isEmpty) {
      return false;
    }

    final users = await _readUsers();
    return users[normalizedAccount] == normalizedPassword;
  }
}
