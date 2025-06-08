import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/movie_model.dart';
import '../../services/local_storage.dart';
import 'dart:async';

class DetailsPage extends StatefulWidget {
  final Movie movie;

  const DetailsPage({super.key, required this.movie});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with SingleTickerProviderStateMixin {
  bool isBookmarked = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
    _addToWatchlist();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkBookmarkStatus() async {
    final bookmarks = await LocalStorageService.getBookmarks();
    setState(() {
      isBookmarked = bookmarks.any((m) => m.title == widget.movie.title);
    });
  }

  Future<void> _toggleBookmark() async {
    if (isBookmarked) {
      final shouldRemove = await _showRemoveDialog();
      if (shouldRemove ?? false) {
        await LocalStorageService.removeFromBookmarks(widget.movie);
        setState(() {
          isBookmarked = false;
        });
      }
    } else {
      await LocalStorageService.addToBookmarks(widget.movie);
      setState(() {
        isBookmarked = true;
      });
    }
  }

  Future<void> _addToWatchlist() async {
    await LocalStorageService.addToWatchlist(widget.movie);
  }

  Future<bool?> _showRemoveDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Bookmark'),
        content: const Text('This movie is already bookmarked. Do you want to remove it?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Remove'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }

  void _shareMovie() {
    final text = '${widget.movie.title} (${widget.movie.releaseDate})\n\n${widget.movie.description}';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return SlideTransition(
      position: _slideAnimation,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 24, color: Color(0xFFD4AF37)),
            onPressed: () {
              _controller.reverse().then((_) => Navigator.pop(context));
            },
          ),
          title: const Text(
            'Details',
            style: TextStyle(color: Color(0xFFD4AF37), fontSize: 24, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                size: 26,
                color: const Color(0xFFD4AF37),
              ),
              onPressed: _toggleBookmark,
            ),
            IconButton(
              icon: const Icon(Icons.share, size: 26, color: Color(0xFFD4AF37)),
              onPressed: _shareMovie,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: ListView(
            children: [
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.network(
                      movie.posterUrl,
                      height: 210,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 197,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      color: const Color.fromARGB(239, 74, 67, 67),
                      child: Text(
                        'Releasing on ${movie.releaseDate}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '${movie.duration} · ${movie.genre}',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  movie.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
              const Text(
                'Review',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ...List.generate(
                    5,
                    (index) => Icon(
                      index < movie.rating.floor() ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFFD700),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${movie.rating.toStringAsFixed(1)})',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
