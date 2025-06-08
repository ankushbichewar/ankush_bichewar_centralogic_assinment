import 'package:flutter/material.dart';
import '../../models/movie_model.dart';
import '../widgets/movie_card.dart';
import '../details/details_page.dart';

class AllMoviesPage extends StatefulWidget {
  final List<Movie> movies;

  const AllMoviesPage({super.key, required this.movies});

  @override
  State<AllMoviesPage> createState() => _AllMoviesPageState();
}

class _AllMoviesPageState extends State<AllMoviesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _filteredMovies = [];

  @override
  void initState() {
    super.initState();
    _filteredMovies = widget.movies;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredMovies = widget.movies
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.navigate_before,
                      color: Color(0xFFD4AF37),
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'All Movies',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  const Spacer(),
                  // Search Box
                  Container(
                    height: 34,
                    width: 178,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD4AF37)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search,
                              color: Color(0xFFD4AF37), size: 18),
                          hintText: 'Search movie',
                          hintStyle: TextStyle(
                              color: Color(0xFFD4AF37), fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Movie Cards
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double cardWidth = constraints.maxWidth / 3 - 12;

                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 16,
                        children: _filteredMovies.map((movie) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailsPage(movie: movie),
                                ),
                              );
                            },
                            child: MovieCard(movie: movie, width: cardWidth),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
