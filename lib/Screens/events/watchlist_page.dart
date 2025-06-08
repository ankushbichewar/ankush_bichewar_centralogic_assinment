import 'package:ankush_bichewar_centralogic_assinment/services/local_storage.dart';
import 'package:flutter/material.dart';
import '../../models/movie_model.dart';
class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Watchlist',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.amber),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.amber),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: LocalStorageService.getWatchlist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          }

          final movies = snapshot.data ?? [];

          return movies.isEmpty
              ? const Center(
                  child: Text(
                    "No movies in watchlist.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: movies.length,
                  itemBuilder: (_, index) {
                    final movie = movies[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: [Colors.amber, Colors.blue],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3), // Border thickness
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Image.network(
                                movie.posterUrl,
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height: 200,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey,
                                  child: const Icon(Icons.broken_image, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.play_circle_fill, size: 50, color: Colors.amber),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Continue watching',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
