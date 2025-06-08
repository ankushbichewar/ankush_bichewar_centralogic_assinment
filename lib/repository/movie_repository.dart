// lib/repository/movie_repository.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/movie_model.dart';

class MovieRepository {
  Future<List<Movie>> loadMovies() async {
    final String response = await rootBundle.loadString('assets/movies.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Movie.fromJson(json)).toList();
  }
}
