import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/main_navigation.dart';
import '../../../artwork/presentation/pages/artwork_detail_page.dart';
import '../../../artwork/presentation/widgets/favorite_heart_button.dart';
import '../../../favorites/presentation/pages/favorites_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../scan/presentation/pages/scan_page.dart';
import '../../../search/presentation/providers/artwork_search_provider.dart';
import '../../../search/presentation/widgets/artwork_search_filter_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _navIndex = 0;

  String _getUserName() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null && user.email != null) {
      return user.email!.split('@')[0];
    }
    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _navIndex,
        children: [
          _HomeFeed(userName: _getUserName()),
          const FavoritesPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: MainNavigation(
        currentIndex: _navIndex,
        onTap: (index) {
          setState(() {
            _navIndex = index;
          });
        },
      ),
      floatingActionButton: _navIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder<void>(
                    transitionDuration: const Duration(milliseconds: 320),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return FadeTransition(
                        opacity: CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                        ),
                        child: const ScanPage(),
                      );
                    },
                  ),
                );
              },
              backgroundColor: const Color(0xFF1A1A2E),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: Text(
                'Scan Art',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            )
          : null,
    );
  }
}

class _HomeFeed extends ConsumerStatefulWidget {
  const _HomeFeed({required this.userName});

  final String userName;

  @override
  ConsumerState<_HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends ConsumerState<_HomeFeed> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(artworkSearchProvider);
    final searchNotifier = ref.read(artworkSearchProvider.notifier);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hey, ${widget.userName} 👋',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        'Find your favorite masterpieces',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=hilda'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ArtworkSearchFilterBar(
                controller: _searchController,
                onQueryChanged: searchNotifier.setQuery,
                categories: searchState.categories,
                artists: searchState.artists,
                selectedCategory: searchState.selectedCategory,
                selectedArtist: searchState.selectedArtist,
                onCategoryChanged: searchNotifier.setCategory,
                onArtistChanged: searchNotifier.setArtist,
                onClear: searchNotifier.clearFilters,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Featured Exhibitions',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _buildFeaturedCard(index, isDarkMode);
                },
              ),
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Explore Artworks',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'View all',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF3F3DBB),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: searchState.filteredArtworks.isEmpty
                    ? const Center(child: Text('No artworks found'))
                    : MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 18,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: searchState.filteredArtworks.length,
                        itemBuilder: (context, index) {
                          return ArtworkCard(artwork: searchState.filteredArtworks[index]);
                        },
                      ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(int index, bool isDark) {
    final colors = [const Color(0xFF1A1A2E), const Color(0xFF42275A), const Color(0xFF2C3E50)];
    final titles = ['Digital Renaissance', 'Modern Sculpture', 'Abstract Flow'];

    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: colors[index],
        borderRadius: BorderRadius.circular(28),
        image: DecorationImage(
          image: NetworkImage('https://picsum.photos/seed/${index + 50}/400/250'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Live Event',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              titles[index],
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArtworkCard extends StatelessWidget {
  const ArtworkCard({super.key, required this.artwork});

  final Map<String, dynamic> artwork;

  @override
  Widget build(BuildContext context) {
    final title = (artwork['title'] ?? 'Untitled').toString();
    final artist = (artwork['artist_name'] ?? 'Unknown Artist').toString();
    final imageUrl = (artwork['image_url'] ?? '').toString();
    final artworkId = artwork['id'].toString();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ArtworkDetailPage(artwork: artwork)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: imageUrl.isEmpty
                    ? Container(height: 200, color: Colors.grey[300])
                    : Image.network(imageUrl, fit: BoxFit.cover),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: FavoriteHeartButton(artworkId: artworkId),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          Text(
            artist,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}