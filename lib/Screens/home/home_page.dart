import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../blocs/movie_bloc.dart';
import '../../blocs/movie_event.dart';
import '../../blocs/movie_state.dart';
import '../details/details_page.dart';
import '../events/bookmark_page.dart';
import '../events/watchlist_page.dart';
import '../home/allmovies.dart';
import '../profile/profile.dart';
import '../widgets/movie_card.dart';
import '../../controllers/route_animation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> banners = [
    'assets/images/avatar.png',
    'assets/images/batman.jpg',
    'assets/images/captain.jpg',
    'assets/images/jack.jpg',
  ];

  int currentBanner = 0;

  void _onSearchChanged(BuildContext context) {
    BlocProvider.of<MovieBloc>(context).add(SearchMovies(_searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false, // Disable back navigation
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFD4AF37)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => _onSearchChanged(context),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Search movie',
                              hintStyle: TextStyle(color: Color(0xFFD4AF37)),
                              prefixIcon: Icon(Icons.search, color: Color(0xFFD4AF37)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.notifications_none, size: 35, color: Color(0xFFD4AF37)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Carousel
                CarouselSlider(
                  options: CarouselOptions(
                    height: 218,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentBanner = index;
                      });
                    },
                  ),
                  items: banners.map((imgPath) {
                    return Builder(
                      builder: (context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            imgPath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: currentBanner,
                    count:3,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Color(0xFFD4AF37),
                      dotColor: Colors.white24,
                      dotHeight: 6,
                      dotWidth: 6,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recommended Movies',
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final currentState = BlocProvider.of<MovieBloc>(context).state;
                          if (currentState is MovieLoaded) {
                            Navigator.push(
                              context,
                              RouteAnimations.slideFromRight(
                                AllMoviesPage(movies: currentState.movies),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'See All >',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Movie Cards
                BlocBuilder<MovieBloc, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                        ),
                      );
                    } else if (state is MovieLoaded) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final cardWidth = constraints.maxWidth / 3 - 12;
                            return Wrap(
                              spacing: 12,
                              runSpacing: 16,
                              children: state.movies.map((movie) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      RouteAnimations.fadeIn(DetailsPage(movie: movie)),
                                    );
                                  },
                                  child: MovieCard(movie: movie, width: cardWidth),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      );
                    } else if (state is MovieError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // Bottom Navigation
        bottomNavigationBar: SizedBox(
          height: 117,
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFFD4AF37),
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black87,
            iconSize: 30,
            selectedFontSize: 13,
            unselectedFontSize: 12,
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            onTap: (index) {
              switch (index) {
                case 1:
                  Navigator.push(context, RouteAnimations.slideFromRight(const WatchlistPage()));
                  break;
                case 2:
                  Navigator.push(context, RouteAnimations.slideFromRight(const BookmarkPage()));
                  break;
                case 3:
                  Navigator.push(context, RouteAnimations.slideFromRight(const UserProfilePage()));
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.movie_creation_outlined), label: 'Watchlist'),
              BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Bookmark'),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
