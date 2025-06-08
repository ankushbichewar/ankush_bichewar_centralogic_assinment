// lib/blocs/movie_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/movie_model.dart';
import '../repository/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;
  List<Movie> _allMovies = [];

  MovieBloc(this.repository) : super(MovieInitial()) {
    on<LoadMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        _allMovies = await repository.loadMovies();
        emit(MovieLoaded(_allMovies));
      } catch (e) {
        emit(MovieError('Failed to load movies'));
      }
    });

    on<SearchMovies>((event, emit) {
      final query = event.query.toLowerCase();
      final results = _allMovies
          .where((movie) => movie.title.toLowerCase().contains(query))
          .toList();
      emit(MovieLoaded(results));
    });
  }
}
