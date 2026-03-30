import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthDb {
  LocalAuthDb._();

  static final LocalAuthDb instance = LocalAuthDb._();

  static const String _usersKey = 'local_users_v1';
  static const String _currentAccountKey = 'current_account_v1';
  static const String _dishFavoritesPrefix = 'favorite_dishes_v1';
  static const String _chefFavoritesPrefix = 'favorite_chefs_v1';

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

  String _favoritesKey({required String prefix, required String account}) {
    return '${prefix}_${account.trim().toLowerCase()}';
  }

  Future<void> setCurrentAccount(String account) async {
    final normalizedAccount = account.trim();
    final prefs = await SharedPreferences.getInstance();
    if (normalizedAccount.isEmpty) {
      await prefs.remove(_currentAccountKey);
      return;
    }
    await prefs.setString(_currentAccountKey, normalizedAccount);
  }

  Future<String?> getCurrentAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final account = prefs.getString(_currentAccountKey)?.trim();
    if (account == null || account.isEmpty) {
      return null;
    }
    return account;
  }

  Future<Set<String>> _readFavoritesForCurrentAccount(String prefix) async {
    final account = await getCurrentAccount();
    if (account == null) {
      return <String>{};
    }

    final key = _favoritesKey(prefix: prefix, account: account);
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(key) ?? const <String>[];
    return values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet();
  }

  Future<void> _saveFavoritesForCurrentAccount({
    required String prefix,
    required Set<String> values,
  }) async {
    final account = await getCurrentAccount();
    if (account == null) {
      return;
    }

    final key = _favoritesKey(prefix: prefix, account: account);
    final prefs = await SharedPreferences.getInstance();
    final sortedValues = values.toList()..sort();
    await prefs.setStringList(key, sortedValues);
  }

  Future<Set<String>> getDishFavoritesForCurrentAccount() {
    return _readFavoritesForCurrentAccount(_dishFavoritesPrefix);
  }

  Future<void> setDishFavoriteForCurrentAccount({
    required String dishTitle,
    required bool isFavorite,
  }) async {
    final normalizedDishTitle = dishTitle.trim();
    if (normalizedDishTitle.isEmpty) {
      return;
    }

    final favorites = await _readFavoritesForCurrentAccount(
      _dishFavoritesPrefix,
    );
    if (isFavorite) {
      favorites.add(normalizedDishTitle);
    } else {
      favorites.remove(normalizedDishTitle);
    }

    await _saveFavoritesForCurrentAccount(
      prefix: _dishFavoritesPrefix,
      values: favorites,
    );
  }

  Future<Set<String>> getChefFavoritesForCurrentAccount() {
    return _readFavoritesForCurrentAccount(_chefFavoritesPrefix);
  }

  Future<void> setChefFavoriteForCurrentAccount({
    required String chefName,
    required bool isFavorite,
  }) async {
    final normalizedChefName = chefName.trim();
    if (normalizedChefName.isEmpty) {
      return;
    }

    final favorites = await _readFavoritesForCurrentAccount(
      _chefFavoritesPrefix,
    );
    if (isFavorite) {
      favorites.add(normalizedChefName);
    } else {
      favorites.remove(normalizedChefName);
    }

    await _saveFavoritesForCurrentAccount(
      prefix: _chefFavoritesPrefix,
      values: favorites,
    );
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
