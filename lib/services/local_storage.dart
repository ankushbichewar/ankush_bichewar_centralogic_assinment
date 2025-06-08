import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie_model.dart';

class LocalStorageService {
  static const _bookmarkKey = 'bookmarks';
  static const _watchlistKey = 'watchlist';

  static Future<void> addToBookmarks(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = prefs.getStringList(_bookmarkKey) ?? [];
    final exists = data.any((item) => Movie.fromJson(jsonDecode(item)).title == movie.title);
    if (!exists) {
      data.add(jsonEncode(movie.toJson()));
      await prefs.setStringList(_bookmarkKey, data);
    }
  }

  static Future<List<Movie>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = prefs.getStringList(_bookmarkKey) ?? [];
    return data.map((e) => Movie.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> removeFromBookmarks(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = prefs.getStringList(_bookmarkKey) ?? [];
    data.removeWhere((item) => Movie.fromJson(jsonDecode(item)).title == movie.title);
    await prefs.setStringList(_bookmarkKey, data);
  }

  static Future<void> addToWatchlist(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = prefs.getStringList(_watchlistKey) ?? [];

    // Remove if already exists
    data.removeWhere((item) => Movie.fromJson(jsonDecode(item)).title == movie.title);

    // Add to front
    data.insert(0, jsonEncode(movie.toJson()));

    // Keep only last 5
    if (data.length > 5) {
      data.removeRange(5, data.length);
    }

    await prefs.setStringList(_watchlistKey, data);
  }

  static Future<List<Movie>> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = prefs.getStringList(_watchlistKey) ?? [];
    return data.map((e) => Movie.fromJson(jsonDecode(e))).toList();
  }
}
