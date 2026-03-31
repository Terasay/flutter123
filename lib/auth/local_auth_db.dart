import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthDb {
  LocalAuthDb._();

  static final LocalAuthDb instance = LocalAuthDb._();

  static const String _dishFavoritesKey = 'favorite_dishes_v2';
  static const String _chefFavoritesKey = 'favorite_chefs_v2';

  Future<Set<String>> _readFavorites(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(key) ?? const <String>[];
    return values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet();
  }

  Future<void> _saveFavorites({
    required String key,
    required Set<String> values,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final sortedValues = values.toList()..sort();
    await prefs.setStringList(key, sortedValues);
  }

  Future<Set<String>> getDishFavoritesForCurrentAccount() {
    return _readFavorites(_dishFavoritesKey);
  }

  Future<void> setDishFavoriteForCurrentAccount({
    required String dishTitle,
    required bool isFavorite,
  }) async {
    final normalizedDishTitle = dishTitle.trim();
    if (normalizedDishTitle.isEmpty) {
      return;
    }

    final favorites = await _readFavorites(_dishFavoritesKey);
    if (isFavorite) {
      favorites.add(normalizedDishTitle);
    } else {
      favorites.remove(normalizedDishTitle);
    }

    await _saveFavorites(key: _dishFavoritesKey, values: favorites);
  }

  Future<Set<String>> getChefFavoritesForCurrentAccount() {
    return _readFavorites(_chefFavoritesKey);
  }

  Future<void> setChefFavoriteForCurrentAccount({
    required String chefName,
    required bool isFavorite,
  }) async {
    final normalizedChefName = chefName.trim();
    if (normalizedChefName.isEmpty) {
      return;
    }

    final favorites = await _readFavorites(_chefFavoritesKey);
    if (isFavorite) {
      favorites.add(normalizedChefName);
    } else {
      favorites.remove(normalizedChefName);
    }

    await _saveFavorites(key: _chefFavoritesKey, values: favorites);
  }
}
