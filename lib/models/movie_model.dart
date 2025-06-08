// lib/models/movie_model.dart

class Movie {
  final String title;
  final String posterUrl;
  final String description;
  final double rating;
  final String duration;
  final String genre;
  final String releaseDate;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.description,
    required this.rating,
    required this.duration,
    required this.genre,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      posterUrl: json['posterUrl'],
      description: json['description'],
      rating: (json['rating'] as num).toDouble(),
      duration: json['duration'],
      genre: json['genre'],
      releaseDate: json['releaseDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'posterUrl': posterUrl,
      'description': description,
      'rating': rating,
      'duration': duration,
      'genre': genre,
      'releaseDate': releaseDate,
    };
  }
}
