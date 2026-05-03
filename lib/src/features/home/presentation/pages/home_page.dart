import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              icon: const Icon(Icons.document_scanner_outlined),
              label: Text('Scan Artwork', style: Theme.of(context).textTheme.bodyMedium),
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

    if (_searchController.text != searchState.query) {
      _searchController.value = TextEditingValue(
        text: searchState.query,
        selection: TextSelection.collapsed(offset: searchState.query.length),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hey, ${widget.userName}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Explore, Discover, Enjoy',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.person, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ArtworkSearchFilterBar(
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
              const SizedBox(height: 24),
              Text(
                'Artworks',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              if (searchState.error != null)
                Text(
                  searchState.error!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.redAccent),
                ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: searchState.filteredArtworks.isEmpty
                    ? Padding(
                        key: const ValueKey<String>('empty'),
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No artworks match your current filters.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      )
                    : MasonryGridView.count(
                        key: ValueKey<int>(searchState.filteredArtworks.length),
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: searchState.filteredArtworks.length,
                        itemBuilder: (context, index) {
                          return ArtworkCard(artwork: searchState.filteredArtworks[index]);
                        },
                      ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class ArtworkCard extends StatefulWidget {
  const ArtworkCard({super.key, required this.artwork});

  final Map<String, dynamic> artwork;

  @override
  State<ArtworkCard> createState() => _ArtworkCardState();
}

class _ArtworkCardState extends State<ArtworkCard> {
  bool _previewMode = true;

  @override
  Widget build(BuildContext context) {
    final title = (widget.artwork['title'] ?? 'Untitled').toString();
    final artist = (widget.artwork['artist_name'] ?? 'Unknown Artist').toString();
    final imageUrl = (widget.artwork['image_url'] ?? '').toString();
    final priceRaw = widget.artwork['price'];
    final priceLabel = priceRaw == null ? 'Price on request' : 'Rp $priceRaw';
    final artworkId = widget.artwork['id'].toString();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ArtworkDetailPage(artwork: widget.artwork),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  child: AspectRatio(
                    aspectRatio: _previewMode ? 3 / 4 : 4 / 3,
                    child: imageUrl.isEmpty
                        ? const ColoredBox(color: Color(0xFFEFE9DE))
                        : Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: FavoriteHeartButton(artworkId: artworkId),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Preview',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                        ),
                        Transform.scale(
                          scale: 0.78,
                          child: Switch(
                            value: _previewMode,
                            activeTrackColor: AppTheme.primaryBlue,
                            onChanged: (value) {
                              setState(() {
                                _previewMode = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(artist, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 10),
                  Text(
                    priceLabel,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
