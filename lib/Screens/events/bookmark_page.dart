import 'package:ankush_bichewar_centralogic_assinment/Screens/widgets/bookmark_card.dart';
import 'package:flutter/material.dart';
import '../../services/local_storage.dart';
import '../../models/movie_model.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late Future<List<Movie>> _bookmarksFuture;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() {
    setState(() {
      _bookmarksFuture = LocalStorageService.getBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bookmarks',
          style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _bookmarksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final movies = snapshot.data ?? [];
          return movies.isEmpty
              ? const Center(
                  child: Text(
                    "No bookmarked movies.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: movies.length,
                  itemBuilder: (_, index) => BookmarkMovieCard(
                    movie: movies[index],
                    onRemove: _loadBookmarks,
                  ),
                );
        },
      ),
    );
  }
}
